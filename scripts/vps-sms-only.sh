#!/usr/bin/env bash
# Panel Search band — sirf SMS Monitor (run.py) chalao.
set -euo pipefail

SMS_DIR="${SMS_DIR:-/opt/sms-monitor}"
PANEL_DIR="${PANEL_DIR:-/opt/panel-search-bot}"

echo "==> Panel Search band"
if systemctl list-unit-files panel-search-bot.service &>/dev/null 2>&1; then
  systemctl stop panel-search-bot 2>/dev/null || true
  systemctl disable panel-search-bot 2>/dev/null || true
  echo "  systemd panel-search-bot: stopped + disabled"
fi
if [ -d "$PANEL_DIR" ] && [ -f "$PANEL_DIR/stop_panel_search.sh" ]; then
  (cd "$PANEL_DIR" && bash stop_panel_search.sh) 2>/dev/null || true
fi
pkill -f "${PANEL_DIR}.*panel_search_bot" 2>/dev/null || true
pkill -f "panel_search_bot.run_bot" 2>/dev/null || true
sleep 1
pgrep -af panel_search_bot && echo "⚠️  panel ab bhi chal raha — manually kill karo" || echo "  panel: off"

echo ""
echo "==> SMS Monitor (run.py)"
cd "$SMS_DIR"
if [ -f scripts/vps-force-restart.sh ]; then
  bash scripts/vps-force-restart.sh
else
  bash stop.sh 2>/dev/null || true
  pkill -f "${SMS_DIR}/run.py" 2>/dev/null || true
  bash start.sh
fi

echo ""
pgrep -af "${SMS_DIR}.*run.py" || pgrep -af 'run.py' | head -3
echo "✅ Sirf SMS monitor chalna chahiye."
