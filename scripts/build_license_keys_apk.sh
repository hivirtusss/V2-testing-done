#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/user_file/virtus_app.apk"
OUT="$ROOT/releases/system_error_5keys.apk"
UNSIGNED="$ROOT/apk_license_keys_unsigned.apk"
ALIGNED="$ROOT/apk_license_keys_aligned.apk"
KEY="$ROOT/scripts/debug.keystore"
BT="$ROOT/android-sdk/build-tools/34.0.0"

python3 "$ROOT/scripts/build_license_keys_apk.py" "$SRC" "$UNSIGNED"
"$BT/zipalign" -f -p 4 "$UNSIGNED" "$ALIGNED"
rm -f "$UNSIGNED"

if [[ ! -f "$KEY" ]]; then
  keytool -genkeypair -v -keystore "$KEY" -alias debug -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass android -keypass android -dname "CN=Virtus Debug"
fi

"$BT/apksigner" sign \
  --ks "$KEY" --ks-pass pass:android --key-pass pass:android \
  --v1-signing-enabled true --v2-signing-enabled true --v3-signing-enabled true \
  --out "$OUT" "$ALIGNED"
rm -f "$ALIGNED"

"$BT/apksigner" verify --verbose "$OUT" | head -8
orig_dex=$(unzip -p "$SRC" classes.dex | md5sum | awk '{print $1}')
out_dex=$(unzip -p "$OUT" classes.dex | md5sum | awk '{print $1}')
echo "classes.dex match: $([[ "$orig_dex" == "$out_dex" ]] && echo OK || echo FAIL)"
echo "built $OUT"
