#!/usr/bin/env bash
# Stops optional Telegram side bots only — does NOT modify Virtus / panel code.
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

if [ -x "$ROOT_DIR/stop_panel_search.sh" ]; then
  bash "$ROOT_DIR/stop_panel_search.sh" || true
fi
if [ -x "$ROOT_DIR/stop_aadhaar_bot.sh" ]; then
  bash "$ROOT_DIR/stop_aadhaar_bot.sh" || true
fi
if [ -x "$ROOT_DIR/stop_uidai_bridge.sh" ]; then
  bash "$ROOT_DIR/stop_uidai_bridge.sh" || true
fi

echo "Done. Virtus SMS module / GL APK code untouched."
echo "Tip: ./start_all_bots.sh — sab alag tokens par ek saath."
