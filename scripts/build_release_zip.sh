#!/usr/bin/env bash
# Ship user's original upload zip byte-for-byte — no edits, no extras.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
USER_ZIP="$ROOT/user_file/user_upload.zip"
OUT="$ROOT/releases/virtus_original.zip"

cp "$USER_ZIP" "$OUT"
cp "$USER_ZIP" "$ROOT/zygisk_floating_menu_hivirtus_selection.zip"
echo "original zip: $(wc -c < "$OUT") bytes"
unzip -p "$OUT" classes.dex | wc -c
