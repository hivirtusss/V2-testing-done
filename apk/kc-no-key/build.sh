#!/usr/bin/env bash
# Patch KC GL from Drive APK: remove activation/key, login with id+password only.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
APK="${KC_APK:-/workspace/apk/drive-analysis/drive-app.apk}"
SOURCE="${KC_DECOMPILED:-/workspace/apk/drive-analysis/decompiled}"
BUILD="$ROOT/build"
OUT="$ROOT/kc-gl-no-key.apk"
APKTOOL="${APKTOOL:-java -jar /tmp/apktool.jar}"

if [ ! -d "$SOURCE" ]; then
  if [ ! -f "$APK" ]; then
    echo "Missing KC APK. Download Drive file to: $APK"
    exit 1
  fi
  mkdir -p "$(dirname "$SOURCE")"
  $APKTOOL d "$APK" -o "$SOURCE" -f
fi

rm -rf "$BUILD/decompiled"
mkdir -p "$BUILD"
cp -a "$SOURCE" "$BUILD/decompiled"

python3 "$ROOT/patch_no_activation.py" "$BUILD/decompiled"

$APKTOOL b "$BUILD/decompiled" -o "$BUILD/kc-gl-no-key-unsigned.apk"
cp "$BUILD/kc-gl-no-key-unsigned.apk" "$OUT"
echo "Built KC GL (no activation key): $OUT"
echo "Package unchanged: com.android.lc"
