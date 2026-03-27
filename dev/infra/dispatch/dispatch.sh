#!/usr/bin/env bash
# dev/infra/dispatch/dispatch.sh
#
# MIME-type lambda dispatcher.
#
# Each "action" (script/file) is dispatched to a handler selected by its MIME
# type, looked up via a case-based dispatch table.  The handler is called as a
# lambda — invoked with the action file as its argument.
#
# Supported MIME types (extend handler_for() below to add more):
#   text/x-sh                → sh
#   text/x-shellscript       → bash
#   application/x-racket     → racket
#   text/x-racket            → racket
#   application/x-singine    → singine  (set SINGINE_BIN to override)
#   application/javascript   → node
#   text/x-python            → python3
#   text/x-ruby              → ruby
#   text/x-perl              → perl
#   text/x-awk               → awk -f
#
# Usage:
#   dispatch.sh <file> [arg ...]
#   dispatch.sh --mime <mime-type> <file> [arg ...]   # override detection
#   dispatch.sh --list                                # list handlers
#   dispatch.sh --quicktest [args]                    # run quick tests
#
set -euo pipefail

DISPATCH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── dispatch table (case-based, bash 3.2 compatible) ──────────────────────────
handler_for() {
  # handler_for <mime-type>  →  prints handler string or returns 1
  local mime="$1"
  case "${mime}" in
    text/x-sh|application/x-sh)           printf "sh" ;;
    text/x-shellscript|application/x-shellscript|text/x-bash|application/x-bash)
                                           printf "bash" ;;
    text/x-racket|application/x-racket)   printf "racket" ;;
    application/x-singine)                printf "%s" "${SINGINE_BIN:-singine}" ;;
    application/javascript|text/javascript) printf "node" ;;
    text/x-python|application/x-python|text/x-script.python) printf "python3" ;;
    text/x-ruby|application/x-ruby)       printf "ruby" ;;
    text/x-perl|application/x-perl)       printf "perl" ;;
    text/x-awk|application/x-awk)         printf "awk -f" ;;
    *) return 1 ;;
  esac
}

list_handlers() {
  printf "%-35s %s\n" "MIME type" "Handler"
  printf "%-35s %s\n" "---------" "-------"
  while IFS= read -r mime; do
    h="$(handler_for "${mime}" 2>/dev/null)" || h="(none)"
    printf "%-35s %s\n" "${mime}" "${h}"
  done <<'EOF'
text/x-sh
application/x-sh
text/x-shellscript
application/x-shellscript
text/x-bash
application/x-bash
text/x-racket
application/x-racket
application/x-singine
application/javascript
text/javascript
text/x-python
application/x-python
text/x-script.python
text/x-ruby
application/x-ruby
text/x-perl
application/x-perl
text/x-awk
application/x-awk
EOF
}

# ── helpers ───────────────────────────────────────────────────────────────────
die()  { printf "dispatch: ERROR: %s\n" "$*" >&2; exit 1; }
info() { printf "dispatch: %s\n" "$*"; }

# detect_mime <file> → prints MIME type string
detect_mime() {
  local f="$1"

  # 1. file(1) --mime-type (skip ambiguous results)
  if command -v file >/dev/null 2>&1; then
    local m
    m="$(file --mime-type -b "${f}" 2>/dev/null || true)"
    case "${m}" in
      text/plain|application/octet-stream|inode/*) : ;;  # fall through
      "") : ;;
      *) printf "%s" "${m}"; return ;;
    esac
  fi

  # 2. Shebang inspection
  local first_line
  first_line="$(head -1 "${f}" 2>/dev/null || true)"
  case "${first_line}" in
    "#!/usr/bin/env racket"*|"#lang racket"*) printf "application/x-racket";  return ;;
    "#!/usr/bin/env bash"*|"#!/bin/bash"*)    printf "text/x-shellscript";    return ;;
    "#!/bin/sh"*|"#!/usr/bin/env sh"*)        printf "text/x-sh";             return ;;
    "#!/usr/bin/env node"*|"#!/usr/bin/node"*) printf "application/javascript"; return ;;
    "#!/usr/bin/env python"*|"#!/usr/bin/python"*) printf "text/x-python";    return ;;
    "#!/usr/bin/env ruby"*|"#!/usr/bin/ruby"*)     printf "text/x-ruby";      return ;;
    "#!/usr/bin/env perl"*|"#!/usr/bin/perl"*)     printf "text/x-perl";      return ;;
    "#!/usr/bin/env singine"*)  printf "application/x-singine"; return ;;
  esac

  # 3. Extension fallback
  case "${f##*.}" in
    sh)   printf "text/x-sh";              return ;;
    bash) printf "text/x-shellscript";     return ;;
    rkt)  printf "application/x-racket";   return ;;
    js)   printf "application/javascript"; return ;;
    py)   printf "text/x-python";          return ;;
    rb)   printf "text/x-ruby";            return ;;
    pl)   printf "text/x-perl";            return ;;
    awk)  printf "text/x-awk";             return ;;
    sng)  printf "application/x-singine";  return ;;
  esac

  die "cannot detect MIME type for: ${f}"
}

# lambda <mime> <file> [args...] — invoke handler as a lambda
lambda() {
  local mime="$1"; shift
  local file="$1"; shift

  local handler
  handler="$(handler_for "${mime}")" \
    || die "no handler registered for MIME type: ${mime}"

  # Verify first word of handler is on PATH
  local interp
  interp="${handler%% *}"
  command -v "${interp}" >/dev/null 2>&1 \
    || die "interpreter not found: ${interp}  (handler: ${handler})"

  info "dispatch ${mime} → ${handler} ${file}"
  # shellcheck disable=SC2086
  exec ${handler} "${file}" "$@"
}

# ── main ──────────────────────────────────────────────────────────────────────
main() {
  local mime_override=""

  case "${1:-}" in
    --list)
      list_handlers
      exit 0
      ;;
    --quicktest)
      shift
      exec "${DISPATCH_DIR}/quicktest" "$@"
      ;;
    --mime)
      [[ $# -ge 3 ]] || die "usage: dispatch.sh --mime <mime-type> <file>"
      mime_override="$2"
      shift 2
      ;;
    "")
      die "usage: dispatch.sh [--mime <type>] <file> [args...]"
      ;;
  esac

  local file="$1"; shift
  [[ -f "${file}" ]] || die "file not found: ${file}"

  local mime="${mime_override:-$(detect_mime "${file}")}"
  lambda "${mime}" "${file}" "$@"
}

main "$@"
