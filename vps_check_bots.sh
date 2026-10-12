#!/usr/bin/env bash
# Kaunsa bot / kaunsi files VPS pe hain — restore confirm karne ke liye.
set -euo pipefail

echo "========== Host / time =========="
hostname -f 2>/dev/null || hostname
date -u 2>/dev/null || date
echo ""

echo "========== Processes (Telegram bots) =========="
pgrep -af 'run\.py|panel_search_bot' 2>/dev/null || echo "(koi match nahi)"
echo ""

echo "========== systemd =========="
for u in sms-monitor panel-search-bot; do
  if systemctl list-unit-files "$u.service" &>/dev/null; then
    systemctl is-active "$u" 2>/dev/null && echo "$u: active" || echo "$u: inactive/failed"
  else
    echo "$u.service: not installed"
  fi
done
echo ""

check_dir() {
  local label="$1"
  local dir="$2"
  echo "========== $label ($dir) =========="
  if [ ! -d "$dir" ]; then
    echo "❌ folder nahi hai"
    echo ""
    return
  fi
  echo "✅ folder hai"
  if [ -f "$dir/.env" ]; then
    echo ".env keys (values hidden):"
    sed 's/=.*/=***/' "$dir/.env" | grep -v '^#' | grep -v '^$' | head -30
  else
    echo "⚠️  .env missing"
  fi
  if [ -f "$dir/stop.sh" ]; then echo "start/stop: stop.sh + start.sh (manual/nohup style)"; fi
  if [ -f "$dir/.sms-monitor.pid" ]; then echo "PID file: .sms-monitor.pid = $(cat "$dir/.sms-monitor.pid" 2>/dev/null)"; fi
  if [ -f "$dir/.panel-search.pid" ]; then echo "PID file: .panel-search.pid = $(cat "$dir/.panel-search.pid" 2>/dev/null)"; fi

  if [ -f "$dir/app/config.py" ]; then
    if grep -q 'extra="ignore"' "$dir/app/config.py" 2>/dev/null; then
      echo "SMS config: extra=ignore ✅ (mixed .env safe)"
    else
      echo "SMS config: extra=ignore ❌ (purana — panel vars se crash ho sakta)"
    fi
  fi
  if [ -f "$dir/app/firebase_client.py" ]; then
    if grep -q 'build_sim_list_from_record' "$dir/app/firebase_client.py" 2>/dev/null; then
      echo "SMS code: SIM build_sim_list_from_record ✅"
    else
      echo "SMS code: SIM fix ❌ (purana device_ui path)"
    fi
  fi
  if [ -f "$dir/panel_search_bot/search_engine.py" ]; then
    if grep -q 'MatchProgress' "$dir/panel_search_bot/search_engine.py" 2>/dev/null; then
      echo "Panel: search_engine MatchProgress ✅ (newer panel branch)"
    else
      echo "Panel: purana search_engine"
    fi
    if grep -q 'panel_search_online_skip_cached_live' "$dir/panel_search_bot/firebase_fetch.py" 2>/dev/null; then
      echo "Panel: fast firebase_fetch flags ✅"
    fi
  fi
  if [ -d "$dir/.git" ]; then
    echo "git branch: $(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null) @ $(git -C "$dir" rev-parse --short HEAD 2>/dev/null)"
  else
    echo "git: nahi (curl/manual copy install)"
  fi
  for log in sms-monitor.log panel_search.log; do
    if [ -f "$dir/$log" ]; then
      echo "--- tail $log ---"
      tail -6 "$dir/$log" 2>/dev/null || true
    fi
  done
  echo ""
}

check_dir "SMS Monitor" "${SMS_DIR:-/opt/sms-monitor}"
check_dir "Panel Search" "${PANEL_DIR:-/opt/panel-search-bot}"

echo "========== Quick Telegram test =========="
echo "SMS bot: /help → /setfirebase, /startmonitor (NO /approve)"
echo "Panel bot: /help → /search, /approve (owner)"
