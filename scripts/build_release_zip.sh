#!/usr/bin/env bash
# Ship EXACT user upload zip — bubble fix (244248 dex, no patches, no APK extras).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$ROOT/zygisk_floating_menu_hivirtus_selection.zip"
USER_ZIP="$ROOT/user_file/user_upload.zip"

cp "$USER_ZIP" "$OUT"
# Refresh module.prop description only
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
unzip -q "$OUT" -d "$TMP"
cp "$ROOT/extracted/module.prop" "$TMP/module.prop"
rm -f "$OUT"
(cd "$TMP" && zip -r "$OUT" .)
cp "$OUT" "$ROOT/releases/virtus_v25_bubble_only.zip"
echo "bubble zip: $(wc -c < "$OUT") bytes"
unzip -p "$OUT" classes.dex | wc -c
