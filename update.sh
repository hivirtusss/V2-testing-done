#!/usr/bin/env bash
# VPS one-command update — use from the git clone folder (NOT bare /opt copy unless it has .git)
set -euo pipefail

BRANCH="${1:-cursor/channel-auto-forward-8042}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if [ ! -d .git ]; then
    echo "❌ .git missing here: $ROOT_DIR"
    echo "   Clone repo first, OR run from your git folder (not /opt/sms-monitor copy from install.sh)."
    exit 1
fi

echo "📥 Pull $BRANCH ..."
git fetch origin
git checkout "$BRANCH"
git pull origin "$BRANCH"

echo "📦 Dependencies ..."
python3 -m pip install -r requirements.txt -q

# If installed via sudo ./install.sh, sync code into /opt/sms-monitor (no .git there)
if [ -d /opt/sms-monitor ] && [ "$(id -u)" -eq 0 ]; then
    echo "📂 Sync → /opt/sms-monitor ..."
    rsync -a --exclude '.git' --exclude '__pycache__' --exclude '*.db' --exclude '.env' \
        "$ROOT_DIR/" /opt/sms-monitor/
fi

if systemctl is-active --quiet sms-monitor 2>/dev/null || systemctl list-unit-files sms-monitor.service &>/dev/null; then
    echo "🔄 Restart sms-monitor (systemd) ..."
    systemctl daemon-reload
    systemctl restart sms-monitor
    sleep 2
    systemctl status sms-monitor --no-pager || true
    echo ""
    echo "📋 Logs: journalctl -u sms-monitor -n 30 --no-pager"
elif [ -f "$ROOT_DIR/start.sh" ]; then
    echo "🔄 Restart via start.sh ..."
    "$ROOT_DIR/stop.sh" 2>/dev/null || true
    "$ROOT_DIR/start.sh"
    echo "📋 Logs: tail -f $ROOT_DIR/sms-monitor.log"
else
    echo "⚠️  No systemd/start.sh — run manually: python3 run.py"
fi

echo "✅ Update done. Telegram pe /ping bhejo."
