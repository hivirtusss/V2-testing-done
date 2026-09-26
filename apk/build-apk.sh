#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

if [ -f "$ROOT/../.env" ]; then
  set -a
  # shellcheck disable=SC1091
  source "$ROOT/../.env"
  set +a
fi

APKTOOL="${APKTOOL:-$ROOT/apktool.jar}"
SIGNER="${SIGNER:-$ROOT/uber-apk-signer.jar}"

if [ ! -f "$APKTOOL" ]; then
  echo "Downloading apktool..."
  curl -fsSL -o "$APKTOOL" \
    "https://github.com/iBotPeaches/Apktool/releases/download/v2.9.3/apktool_2.9.3.jar"
fi

echo "Building Virtus SMS Module APK..."
python3 "$ROOT/build_astik_minimal.py"
python3 "$ROOT/patch_virtus_branding.py"
python3 "$ROOT/patch_60min_runtime.py"
python3 "$ROOT/patch_fast_poll.py"
python3 "$ROOT/generate_icons.py"
java -jar "$APKTOOL" b virtus_decompiled -o virtus-unsigned.apk

if [ ! -f "$SIGNER" ]; then
  echo "Downloading uber-apk-signer..."
  curl -fsSL -o "$SIGNER" \
    "https://github.com/patrickfav/uber-apk-signer/releases/download/v1.3.0/uber-apk-signer-1.3.0.jar"
fi

KEYSTORE="$ROOT/virtus.keystore"
if [ ! -f "$KEYSTORE" ]; then
  echo "Creating virtus.keystore..."
  keytool -genkeypair -v \
    -keystore "$KEYSTORE" \
    -alias virtus \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -storepass virtus123 -keypass virtus123 \
    -dname "CN=Virtus Module, OU=APK, O=Virtus, L=NA, ST=NA, C=IN"
fi

java -jar "$SIGNER" \
  --apks virtus-unsigned.apk \
  --ks virtus.keystore \
  --ksAlias virtus \
  --ksPass virtus123 \
  --ksKeyPass virtus123 \
  --allowResign \
  --overwrite

cp virtus-unsigned.apk virtus-sms-module.apk
cp virtus-unsigned.apk astik-bot-module.apk
echo "Done: virtus-sms-module.apk (Virtus UI + same working core)"
