#!/usr/bin/env bash
# Restore kal wala working OTP bot code (commit d07c0d2) + restart.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
WORKING_OTP=d07c0d2
BRANCH="${VPS_BRANCH:-cursor/vps-apk-key-fix-8042}"

echo "==> OTP restore (working commit $WORKING_OTP)"

git fetch origin "$BRANCH" 2>/dev/null || true
git checkout "$BRANCH" 2>/dev/null || git checkout -b "$BRANCH" "origin/$BRANCH"
git pull origin "$BRANCH" 2>/dev/null || true

git checkout "$WORKING_OTP" -- app/firebase_sms_sync.py
echo "  restored app/firebase_sms_sync.py from $WORKING_OTP"

pip install -q -r requirements.txt 2>/dev/null || pip install -q -r requirements.txt

for svc in sms-monitor virtus-bot virtus; do
  if systemctl list-unit-files "${svc}.service" 2>/dev/null | grep -q "${svc}.service"; then
    sudo systemctl restart "$svc"
    echo "  restarted $svc"
    break
  fi
done

sleep 2
echo "==> health"
curl -sf "http://127.0.0.1:${PORT:-8000}/health" | python3 -m json.tool || true

echo ""
echo "Bot pe: /stopmonitor  phir  /startmonitor"
echo "Phir naya OTP bhejo — bot card aana chahiye."
