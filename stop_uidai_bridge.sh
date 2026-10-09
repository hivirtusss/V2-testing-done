#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$ROOT_DIR/.uidai-bridge.pid"

if [ ! -f "$PID_FILE" ]; then
  echo "UIDAI bridge not running (no .uidai-bridge.pid)."
  exit 0
fi

PID="$(cat "$PID_FILE")"
if kill -0 "$PID" 2>/dev/null; then
  kill "$PID" || true
  echo "✅ UIDAI bridge stopped PID $PID"
else
  echo "UIDAI bridge process not found."
fi
rm -f "$PID_FILE"
