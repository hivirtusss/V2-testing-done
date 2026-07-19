#!/usr/bin/env bash
# Build clean Virtus Module V3 zip — selected apps only, stable bubble, telegram format.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${1:-$ROOT/releases/virtus_module_v3.zip}"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

"$ROOT/scripts/build_safe_dex.sh" "$ROOT/extracted/classes.dex"

cp -a "$ROOT/extracted/." "$STAGE/"
rm -rf "$STAGE/bin" "$STAGE/backups" "$STAGE/virtus_config" "$STAGE/classes.dex.enc" 2>/dev/null || true

cd "$STAGE"
chmod 755 post-fs-data.sh service.sh customize.sh refresh_pkglist.sh action.sh 2>/dev/null || true
rm -f "$OUT"
zip -qr "$OUT" .
echo "built $OUT ($(wc -c < "$OUT") bytes)"
echo "classes.dex: $(wc -c < "$STAGE/classes.dex") bytes"
