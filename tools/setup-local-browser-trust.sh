#!/usr/bin/env bash
set -euo pipefail

CA_CERT="${HOME}/.config/lutino/ssl/cacert.pem"
KEYCHAIN="${HOME}/Library/Keychains/login.keychain-db"
FIREFOX_ROOT="${HOME}/Library/Application Support/Firefox"
PROFILES_INI="${FIREFOX_ROOT}/profiles.ini"

die() {
  printf "setup-local-browser-trust: ERROR: %s\n" "$*" >&2
  exit 1
}

info() {
  printf "setup-local-browser-trust: %s\n" "$*"
}

[[ -f "${CA_CERT}" ]] || die "missing CA cert: ${CA_CERT}"
[[ -f "${PROFILES_INI}" ]] || die "missing Firefox profiles.ini: ${PROFILES_INI}"

security add-trusted-cert -d -r trustRoot -k "${KEYCHAIN}" "${CA_CERT}" >/dev/null 2>&1 \
  || security add-trusted-cert -r trustRoot -k "${KEYCHAIN}" "${CA_CERT}" >/dev/null 2>&1 \
  || die "failed to trust ${CA_CERT} in ${KEYCHAIN}"
info "trusted root CA in macOS login keychain"

PROFILE_PATHS="$(
  awk '
    function flush_profile() {
      if (section ~ /^\[Profile/ && is_default == 1 && profile_path != "") {
        print profile_path
      }
      section=""
      profile_path=""
      is_default=0
    }
    /^\[/ {
      flush_profile()
      section=$0
      next
    }
    section ~ /^\[Profile/ && /^Path=Profiles\// {
      profile_path=$0
      sub(/^Path=Profiles\//, "", profile_path)
      next
    }
    section ~ /^\[Profile/ && /^Default=1$/ {
      is_default=1
      next
    }
    section ~ /^\[Install/ && /^Default=Profiles\// {
      install_path=$0
      sub(/^Default=Profiles\//, "", install_path)
      print install_path
      next
    }
    END {
      flush_profile()
    }
  ' "${PROFILES_INI}" | awk '!seen[$0]++'
)"

printf "%s\n" "${PROFILE_PATHS}" | while IFS= read -r rel; do
  [[ -n "${rel}" ]] || continue
  profile_dir="${FIREFOX_ROOT}/Profiles/${rel}"
  user_js="${profile_dir}/user.js"
  [[ -d "${profile_dir}" ]] || continue

  touch "${user_js}"
  if ! grep -q 'security.enterprise_roots.enabled' "${user_js}"; then
    printf 'user_pref("security.enterprise_roots.enabled", true);\n' >> "${user_js}"
    info "enabled enterprise roots in ${user_js}"
  else
    info "enterprise roots already configured in ${user_js}"
  fi
done

info "done; restart Firefox and Chrome"
