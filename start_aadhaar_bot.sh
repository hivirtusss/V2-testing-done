#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

if [ -f .env.aadhaar ]; then
  set -a
  # shellcheck disable=SC1091
  source .env.aadhaar
  set +a
elif [ -f .env ]; then
  set -a
  # shellcheck disable=SC1091
  source .env
  set +a
fi

if [ -z "${AADHAAR_BOT_TOKEN:-}" ]; then
  echo "❌ AADHAAR_BOT_TOKEN missing. Copy .env.aadhaar.example → .env.aadhaar"
  exit 1
fi

PID_FILE="$ROOT_DIR/.aadhaar-bot.pid"
LOG_FILE="$ROOT_DIR/aadhaar_bot.log"

if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
  echo "Already running PID $(cat "$PID_FILE")"
  exit 0
fi

if [ "${AADHAAR_PROVIDER:-uidai}" = "uidai" ]; then
  bash "$ROOT_DIR/start_uidai_bridge.sh"
fi

python3 -m pip install -r requirements.txt -q
nohup python3 -m aadhaar_bot.run_bot >> "$LOG_FILE" 2>&1 &
echo $! > "$PID_FILE"
echo "✅ Aadhaar bot started PID $(cat "$PID_FILE")"
echo "📋 Logs: $LOG_FILE"
