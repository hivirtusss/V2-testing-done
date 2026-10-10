#!/usr/bin/env bash
# Dono alag bot — ek VPS pe. Mix nahi: alag folder, alag .env, alag process.
set -euo pipefail

SMS_DIR="${SMS_DIR:-/opt/sms-monitor}"
PANEL_DIR="${PANEL_DIR:-/opt/panel-search-bot}"

echo "=== SMS Monitor ($SMS_DIR) ==="
if [ ! -d "$SMS_DIR" ]; then
  echo "❌ SMS folder nahi: $SMS_DIR"
  exit 1
fi
cd "$SMS_DIR"
[ -f stop.sh ] && bash stop.sh 2>/dev/null || true
pkill -f "${SMS_DIR}/run.py" 2>/dev/null || pkill -f "${SMS_DIR}.*run.py" 2>/dev/null || true
sleep 1
bash start.sh
echo "SMS PID: $(cat .sms-monitor.pid 2>/dev/null || echo '?')"

echo ""
echo "=== Panel Search ($PANEL_DIR) ==="
if [ ! -d "$PANEL_DIR" ]; then
  echo "❌ Panel folder nahi: $PANEL_DIR"
  exit 1
fi
cd "$PANEL_DIR"
if [ -f stop_panel_search.sh ]; then
  bash stop_panel_search.sh 2>/dev/null || true
elif [ -f .panel-search.pid ] && kill -0 "$(cat .panel-search.pid)" 2>/dev/null; then
  kill "$(cat .panel-search.pid)" 2>/dev/null || true
fi
pkill -f "${PANEL_DIR}.*panel_search_bot.run_bot" 2>/dev/null || true
sleep 1
bash start_panel_search.sh
echo "Panel PID: $(cat .panel-search.pid 2>/dev/null || echo '?')"

echo ""
echo "=== Running ==="
pgrep -af "run.py" | grep -v grep || true
pgrep -af "panel_search_bot.run_bot" | grep -v grep || true
echo "✅ Done (2 alag bot, 2 alag token)"
