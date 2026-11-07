#!/usr/bin/env bash
# VPS pe chalao: apni Telegram ID wapas lagao + dono bots restart (agar installed hon).
# Usage:
#   curl -fsSL 'https://raw.githubusercontent.com/hivirtusss/V2-testing-done/cursor/firebase-sms-panel-apk-8042/scripts/vps_id_restart.sh' | bash -s -- 7123456789
#   ya: TELEGRAM_ID=7123456789 bash vps_id_restart.sh
set -euo pipefail

TELEGRAM_ID="${1:-${TELEGRAM_ID:-}}"
if [ -z "$TELEGRAM_ID" ] || ! [[ "$TELEGRAM_ID" =~ ^[0-9]+$ ]]; then
  echo "❌ Apna Telegram ID do (sirf digits):"
  echo "   bash vps_id_restart.sh 7123456789"
  exit 1
fi

upsert_env() {
  local file="$1"
  local key="$2"
  local val="$3"
  [ -f "$file" ] || return 0
  if grep -q "^${key}=" "$file" 2>/dev/null; then
    sed -i.bak "s|^${key}=.*|${key}=${val}|" "$file"
  else
    echo "${key}=${val}" >>"$file"
  fi
  echo "✅ $file → ${key}=***"
}

echo "🔁 Telegram ID set + restart (ID=$TELEGRAM_ID)"
echo ""

SMS_DIR="${SMS_DIR:-/opt/sms-monitor}"
PANEL_DIR="${PANEL_DIR:-/opt/panel-search-bot}"

if [ -d "$SMS_DIR" ]; then
  upsert_env "$SMS_DIR/.env" "TELEGRAM_ALLOWED_USERS" "$TELEGRAM_ID"
  if systemctl is-enabled sms-monitor &>/dev/null; then
    systemctl restart sms-monitor
    echo "✅ systemctl restart sms-monitor"
  elif [ -f "$SMS_DIR/stop.sh" ] && [ -f "$SMS_DIR/start.sh" ]; then
    (cd "$SMS_DIR" && bash stop.sh 2>/dev/null; bash start.sh)
    echo "✅ $SMS_DIR stop.sh + start.sh"
  fi
else
  echo "⚠️  $SMS_DIR nahi — SMS Monitor skip"
fi

if [ -d "$PANEL_DIR" ]; then
  upsert_env "$PANEL_DIR/.env" "PANEL_SEARCH_OWNER_IDS" "$TELEGRAM_ID"
  if systemctl is-enabled panel-search-bot &>/dev/null; then
    systemctl restart panel-search-bot
    echo "✅ systemctl restart panel-search-bot"
  elif [ -f "$PANEL_DIR/stop_panel_search.sh" ] && [ -f "$PANEL_DIR/start_panel_search.sh" ]; then
    (cd "$PANEL_DIR" && bash stop_panel_search.sh 2>/dev/null; bash start_panel_search.sh)
    echo "✅ Panel Search scripts restart"
  fi
else
  echo "⚠️  $PANEL_DIR nahi — Panel Search skip"
fi

echo ""
echo "✅ Ho gaya. Telegram pe /start try karo."
echo "   Panel pe DB se delete thi to owner /approve $TELEGRAM_ID bhi chala sakta hai."
