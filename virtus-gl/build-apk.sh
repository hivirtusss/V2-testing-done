#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SOURCE="${KC_SOURCE:-/workspace/apk/drive-analysis/decompiled}"
BUILD_DIR="$ROOT/build"
DECOMPILED="$BUILD_DIR/decompiled"
APKTOOL="${APKTOOL:-java -jar /tmp/apktool.jar}"

if [ ! -d "$SOURCE" ]; then
  echo "KC source missing: $SOURCE"
  echo "Place KC GL decompiled tree at apk/drive-analysis/decompiled"
  exit 1
fi

mkdir -p "$BUILD_DIR"

python3 "$ROOT/patch_rebrand.py" \
  --source "$SOURCE" \
  --output "$DECOMPILED" \
  ${SHUANQ_APP_ID:+--shuanq-app-id "$SHUANQ_APP_ID"} \
  ${SHUANQ_APP_KEY:+--shuanq-app-key "$SHUANQ_APP_KEY"}

$APKTOOL b "$DECOMPILED" -o "$BUILD_DIR/virtus-gl-unsigned.apk"

OUT="$ROOT/virtus-gl.apk"
cp "$BUILD_DIR/virtus-gl-unsigned.apk" "$OUT"
echo "Built: $OUT"
echo "Sign with your keystore before release:"
echo "  apksigner sign --ks virtus-gl.jks --out virtus-gl-signed.apk virtus-gl.apk"
