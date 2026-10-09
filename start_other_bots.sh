#!/usr/bin/env bash
# Start Panel Search + SMS Monitor — Aadhaar / UIDAI bridge skip.
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

echo "⏭  Stopping Aadhaar + UIDAI bridge…"
bash "$ROOT_DIR/stop_aadhaar_bot.sh" 2>/dev/null || true
bash "$ROOT_DIR/stop_uidai_bridge.sh" 2>/dev/null || true

# Kill stray panel-search duplicates (old PIDs)
for pid in $(pgrep -f 'panel_search_bot.run_bot' 2>/dev/null || true); do
  kill "$pid" 2>/dev/null || true
done
rm -f "$ROOT_DIR/_run/panel-search/.panel-search.pid" 2>/dev/null || true
sleep 1

echo "▶ SMS Monitor (Virtus)…"
bash "$ROOT_DIR/ensure_sms_env.sh" || true
if [ -f "$ROOT_DIR/.env" ]; then
  bash "$ROOT_DIR/start.sh" || echo "   ⚠️  SMS monitor failed"
else
  echo "   ⚠️  SMS Monitor — no token (.env.aadhaar / TELEGRAM_BOT_TOKEN)"
fi

if [ -f "$ROOT_DIR/start_panel_search.sh" ]; then
  echo "▶ Panel Search bot…"
  bash "$ROOT_DIR/start_panel_search.sh"
else
  echo "⏭  Panel Search — script missing"
fi

echo ""
echo "✅ Status (Aadhaar off):"
[ -f .sms-monitor.pid ] && kill -0 "$(cat .sms-monitor.pid)" 2>/dev/null && echo "   • SMS Monitor: running" || echo "   • SMS Monitor: off"
PS_PID="$ROOT_DIR/_run/panel-search/.panel-search.pid"
[ -f "$PS_PID" ] && kill -0 "$(cat "$PS_PID")" 2>/dev/null && echo "   • Panel Search: running" || echo "   • Panel Search: off"
[ -f .aadhaar-bot.pid ] && kill -0 "$(cat .aadhaar-bot.pid)" 2>/dev/null && echo "   • Aadhaar: still running (!)" || echo "   • Aadhaar: off"
[ -f .uidai-bridge.pid ] && kill -0 "$(cat .uidai-bridge.pid)" 2>/dev/null && echo "   • UIDAI bridge: still running (!)" || echo "   • UIDAI bridge: off"
