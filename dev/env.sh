#!/usr/bin/env bash
# dev/env.sh — Lutino.io development environment bootstrap
# Source this file: . dev/env.sh
#
# Sets JAVA_HOME (via SDKMAN when available), SILKPAGE_HOME,
# and common dev paths.

set -euo pipefail

# ── Java / SDKMAN ─────────────────────────────────────────────────────────────
if [ -d "${HOME}/.sdkman/candidates/java/current" ]; then
  export JAVA_HOME="${HOME}/.sdkman/candidates/java/current"
elif /usr/libexec/java_home > /dev/null 2>&1; then
  export JAVA_HOME="$(/usr/libexec/java_home)"
else
  echo "ERROR: cannot locate JAVA_HOME" >&2
  return 1 2>/dev/null || exit 1
fi

export PATH="${JAVA_HOME}/bin:${PATH}"

# ── SilkPage home ─────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export SILKPAGE_PROJECT_ROOT="$(dirname "${SCRIPT_DIR}")"
export SILKPAGE_HOME="${SILKPAGE_PROJECT_ROOT}/core"

# ── Lutino SSL dotfile path ────────────────────────────────────────────────────
LUTINO_SSL_DIR="${HOME}/.config/lutino/ssl"
export LUTINO_CACERT_PATH_FILE="${LUTINO_SSL_DIR}/.cacert_path"
export LUTINO_LOCKFILE="${LUTINO_SSL_DIR}/.lock"

# Read the actual cert path from the dotfile (if it exists)
if [ -f "${LUTINO_CACERT_PATH_FILE}" ]; then
  export LUTINO_CACERT="$(cat "${LUTINO_CACERT_PATH_FILE}")"
else
  export LUTINO_CACERT="${LUTINO_SSL_DIR}/cacert.pem"
fi

# ── 1Password ─────────────────────────────────────────────────────────────────
# Ensure op CLI is on PATH (Homebrew location on Apple Silicon)
if [ -x "/opt/homebrew/bin/op" ]; then
  export PATH="/opt/homebrew/bin:${PATH}"
fi

# ── Print summary ─────────────────────────────────────────────────────────────
printf "env: JAVA_HOME      = %s\n"  "${JAVA_HOME}"
printf "env: SILKPAGE_HOME  = %s\n"  "${SILKPAGE_HOME}"
printf "env: LUTINO_CACERT  = %s\n"  "${LUTINO_CACERT}"
printf "env: op             = %s\n"  "$(command -v op 2>/dev/null || echo '(not found)')"
printf "env: java           = %s\n"  "$(java -version 2>&1 | head -1)"
