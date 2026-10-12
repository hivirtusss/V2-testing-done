#!/usr/bin/env bash
# Restart bot with current branch OTP code (bot card + /mynum phone inject).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
BRANCH="${VPS_BRANCH:-cursor/inject-resume-fix-8042}"

echo "==> OTP reload from branch $BRANCH (includes phone inject)"

git fetch origin "$BRANCH" 2>/dev/null || true
git checkout "$BRANCH" 2>/dev/null || git checkout -b "$BRANCH" "origin/$BRANCH"
git pull origin "$BRANCH" 2>/dev/null || true

pip install -q -r requirements.txt 2>/dev/null || pip install -q requirements.txt

bash "$ROOT/scripts/vps-force-restart.sh"

echo ""
echo "Bot pe: /stopmonitor  phir  /startmonitor"
echo "Phir naya OTP — bot card + /mynum phone inject dono aane chahiye."
