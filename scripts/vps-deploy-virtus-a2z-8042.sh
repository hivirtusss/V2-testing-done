#!/usr/bin/env bash
# VPS: full Virtus SMS monitor bundle (SIM numbers + monitoring + CHACHA JI recharge test).
# Run on server as root: bash scripts/vps-deploy-virtus-a2z-8042.sh
set -euo pipefail

STABLE_BRANCH="${STABLE_BRANCH:-cursor/virtus-a2z-stable-8042}"
INSTALL_DIR="${INSTALL_DIR:-/opt/sms-monitor}"

cd "$INSTALL_DIR"
cp .env /root/env.keep 2>/dev/null || true

git fetch origin "$STABLE_BRANCH"
git checkout "$STABLE_BRANCH"
git pull origin "$STABLE_BRANCH"

cp /root/env.keep .env 2>/dev/null || true
pip3 install -q -r requirements.txt

systemctl restart sms-monitor
sleep 2
echo "=== health ==="
curl -s http://127.0.0.1:8000/health || true
echo ""
echo "Expected deploy_tag: recharge-chacha-sim-8042"
systemctl is-active sms-monitor
