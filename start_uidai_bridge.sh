#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

if [ -f .env.aadhaar ]; then
  set -a
  # shellcheck disable=SC1091
  source .env.aadhaar
  set +a
fi

PID_FILE="$ROOT_DIR/.uidai-bridge.pid"
LOG_FILE="$ROOT_DIR/uidai_bridge.log"

if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
  echo "UIDAI bridge already running PID $(cat "$PID_FILE")"
  exit 0
fi

python3 -m pip install -r requirements.txt -q
nohup python3 -m aadhaar_bot.run_bridge >> "$LOG_FILE" 2>&1 &
echo $! > "$PID_FILE"
echo "✅ UIDAI bridge started PID $(cat "$PID_FILE") — logs: $LOG_FILE"
