#!/usr/bin/env bash
# Working stack (Nov 7): monitoring card + inject + single systemd bot.
# Restore when VPS/APK/bot messes up again.
set -euo pipefail

ROOT="${SMS_DIR:-/opt/sms-monitor}"
BRANCH="cursor/monitoring-card-fix-8042"
TAG="virtus-monitor-working-nov7-8042"
EXPECTED_TAG="monitoring-instant-card-8042"

echo "==> Restore WORKING bot stack"
echo "    path:   $ROOT"
echo "    branch: $BRANCH"
echo "    git:    $TAG (fallback: branch tip)"

[ -d "$ROOT" ] || { echo "❌ $ROOT missing"; exit 1; }
cd "$ROOT"

cp -a .env "/root/sms-env.restore.$(date +%Y%m%d%H%M%S)" 2>/dev/null || true
cp -a sms_monitor.db "/root/sms-db.restore.$(date +%Y%m%d%H%M%S)" 2>/dev/null || true

systemctl stop sms-monitor 2>/dev/null || true
pkill -9 -f "${ROOT}/run.py" 2>/dev/null || true
rm -f "${ROOT}/.sms-monitor.pid"
[ -f "${ROOT}/start.sh" ] && mv "${ROOT}/start.sh" "${ROOT}/start.sh.OFF"
fuser -k 8000/tcp 2>/dev/null || true
sleep 2

git fetch origin "$BRANCH" --tags
git checkout "$BRANCH"
git reset --hard "$TAG" 2>/dev/null || git reset --hard "origin/$BRANCH"

python3 -m pip install -q -r requirements.txt
systemctl daemon-reload
systemctl enable sms-monitor
systemctl start sms-monitor
sleep 3

echo ""
echo "==> Check (expect deploy_tag=$EXPECTED_TAG, one run.py)"
pgrep -af "${ROOT}/run.py" || true
curl -sf "http://127.0.0.1:${PORT:-8000}/health" | python3 -m json.tool | grep -E 'deploy_tag|git_rev' || echo "health check failed"

echo ""
echo "Telegram: /stop → /fdy <device> → SIM tap → START"
echo "Do NOT run start.sh or vps-force-restart if it starts nohup again."
