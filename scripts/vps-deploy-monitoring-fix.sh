#!/usr/bin/env bash
# Monitoring SUCCESS card fix — pull fix branch and restart (keeps .env + DB).
set -euo pipefail

ROOT="${SMS_DIR:-/opt/sms-monitor}"
BRANCH="cursor/monitoring-card-fix-8042"

if [ ! -d "$ROOT" ]; then
  echo "❌ $ROOT missing"
  exit 1
fi

cd "$ROOT"
cp -a .env /root/sms-env.before-deploy 2>/dev/null || true

systemctl stop sms-monitor 2>/dev/null || true
pkill -9 -f "${ROOT}/run.py" 2>/dev/null || true
fuser -k 8000/tcp 2>/dev/null || true
sleep 2

if [ ! -d .git ]; then
  echo "❌ Not a git checkout — clone fix branch into $ROOT"
  exit 1
fi

git fetch origin "$BRANCH"
git checkout "$BRANCH"
git reset --hard "origin/$BRANCH"

cp -a /root/sms-env.before-deploy .env 2>/dev/null || true

python3 -m pip install -q -r requirements.txt
bash scripts/vps-force-restart.sh

echo ""
echo "Expected deploy_tag: monitoring-instant-card-8042"
curl -sf "http://127.0.0.1:${PORT:-8000}/health" | python3 -m json.tool | grep -E 'deploy_tag|git_rev' || true
