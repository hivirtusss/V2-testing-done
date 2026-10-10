#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$ROOT_DIR/.panel-search.pid"

if systemctl is-active panel-search-bot >/dev/null 2>&1; then
  sudo systemctl stop panel-search-bot
  echo "✅ systemd panel-search-bot stopped"
  exit 0
fi

if [ ! -f "$PID_FILE" ]; then
  echo "Not running."
  exit 0
fi
PID="$(cat "$PID_FILE")"
kill "$PID" 2>/dev/null && echo "✅ Stopped PID $PID" || echo "Process not found."
rm -f "$PID_FILE"
