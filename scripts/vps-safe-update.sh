#!/usr/bin/env bash
# Safe VPS update: OTP + channel + inject bot logic UNTOUCHED, UI/autostop/mynum + fresh APK.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
ENV_FILE="$ROOT/.env"

BRANCH="${VPS_BRANCH:-cursor/inject-resume-fix-8042}"

echo "==> Virtus safe update (branch: $BRANCH)"
echo "    OTP poll + phone inject = branch as-is (do NOT lock old d07c0d2)"
echo "    channel_relay.py + inject queue = branch as-is"

if [ -f "$ENV_FILE" ]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
fi

echo "==> git fetch + checkout (discard old VPS local edits)"
git fetch origin "$BRANCH"
git checkout "$BRANCH" 2>/dev/null || git checkout -B "$BRANCH" "origin/$BRANCH"
git reset --hard "origin/$BRANCH"
git clean -fd apk/virtus_decompiled/ 2>/dev/null || true

echo "==> python deps"
pip install -q -r requirements.txt

echo "==> build APK (Astik core + base-e3797 config DB)"
export APK_CONFIG_DB="${APK_CONFIG_DB:-https://base-e3797-default-rtdb.firebaseio.com}"
export DEFAULT_CONFIG_DB="$APK_CONFIG_DB"
(cd apk && bash build-apk.sh)

echo "==> force restart bot (kill stale process + systemd)"
bash "$ROOT/scripts/vps-force-restart.sh"

BASE="${PUBLIC_BASE_URL:-http://127.0.0.1:${PORT:-8000}}"
APK_LOCAL="$ROOT/apk/virtus-sms-module.apk"

echo ""
echo "==> verify deploy"
bash "$ROOT/scripts/vps-verify.sh" || true

echo ""
echo "=========================================="
echo " DONE — OTP / channel / inject bot = safe"
echo "=========================================="
echo "Verify: curl -s http://127.0.0.1:${PORT:-8000}/health | grep deploy_tag"
echo "  must show: apk-wake-v5"
echo "APK install (phone pe naya module):"
echo "  ${BASE%/}/download/apk"
echo "  file: $APK_LOCAL"
echo ""
echo "Bot flow:"
echo "  /key KEY-XXXX  →  /a device  →  /mynum phone  →  /startmonitor"
echo "  15 min baad stop → /startmonitor dubara"
echo "  APK: START SERVICE ON + same KEY + root"
echo ""
