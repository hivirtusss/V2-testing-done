#!/usr/bin/env bash
# Build flash zip from user's working Drive base + banking crash fix + telegram mono.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${1:-$ROOT/user_file/user_working.zip}"
OUT="${2:-$ROOT/releases/virtus_v25_mono.zip}"
WORK="$(mktemp -d)"
STAGE="$(mktemp -d)"
trap 'rm -rf "$WORK" "$STAGE"' EXIT

python3 "$ROOT/scripts/patch_telegram_mono_dex.py" "$SRC" "$WORK/classes.dex"

unzip -q "$SRC" -d "$STAGE"
cp "$WORK/classes.dex" "$STAGE/classes.dex"
rm -rf "$STAGE/bin" "$STAGE/backups" "$STAGE/virtus_config" "$STAGE/classes.dex.enc" "$STAGE/decrypt_dex.sh" 2>/dev/null || true

cd "$STAGE"
chmod 755 post-fs-data.sh service.sh customize.sh refresh_pkglist.sh action.sh 2>/dev/null || true
rm -f "$OUT"
zip -qr "$OUT" .
echo "built $OUT ($(wc -c < "$OUT") bytes)"
echo "classes.dex: $(wc -c < "$STAGE/classes.dex") bytes"
