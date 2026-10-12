#!/usr/bin/env bash
# Restore known-good inject + uptime + background notify (v7 + bg inject fix).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

BRANCH="${VPS_BRANCH:-cursor/inject-resume-fix-8042}"
TAG="${VPS_STABLE_TAG:-virtus-inject-working-8042}"

echo "==> Restore stable Virtus inject stack"
echo "    branch: $BRANCH"
echo "    tag:    $TAG"

git fetch origin "$BRANCH" --tags
git checkout "$BRANCH" 2>/dev/null || git checkout -B "$BRANCH" "origin/$BRANCH"
git reset --hard "$TAG"

pip install -q -r requirements.txt
bash "$ROOT/scripts/vps-force-restart.sh"

echo ""
echo "==> Restored commit:"
git log -1 --oneline
echo ""
echo "APK (same tag build):"
echo "  https://raw.githubusercontent.com/hivirtusss/V2-testing-done/$BRANCH/apk/virtus-sms-module.apk"
echo "  file: $ROOT/apk/virtus-sms-module.apk"
echo ""
echo "Verify: curl -s http://127.0.0.1:\${PORT:-8000}/health | grep deploy_tag"
echo "  expected: apk-wake-v7-fast"
