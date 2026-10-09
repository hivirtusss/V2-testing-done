#!/usr/bin/env bash
# Start every side service — alag Telegram token = sab ek saath chal sakte hain.
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

echo "══════════════════════════════════════"
echo "  Starting all bots (independent tokens)"
echo "══════════════════════════════════════"

if [ -f "$ROOT_DIR/.env" ]; then
  echo "▶ SMS Monitor (Virtus)…"
  bash "$ROOT_DIR/start.sh" || echo "   ⚠️  SMS monitor skip/fail"
else
  echo "⏭  SMS Monitor — no .env (skip)"
fi

echo "▶ Aadhaar bot + UIDAI bridge…"
bash "$ROOT_DIR/start_aadhaar_bot.sh"

if [ -f "$ROOT_DIR/_run/panel-search/start_panel_search.sh" ]; then
  echo "▶ Panel Search bot…"
  bash "$ROOT_DIR/start_panel_search.sh" || echo "   ⚠️  Panel Search skip/fail"
else
  echo "⏭  Panel Search — worktree missing (skip)"
fi

echo ""
echo "✅ Done. Status:"
[ -f .sms-monitor.pid ] && kill -0 "$(cat .sms-monitor.pid)" 2>/dev/null && echo "   • SMS Monitor: running" || echo "   • SMS Monitor: off"
[ -f .uidai-bridge.pid ] && kill -0 "$(cat .uidai-bridge.pid)" 2>/dev/null && echo "   • UIDAI bridge: running" || echo "   • UIDAI bridge: off"
[ -f .aadhaar-bot.pid ] && kill -0 "$(cat .aadhaar-bot.pid)" 2>/dev/null && echo "   • Aadhaar bot: running" || echo "   • Aadhaar bot: off"
PS_PID="$ROOT_DIR/_run/panel-search/.panel-search.pid"
if [ -f "$PS_PID" ] && kill -0 "$(cat "$PS_PID")" 2>/dev/null; then
  echo "   • Panel Search: running"
else
  echo "   • Panel Search: off"
fi
echo ""
echo "Stop sab: ./stop_all_bots.sh"
