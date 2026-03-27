#!/usr/bin/env bash
# dev/infra/ssl/cacert-setup.sh
#
# Retrieves the local CA certificate (and per-subdomain certs+keys) from
# 1Password and writes them to the SSL dotfile directory, protected by an
# exclusive file lock so concurrent invocations are safe.
#
# Directory layout written on disk:
#   ~/.config/lutino/ssl/
#     .cacert_path          ← dotfile: canonical cacert path (read by env.sh)
#     .lock                 ← POSIX advisory lock (fd 9 below)
#     cacert.pem            ← local CA cert (from 1Password)
#     lutino.io.crt         ← server cert for lutino.io
#     lutino.io.key         ← private key for lutino.io
#     app.lutino.io.crt
#     app.lutino.io.key
#     cdn.lutino.io.crt
#     cdn.lutino.io.key
#     sindoc.local.crt      ← optional local intranet certificate
#     sindoc.local.key
#
# 1Password item references (edit OP_VAULT / OP_ITEM_* to match your vault):
#   OP_VAULT                — name or UUID of your 1Password vault
#   OP_ITEM_CACERT          — item name for the local CA cert (PEM field)
#   OP_ITEM_CERT_<SUBDOMAIN> — item name per cert+key pair
#
# Usage:
#   ./dev/infra/ssl/cacert-setup.sh [--force]
#
# --force  : overwrite existing cert files even if they are fresh.
#
set -euo pipefail

# ── configuration ─────────────────────────────────────────────────────────────
OP_VAULT="${LUTINO_OP_VAULT:-lutino-dev}"
OP_ITEM_CACERT="${LUTINO_OP_ITEM_CACERT:-lutino-local-ca}"
SSL_DOMAINS="${LUTINO_SSL_DOMAINS:-lutino.io app.lutino.io cdn.lutino.io}"
SKIP_MISSING="${LUTINO_SSL_SKIP_MISSING:-false}"

SSL_DIR="${HOME}/.config/lutino/ssl"
CACERT_PATH_FILE="${SSL_DIR}/.cacert_path"
LOCKFILE="${SSL_DIR}/.lock"
CACERT="${SSL_DIR}/cacert.pem"

FORCE=false
[[ "${1:-}" == "--force" ]] && FORCE=true

# ── helpers ───────────────────────────────────────────────────────────────────
die()  { printf "cacert-setup: ERROR: %s\n" "$*" >&2; exit 1; }
info() { printf "cacert-setup: %s\n" "$*"; }

require_op() {
  command -v op >/dev/null 2>&1 \
    || die "1Password CLI 'op' not found. Install with: brew install 1password-cli"
  op whoami >/dev/null 2>&1 \
    || die "Not signed in to 1Password. Run: eval \$(op signin)"
}

# ── fetch_field op_ref out_file mode ─────────────────────────────────────────
# Reads a secret from 1Password and writes it atomically to out_file.
# op_ref examples:
#   "op://Vault/Item/field"
#   "op://Vault/Item/file/filename.pem"
fetch_field() {
  local op_ref="$1" out_file="$2" mode="${3:-0600}"
  local tmp_file
  tmp_file="$(mktemp "${out_file}.XXXXXX")"
  if ! op read "${op_ref}" > "${tmp_file}"; then
    rm -f "${tmp_file}"
    return 1
  fi
  chmod "${mode}" "${tmp_file}"
  mv "${tmp_file}" "${out_file}"
  info "wrote ${out_file}"
}

# ── acquire_lock (macOS-compatible lockdir approach) ──────────────────────────
# Uses `mkdir` atomicity: only one process can create a directory name at once.
LOCKDIR="${LOCKFILE}.d"
_LOCK_ACQUIRED=false

acquire_lock() {
  mkdir -p "${SSL_DIR}"
  chmod 0700 "${SSL_DIR}"
  local attempts=0
  while ! mkdir "${LOCKDIR}" 2>/dev/null; do
    attempts=$(( attempts + 1 ))
    [[ ${attempts} -lt 30 ]] || die "Could not acquire lock on ${LOCKDIR} after 30 s"
    sleep 1
  done
  printf "%d" "$$" > "${LOCKDIR}/pid"
  _LOCK_ACQUIRED=true
  info "lock acquired: ${LOCKDIR}"
}

release_lock() {
  if [[ "${_LOCK_ACQUIRED}" == true ]]; then
    rm -rf "${LOCKDIR}"
    _LOCK_ACQUIRED=false
  fi
}

# ── write_cacert_path_dotfile ─────────────────────────────────────────────────
write_cacert_path_dotfile() {
  printf "%s\n" "${CACERT}" > "${CACERT_PATH_FILE}"
  chmod 0600 "${CACERT_PATH_FILE}"
  info "dotfile updated: ${CACERT_PATH_FILE} → ${CACERT}"
}

# ── per-subdomain cert+key ────────────────────────────────────────────────────
fetch_subdomain_certs() {
  local subdomain vault_item crt_ref key_ref
  for subdomain in ${SSL_DOMAINS}; do
    vault_item="${subdomain//./-}"   # e.g. lutino-io, app-lutino-io
    crt_ref="op://${OP_VAULT}/${vault_item}/certificate"
    key_ref="op://${OP_VAULT}/${vault_item}/private_key"

    local crt="${SSL_DIR}/${subdomain}.crt"
    local key="${SSL_DIR}/${subdomain}.key"

    if [[ "${FORCE}" == true ]] || [[ ! -f "${crt}" ]]; then
      if ! fetch_field "${crt_ref}" "${crt}" "0644"; then
        if [[ "${SKIP_MISSING}" == "true" ]]; then
          info "skip (missing in 1Password): ${crt_ref}"
          continue
        fi
        die "Failed to read ${crt_ref} from 1Password"
      fi
    else
      info "skip (exists): ${crt}"
    fi
    if [[ "${FORCE}" == true ]] || [[ ! -f "${key}" ]]; then
      if ! fetch_field "${key_ref}" "${key}" "0600"; then
        if [[ "${SKIP_MISSING}" == "true" ]]; then
          info "skip (missing in 1Password): ${key_ref}"
          continue
        fi
        die "Failed to read ${key_ref} from 1Password"
      fi
    else
      info "skip (exists): ${key}"
    fi
  done
}

# ── main ──────────────────────────────────────────────────────────────────────
main() {
  require_op
  acquire_lock
  trap release_lock EXIT

  # CA cert
  if [[ "${FORCE}" == true ]] || [[ ! -f "${CACERT}" ]]; then
    fetch_field "op://${OP_VAULT}/${OP_ITEM_CACERT}/certificate" \
                "${CACERT}" "0644"
  else
    info "skip (exists): ${CACERT}"
  fi

  # Record the canonical cert path in the dotfile
  write_cacert_path_dotfile

  # Per-subdomain certs + keys
  fetch_subdomain_certs

  info "done. Source dev/env.sh to update LUTINO_CACERT in your shell."
}

main "$@"
