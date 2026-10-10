#!/usr/bin/env bash
# SMS Monitor — SIM 1/2 display fix (no git). Run on VPS: bash vps_sms_monitor_sim_update.sh
set -euo pipefail

INSTALL_DIR="${1:-/opt/sms-monitor}"
BRANCH="cursor/remote-sms-monitor-bot-8042"
BASE="https://raw.githubusercontent.com/hivirtusss/V2-testing-done/${BRANCH}"

FILES=(
  app/device_ui.py
  app/firebase_client.py
  app/firebase_sync.py
  app/main.py
  app/models.py
  app/services.py
)

if [ ! -d "$INSTALL_DIR" ]; then
  echo "❌ Folder nahi mila: $INSTALL_DIR"
  echo "   Usage: bash $0 /path/to/sms-monitor"
  exit 1
fi

cd "$INSTALL_DIR"
echo "📂 $INSTALL_DIR"

echo "🔍 Pehle (purana code check)..."
if grep -q "build_sim_list_from_record" app/firebase_client.py 2>/dev/null; then
  echo "   SIM fix pehle se lag raha hai (build_sim_list_from_record mila)."
else
  echo "   SIM fix NAHI hai — ab download karenge."
fi

mkdir -p app
for f in "${FILES[@]}"; do
  echo "⬇️  $f"
  curl -fsSL "${BASE}/${f}" -o "${f}.new"
  mv "${f}.new" "$f"
done

echo "🔍 Baad me (verify)..."
if grep -q "build_sim_list_from_record" app/firebase_client.py && grep -q "format_sim_number" app/device_ui.py; then
  echo "✅ SIM update files OK"
else
  echo "❌ Download fail — GitHub/branch check karo"
  exit 1
fi

if [ -f stop.sh ]; then
  bash stop.sh || true
fi
if [ -f start.sh ]; then
  bash start.sh
else
  echo "⚠️  start.sh nahi — manually: nohup python3 run.py &"
fi

echo "📋 Log: tail -20 $INSTALL_DIR/sms-monitor.log"
echo "📱 Telegram: /a <device_id> se SIM 1/2 check karo"
