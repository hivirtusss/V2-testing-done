#!/usr/bin/env bash
# SMS Monitor ONLY — pehle jesa: alag .env, sirf run.py, Panel Search touch nahi.
set -euo pipefail

SMS_DIR="${SMS_DIR:-/opt/sms-monitor}"
BR="cursor/remote-sms-monitor-bot-8042"
RAW="https://raw.githubusercontent.com/hivirtusss/V2-testing-done/${BR}"

if [ ! -d "$SMS_DIR" ]; then
  echo "❌ $SMS_DIR nahi mila"
  exit 1
fi

cd "$SMS_DIR"
echo "📂 SMS Monitor restore: $SMS_DIR"

# --- band karo (pid file + purane duplicate run.py) ---
bash stop.sh 2>/dev/null || true
while read -r pid; do
  [ -n "$pid" ] && kill "$pid" 2>/dev/null || true
done < <(pgrep -f "${SMS_DIR}/run.py" 2>/dev/null || true)
while read -r pid; do
  [ -n "$pid" ] && kill "$pid" 2>/dev/null || true
done < <(pgrep -f "python3 ${SMS_DIR}/run.py" 2>/dev/null || true)
sleep 2

# --- .env: Panel Search / extra hatao, SMS keys rakho ---
if [ -f .env ]; then
  cp .env ".env.backup.$(date +%Y%m%d%H%M%S)"
  grep -vE '^(PANEL_SEARCH_|#.*Panel Search)' .env | grep -E '^(TELEGRAM_|API_SECRET|DATABASE_URL|PORT|VIRTUS_)' > .env.new || true
  if [ -s .env.new ]; then
    mv .env.new .env
    echo "✅ .env saaf (sirf SMS monitor keys)"
  else
    echo "⚠️  .env.new khali — .env.backup se TELEGRAM_BOT_TOKEN manually set karo"
    rm -f .env.new
  fi
else
  echo "❌ .env missing — .env.backup se restore karo"
  exit 1
fi

mkdir -p app

# --- config + SIM display (same branch, Panel mix nahi) ---
for f in app/config.py app/device_ui.py app/firebase_client.py app/firebase_sync.py app/main.py app/models.py app/services.py; do
  curl -fsSL "$RAW/$f" -o "$f"
done

# --- start (sirf start.sh → run.py) ---
bash start.sh
sleep 3

echo ""
echo "=== Status ==="
pgrep -af "${SMS_DIR}.*run.py" || pgrep -af "run.py" | head -5 || true
echo ""
if [ -f sms-monitor.log ]; then
  tail -15 sms-monitor.log
else
  echo "(no sms-monitor.log yet)"
fi
echo ""
echo "✅ SMS Monitor restore done."
echo "   Access: .env → TELEGRAM_ALLOWED_USERS=your_telegram_id (comma list)"
echo "   Panel Search alag bot: cd /opt/panel-search-bot && bash start_panel_search.sh"
echo "   /approve sirf Panel Search me hai — SMS me nahi."
