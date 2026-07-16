#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/user_file/virtus_app.apk"
OUT="$ROOT/releases/system_error_no_login.apk"
WORK="$ROOT/apk_no_login_build"
KEY="$ROOT/scripts/debug.keystore"

rm -rf "$WORK"
java -jar "$ROOT/apktool.jar" d -f "$SRC" -o "$WORK"
python3 "$ROOT/scripts/patch_skip_login_bundle.py" "$WORK/assets/index.android.bundle"
java -jar "$ROOT/apktool.jar" b "$WORK" -o "$ROOT/apk_no_login_unsigned.apk"

if [[ ! -f "$KEY" ]]; then
  keytool -genkeypair -v -keystore "$KEY" -alias debug -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass android -keypass android -dname "CN=Virtus Debug"
fi

"$ROOT/android-sdk/build-tools/34.0.0/apksigner" sign \
  --ks "$KEY" --ks-pass pass:android --key-pass pass:android \
  --out "$OUT" "$ROOT/apk_no_login_unsigned.apk"
rm -f "$ROOT/apk_no_login_unsigned.apk"
echo "built $OUT ($(wc -c < "$OUT") bytes)"
