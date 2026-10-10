#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$ROOT_DIR/.sms-monitor.pid"

if [ ! -f "$PID_FILE" ]; then
    echo "Not running."
    exit 0
fi

PID="$(cat "$PID_FILE")"
if kill -0 "$PID" 2>/dev/null; then
    kill "$PID"
    echo "✅ Stopped (PID $PID)"
else
    echo "Process not found."
fi

rm -f "$PID_FILE"

# Duplicate run.py (purana PID / 409 Conflict) — sirf is install folder
while read -r orphan; do
    [ -n "$orphan" ] && [ "$orphan" != "$PID" ] && kill "$orphan" 2>/dev/null && echo "✅ Stopped orphan (PID $orphan)"
done < <(pgrep -f "${ROOT_DIR}/run.py" 2>/dev/null || true)
