#!/usr/bin/env bash
# Build v25 mono zip from EXACT user_upload.zip — only patch Telegram SMS format in dex.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/user_file/user_upload.zip"
OUT="$ROOT/releases/virtus_v25_mono.zip"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

python3 "$ROOT/scripts/patch_telegram_mono_dex.py" "$SRC" "$WORK/classes.dex"

STAGE="$(mktemp -d)"
trap 'rm -rf "$WORK" "$STAGE"' EXIT
unzip -q "$SRC" -d "$STAGE"
cp "$WORK/classes.dex" "$STAGE/classes.dex"

cd "$STAGE"
chmod 755 post-fs-data.sh service.sh customize.sh refresh_pkglist.sh action.sh 2>/dev/null || true
rm -f "$OUT"
zip -qr "$OUT" .
echo "built $OUT ($(wc -c < "$OUT") bytes)"
echo "classes.dex: $(wc -c < "$STAGE/classes.dex") bytes (user base + mono patch)"

ORIG_DEX=$(unzip -p "$SRC" classes.dex | md5sum | awk '{print $1}')
NEW_DEX=$(md5sum "$STAGE/classes.dex" | awk '{print $1}')
echo "dex changed: $ORIG_DEX -> $NEW_DEX (expected — FloatingMenu\$6 only)"
