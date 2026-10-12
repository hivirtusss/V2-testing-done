#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

if systemctl is-active panel-search-bot >/dev/null 2>&1; then
  echo "Already running via systemd (panel-search-bot)"
  exit 0
fi

if [ -f .env.panel_search ]; then
  set -a
  # shellcheck disable=SC1091
  source .env.panel_search
  set +a
elif [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

if [ -z "${PANEL_SEARCH_BOT_TOKEN:-}" ]; then
  echo "❌ PANEL_SEARCH_BOT_TOKEN missing. Run install_panel_search.sh or set .env.panel_search"
  exit 1
fi

PID_FILE="$ROOT_DIR/.panel-search.pid"
LOG_FILE="$ROOT_DIR/panel_search.log"

if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
  echo "Already running PID $(cat "$PID_FILE")"
  exit 0
fi

REQ="$ROOT_DIR/requirements-panel-search.txt"
[ -f "$REQ" ] || REQ="$ROOT_DIR/requirements.txt"
pip3 install -r "$REQ" -q 2>/dev/null || python3 -m pip install -r "$REQ" -q

RUN_PY="python3"
if [ -x "$ROOT_DIR/.venv/bin/python3" ] && "$ROOT_DIR/.venv/bin/python3" -c "import telegram" 2>/dev/null; then
  RUN_PY="$ROOT_DIR/.venv/bin/python3"
fi

if [ -n "${PANEL_SEARCH_BOT_TOKEN:-}" ]; then
  curl -fsS "https://api.telegram.org/bot${PANEL_SEARCH_BOT_TOKEN}/deleteWebhook?drop_pending_updates=true" >/dev/null 2>&1 || true
  curl -fsS -X POST "https://api.telegram.org/bot${PANEL_SEARCH_BOT_TOKEN}/close" >/dev/null 2>&1 || true
  sleep 1
fi

nohup "$RUN_PY" -m panel_search_bot.run_bot >> "$LOG_FILE" 2>&1 &
echo $! > "$PID_FILE"
echo "✅ Panel Search bot started PID $(cat "$PID_FILE")"
echo "📋 Logs: $LOG_FILE"
