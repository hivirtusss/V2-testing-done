#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

echo "Stopping all bots…"

[ -x "$ROOT_DIR/stop.sh" ] && bash "$ROOT_DIR/stop.sh" || true
[ -x "$ROOT_DIR/stop_aadhaar_bot.sh" ] && bash "$ROOT_DIR/stop_aadhaar_bot.sh" || true
[ -x "$ROOT_DIR/stop_uidai_bridge.sh" ] && bash "$ROOT_DIR/stop_uidai_bridge.sh" || true
[ -x "$ROOT_DIR/stop_panel_search.sh" ] && bash "$ROOT_DIR/stop_panel_search.sh" || true

echo "✅ All stopped (Virtus APK code untouched)."
