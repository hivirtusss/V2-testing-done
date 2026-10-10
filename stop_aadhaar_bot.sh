#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
PID_FILE="$ROOT_DIR/.aadhaar-bot.pid"

if [ -f "$PID_FILE" ]; then
  pid="$(cat "$PID_FILE")"
  if kill -0 "$pid" 2>/dev/null; then
    kill "$pid" || true
    echo "✅ Aadhaar bot stopped PID $pid"
  fi
  rm -f "$PID_FILE"
else
  echo "No .aadhaar-bot.pid — bot not running from start script"
fi
