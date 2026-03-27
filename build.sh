#!/usr/bin/env bash
# build.sh — SilkPage website build script
# Invokes XML Calabash 1.5.7 (XProc 1.0, Norman Walsh) with build.xpl.
#
# Phase 1 (Calabash/Saxon 12 HE):
#   layout.xml → autolayout.xml  via tools/docbook-xsl/website/autolayout.xsl
#
# Phase 2 (Calabash p:exec → Saxon 6.5.3):
#   index.xml + main.xsl → dist/website/ (chunked HTML)
#   Uses com.nwalsh.saxon.Website extension functions — requires Saxon 6.5.3.
#
# Usage:
#   ./build.sh              # build everything
#   ./build.sh --dry-run    # print java invocation without running it
set -euo pipefail

REPO="$(cd "$(dirname "$0")"; pwd)"
JLIB="$REPO/core/share/lib/java"
CALAB_DIR="$REPO/tools/calabash"

# Calabash 1.5.7 — xmlcalabash-1.5.7-120.jar + lib/Saxon-HE-12.3.jar, etc.
CALABASH_JAR="$CALAB_DIR/xmlcalabash-1.5.7-120.jar"
CALABASH_LIBS="$CALAB_DIR/lib"

SAXON653="$JLIB/saxon-6_5_3.jar"
RESOLVER="$JLIB/resolver-1_0.jar"

CATALOG="$REPO/core/cfg/catalog-resolved.xml"
WWW="$REPO/www/silkpage.markupware.com/src/xml/en"
OUTPUT="$REPO/dist/website/"

# ── Build Calabash classpath (main jar + all jars in lib/) ──────────────────

CALABASH_CP="$CALABASH_JAR"
for jar in "$CALABASH_LIBS"/*.jar; do
  CALABASH_CP="$CALABASH_CP:$jar"
done

# ── Preflight checks ────────────────────────────────────────────────────────

for f in "$CALABASH_JAR" "$SAXON653" "$RESOLVER" "$CATALOG" \
          "$WWW/layout.xml" "$WWW/index.xml" \
          "$REPO/core/src/xsl/silkpage/main.xsl" \
          "$REPO/tools/docbook-xsl/website/autolayout.xsl"; do
  if [[ ! -f "$f" ]]; then
    echo "ERROR: required file not found: $f" >&2
    exit 1
  fi
done

mkdir -p "$OUTPUT"

# ── Invocation ──────────────────────────────────────────────────────────────

CMD=(
  java
    -cp "$CALABASH_CP"
    -Dxml.catalog.files="$CATALOG"
    com.xmlcalabash.drivers.Main
    "$REPO/build.xpl"
    "layout=$WWW/layout.xml"
    "autolayout=$WWW/autolayout.xml"
    "saxon653=$SAXON653"
    "resolver=$RESOLVER"
    "catalog=$CATALOG"
    "source=$WWW/index.xml"
    "stylesheet=$REPO/core/src/xsl/silkpage/main.xsl"
    "output-root=$OUTPUT"
)

if [[ "${1:-}" == "--dry-run" ]]; then
  echo "DRY RUN — command that would be executed:"
  printf '  %s\n' "${CMD[@]}"
  exit 0
fi

echo "── SilkPage build ──────────────────────────────────────────────────────"
echo "  REPO:    $REPO"
echo "  CATALOG: $CATALOG"
echo "  OUTPUT:  $OUTPUT"
echo "────────────────────────────────────────────────────────────────────────"

"${CMD[@]}"

echo "────────────────────────────────────────────────────────────────────────"
echo "  Done — output in $OUTPUT"
