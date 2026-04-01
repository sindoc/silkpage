#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.."; pwd)"
OUT="$ROOT/dist/website/docs/audio/index.html"

printf "test-case-01: validating audio feature source files\n"
xmllint --noout \
  "$ROOT/core/src/xsl/common/main.xsl" \
  "$ROOT/www/silkpage.markupware.com/src/xml/en/docs/audio.xml"

printf "test-case-01: building website\n"
"$ROOT/build.sh" >/tmp/silkpage-test-case-01-build.log 2>&1

if [[ ! -f "$OUT" ]]; then
  printf "FAIL: expected output file not found: %s\n" "$OUT" >&2
  exit 1
fi

printf "test-case-01: checking rendered HTML5 audio markup\n"
grep -q '<audio controls="controls" preload="metadata">' "$OUT"
grep -q '<source src="/media/example.ogg" type="audio/ogg"></source>' "$OUT"
grep -q '<source src="/media/example.mp3" type="audio/mpeg"></source>' "$OUT"
grep -q '<track kind="captions" src="/media/example.en.vtt" srclang="en" label="English"></track>' "$OUT"

printf "PASS: test-case-01 audio rendering verified\n"
