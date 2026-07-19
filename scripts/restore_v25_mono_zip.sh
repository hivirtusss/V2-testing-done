#!/usr/bin/env bash
# Restore working virtus_v25_mono.zip (244216-byte dex, bubble + telegram mono).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/releases/virtus_v25_mono.zip"
BASE="$ROOT/releases/zygisk_floating_menu_hivirtus_selection.zip"
USER_ZIP="$ROOT/user_file/user_upload.zip"

mkdir -p "$ROOT/user_file"
if [ ! -f "$USER_ZIP" ]; then
  cp "$BASE" "$USER_ZIP"
fi

"$ROOT/scripts/build_v25_mono_zip.sh"
echo "Restored $OUT — flash this, not virtus_module_v3.zip, for v25 bubble."
