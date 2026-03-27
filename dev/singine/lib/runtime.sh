#!/usr/bin/env bash
# dev/singine/lib/runtime.sh — shared runtime for all .sng commands
#
# Sourced by the sng runner AND by individual .sng files.
# Provides: logging, 1Password helpers, TOTP, QR generation, data-model utils.

# ── terminal output ────────────────────────────────────────────────────────────
_SNG_BOLD='\033[1m'; _SNG_RESET='\033[0m'
_SNG_GREEN='\033[0;32m'; _SNG_YELLOW='\033[0;33m'; _SNG_RED='\033[0;31m'
_SNG_CYAN='\033[0;36m'; _SNG_BLUE='\033[0;34m'

sng_head()  { [[ -t 1 ]] && printf "${_SNG_BOLD}${_SNG_BLUE}%s${_SNG_RESET}\n" "$*" || printf "%s\n" "$*"; }
sng_info()  { [[ -t 2 ]] && printf "${_SNG_CYAN}sng:${_SNG_RESET} %s\n" "$*" >&2 || printf "sng: %s\n" "$*" >&2; }
sng_ok()    { [[ -t 1 ]] && printf "${_SNG_GREEN}✓${_SNG_RESET} %s\n" "$*" || printf "ok: %s\n" "$*"; }
sng_warn()  { [[ -t 2 ]] && printf "${_SNG_YELLOW}warn:${_SNG_RESET} %s\n" "$*" >&2 || printf "warn: %s\n" "$*" >&2; }
sng_err()   { [[ -t 2 ]] && printf "${_SNG_RED}error:${_SNG_RESET} %s\n" "$*" >&2 || printf "error: %s\n" "$*" >&2; }
sng_die()   { sng_err "$*"; exit 1; }
sng_step()  { [[ -t 1 ]] && printf "${_SNG_YELLOW}→${_SNG_RESET} %s\n" "$*" || printf "  %s\n" "$*"; }

# ── environment ───────────────────────────────────────────────────────────────
# Source dev/env.sh if SILKPAGE_PROJECT_ROOT is not set
if [[ -z "${SILKPAGE_PROJECT_ROOT:-}" ]]; then
  _SNG_PROJ="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../../.." && pwd)"
  if [[ -f "${_SNG_PROJ}/dev/env.sh" ]]; then
    # shellcheck disable=SC1090
    . "${_SNG_PROJ}/dev/env.sh" 2>/dev/null || true
    SILKPAGE_PROJECT_ROOT="${_SNG_PROJ}"
    export SILKPAGE_PROJECT_ROOT
  fi
fi

LUTINO_SSL_DIR="${HOME}/.config/lutino/ssl"
LUTINO_TOTP_DIR="${HOME}/.config/lutino/totp"

# ── 1Password helpers ──────────────────────────────────────────────────────────
# op_require: die if not signed in
op_require() {
  command -v op >/dev/null 2>&1 \
    || sng_die "1Password CLI 'op' not found. Install: brew install 1password-cli"
  op whoami >/dev/null 2>&1 \
    || sng_die "Not signed in to 1Password. Run: eval \$(op signin)"
}

# op_get_field <vault> <item> <field> → value
op_get_field() {
  local vault="$1" item="$2" field="$3"
  op read "op://${vault}/${item}/${field}"
}

# op_get_otp <vault> <item> → current TOTP code
op_get_otp() {
  local vault="$1" item="$2"
  op item get "${item}" --vault="${vault}" --otp 2>/dev/null \
    || op item get "${item}" --otp 2>/dev/null
}

# op_totp_uri <vault> <item> → otpauth:// URI (for QR generation)
op_totp_uri() {
  local vault="$1" item="$2"
  op item get "${item}" --vault="${vault}" --format=json 2>/dev/null \
    | python3 -c "
import sys, json
data = json.load(sys.stdin)
for f in data.get('fields', []):
    if f.get('type') == 'OTP':
        print(f.get('totp', f.get('value', '')))
        break
" 2>/dev/null || true
}

# ── TOTP helpers ───────────────────────────────────────────────────────────────
# Generate a TOTP secret (base32, 20 bytes = 160 bits)
totp_gen_secret() {
  python3 - <<'PYEOF'
import base64, os
raw = os.urandom(20)
print(base64.b32encode(raw).decode().rstrip('='))
PYEOF
}

# Build otpauth:// URI from components
# totp_build_uri <secret> <account> <issuer>
totp_build_uri() {
  local secret="$1" account="$2" issuer="${3:-lutino.io}"
  # URL-encode account and issuer (simple version — handles spaces and @)
  local enc_account enc_issuer
  enc_account="$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "${account}")"
  enc_issuer="$(python3  -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "${issuer}")"
  printf "otpauth://totp/%s:%s?secret=%s&issuer=%s&algorithm=SHA1&digits=6&period=30" \
    "${enc_issuer}" "${enc_account}" "${secret}" "${enc_issuer}"
}

# Verify a TOTP code against a secret (±1 window)
# totp_verify <secret> <code> → exit 0 if valid
totp_verify() {
  local secret="$1" code="$2"
  python3 - "${secret}" "${code}" <<'PYEOF'
import sys, hmac, hashlib, struct, time, base64

def hotp(secret, counter):
    key = base64.b32decode(secret.upper().ljust((len(secret)+7)//8*8, '='))
    msg = struct.pack('>Q', counter)
    h   = hmac.new(key, msg, hashlib.sha1).digest()
    o   = h[-1] & 0x0f
    return str((struct.unpack('>I', h[o:o+4])[0] & 0x7fffffff) % 1000000).zfill(6)

secret, code = sys.argv[1], sys.argv[2].replace(' ', '')
t = int(time.time()) // 30
for window in (t-1, t, t+1):
    if hotp(secret, window) == code:
        print("valid")
        sys.exit(0)
print("invalid")
sys.exit(1)
PYEOF
}

# ── QR code rendering ──────────────────────────────────────────────────────────
# qr_display <uri>  — display QR in terminal (multiple methods, graceful fallback)
qr_display() {
  local uri="$1" label="${2:-Scan to add to Authenticator}"

  printf "\n%s\n\n" "${label}"

  # Method 1: qrencode (brew install qrencode)
  if command -v qrencode >/dev/null 2>&1; then
    qrencode -t UTF8 -o - "${uri}"
    return
  fi

  # Method 2: python qrcode library (pip3 install qrcode)
  if python3 -c "import qrcode" 2>/dev/null; then
    python3 - "${uri}" <<'PYEOF'
import qrcode, sys
qr = qrcode.QRCode(border=1)
qr.add_data(sys.argv[1])
qr.make(fit=True)
qr.print_ascii(invert=True)
PYEOF
    return
  fi

  # Method 3: curl to qrcode API (requires internet — last resort)
  sng_warn "qrencode and qrcode library not found."
  sng_warn "Install:  brew install qrencode"
  sng_warn "      or: pip3 install qrcode"
  printf "\nURI (paste into authenticator app manually):\n%s\n\n" "${uri}"
}

# ── lockdir helper (macOS-compatible) ─────────────────────────────────────────
lockdir_acquire() {
  local lockdir="$1" timeout="${2:-30}"
  local t=0
  while ! mkdir "${lockdir}" 2>/dev/null; do
    t=$(( t + 1 ))
    [[ ${t} -lt ${timeout} ]] || sng_die "timeout waiting for lock: ${lockdir}"
    sleep 1
  done
  printf "%d" "$$" > "${lockdir}/pid"
}

lockdir_release() {
  local lockdir="$1"
  rm -rf "${lockdir}" 2>/dev/null || true
}

# ── data model: entity / attribute registry (in-memory, sourced from model/) ──
# Used by model/collibra-bridge.sng; commands declare their model refs in #: headers.
SNG_ENTITIES=""
SNG_ATTRIBUTES=""
SNG_CODESETS=""
SNG_MASTER_OBJECTS=""
SNG_REF_OBJECTS=""

model_register_entity()    { SNG_ENTITIES="${SNG_ENTITIES} $1"; }
model_register_attribute() { SNG_ATTRIBUTES="${SNG_ATTRIBUTES} $1"; }
model_register_codeset()   { SNG_CODESETS="${SNG_CODESETS} $1"; }
model_register_master()    { SNG_MASTER_OBJECTS="${SNG_MASTER_OBJECTS} $1"; }
model_register_reference() { SNG_REF_OBJECTS="${SNG_REF_OBJECTS} $1"; }
