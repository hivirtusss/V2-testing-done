#!/usr/bin/env bash
# Deploy stable unified inject+OTP pull (all devices pool bind).
# On VPS as root: bash scripts/vps-deploy-stable-unified-8042.sh
set -euo pipefail

BRANCH="${BRANCH:-cursor/stable-sms-pool-pull-8042}"
INSTALL_DIR="${INSTALL_DIR:-/opt/sms-monitor}"
EXPECTED_TAG="${EXPECTED_TAG:-stable-unified-all-devices-8042}"

cd "$INSTALL_DIR"
cp .env /root/sms-env.before-deploy 2>/dev/null || true

git fetch origin "$BRANCH"
git checkout "$BRANCH"
git pull origin "$BRANCH"

cp /root/sms-env.before-deploy .env 2>/dev/null || true
pip3 install -q -r requirements.txt

systemctl restart sms-monitor
sleep 2

echo "=== service ==="
systemctl is-active sms-monitor

echo "=== health (expect deploy_tag=$EXPECTED_TAG) ==="
curl -sf "http://127.0.0.1:${PORT:-8000}/health" | python3 -m json.tool | grep -E 'deploy_tag|git_rev' || true