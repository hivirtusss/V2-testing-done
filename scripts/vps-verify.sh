#!/usr/bin/env bash
# Check VPS has new monitoring card + bot code (not old Firebase-live card).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "==> git"
git rev-parse --short HEAD 2>/dev/null || echo "unknown"

echo ""
echo "==> monitoring card code"
if grep -q "Firebase live" app/device_ui.py 2>/dev/null; then
  echo "  OLD CARD (Firebase live) — UPDATE REQUIRED"
  exit 1
fi
if grep -q "Real SMS" app/device_ui.py 2>/dev/null; then
  echo "  NEW CARD (Real SMS /mynum) OK"
else
  echo "  WARN: Real SMS line not found"
fi

echo ""
echo "==> health"
curl -sf "http://127.0.0.1:${PORT:-8000}/health" | python3 -m json.tool || echo "  bot not reachable"

echo ""
if curl -sf "http://127.0.0.1:${PORT:-8000}/health" 2>/dev/null | grep -q deploy_tag; then
  echo "  health deploy_tag OK (naya bot running)"
else
  echo "  OLD BOT STILL RUNNING — run: bash scripts/vps-force-restart.sh"
  exit 1
fi

echo ""
echo "Expected: deploy_tag=apk-wake-v3, card has Real SMS, no Firebase live"
