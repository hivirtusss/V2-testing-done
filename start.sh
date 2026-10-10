#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

if [ ! -f .env ]; then
    echo "❌ .env missing. Run ./install.sh first."
    exit 1
fi

PID_FILE="$ROOT_DIR/.sms-monitor.pid"
LOG_FILE="$ROOT_DIR/sms-monitor.log"

if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    echo "⚠️  Already running (PID $(cat "$PID_FILE"))"
    exit 0
fi

nohup python3 run.py >> "$LOG_FILE" 2>&1 &
echo $! > "$PID_FILE"
echo "✅ SMS Monitor started (PID $(cat "$PID_FILE"))"
echo "📋 Logs: $LOG_FILE"
echo "🌐 Dashboard: http://localhost:8000"
