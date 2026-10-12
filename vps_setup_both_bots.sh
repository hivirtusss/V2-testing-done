#!/usr/bin/env bash
# Fresh Hostinger/Ubuntu VPS — SMS Monitor + Panel Search (2 alag token, 2 alag folder).
# Root se chalao:
#   TELEGRAM_BOT_TOKEN=... TELEGRAM_ALLOWED_USERS=... \
#   PANEL_SEARCH_BOT_TOKEN=... PANEL_SEARCH_OWNER_IDS=... \
#   bash vps_setup_both_bots.sh
set -euo pipefail

REPO="${VPS_REPO:-https://github.com/hivirtusss/V2-testing-done.git}"
SMS_BRANCH="${SMS_BRANCH:-cursor/remote-sms-monitor-bot-8042}"
PANEL_BRANCH="${PANEL_BRANCH:-cursor/panel-search-bot-8042}"
SMS_DIR="${SMS_DIR:-/opt/sms-monitor}"
PANEL_DIR="${PANEL_DIR:-/opt/panel-search-bot}"
SECRETS="/root/.vps-bots.env"

if [ "$(id -u)" -ne 0 ]; then
  echo "❌ Root se chalao: sudo bash vps_setup_both_bots.sh"
  exit 1
fi

if [ -f "$SECRETS" ]; then
  set -a
  # shellcheck disable=SC1090
  source "$SECRETS"
  set +a
fi

SMS_TOKEN="${TELEGRAM_BOT_TOKEN:-}"
SMS_USERS="${TELEGRAM_ALLOWED_USERS:-}"
PANEL_TOKEN="${PANEL_SEARCH_BOT_TOKEN:-}"
PANEL_OWNER="${PANEL_SEARCH_OWNER_IDS:-}"
API_SECRET="${API_SECRET_KEY:-}"
PANEL_AUTH="${PANEL_SEARCH_AUTH_KEY:-astik}"

if [ -z "$SMS_TOKEN" ] || [ -z "$PANEL_TOKEN" ]; then
  cat <<'EOF'
❌ Dono alag bot tokens chahiye (mix mat karo):

  export TELEGRAM_BOT_TOKEN='SMS_MONITOR_BOT_TOKEN'
  export TELEGRAM_ALLOWED_USERS='8674644868,7922581508'
  export PANEL_SEARCH_BOT_TOKEN='PANEL_SEARCH_BOT_TOKEN'
  export PANEL_SEARCH_OWNER_IDS='8674644868'
  curl -fsSL "https://raw.githubusercontent.com/hivirtusss/V2-testing-done/cursor/panel-search-bot-8042/vps_setup_both_bots.sh" | bash

Optional: values /root/.vps-bots.env me save karo (chmod 600).
EOF
  exit 1
fi

if [ -z "$SMS_USERS" ]; then
  SMS_USERS="$PANEL_OWNER"
fi
if [ -z "$PANEL_OWNER" ]; then
  PANEL_OWNER="${SMS_USERS%%,*}"
fi
if [ -z "$API_SECRET" ]; then
  API_SECRET="$(openssl rand -hex 24 2>/dev/null || head -c 24 /dev/urandom | xxd -p)"
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq git python3 python3-pip python3-venv rsync curl openssl

# --- SMS Monitor ---
echo ""
echo "========== SMS Monitor → $SMS_DIR =========="
rm -rf /tmp/sms-monitor-src
git clone -b "$SMS_BRANCH" --depth 1 "$REPO" /tmp/sms-monitor-src
mkdir -p "$SMS_DIR"
rsync -a --exclude '.git' --exclude '__pycache__' --exclude '*.db' /tmp/sms-monitor-src/ "$SMS_DIR/"
cd "$SMS_DIR"

cat > "$SMS_DIR/.env" <<EOF
TELEGRAM_BOT_TOKEN=${SMS_TOKEN}
TELEGRAM_ALLOWED_USERS=${SMS_USERS}
API_SECRET_KEY=${API_SECRET}
DATABASE_URL=sqlite:///${SMS_DIR}/sms_monitor.db
PORT=8000
VIRTUS_MODULE_DB=https://virtus-module-default-rtdb.firebaseio.com
EOF
chmod 600 "$SMS_DIR/.env"

python3 -m pip install -q -r requirements.txt

cat > /etc/systemd/system/sms-monitor.service <<EOF
[Unit]
Description=Virtus SMS Monitor (Telegram + API)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=${SMS_DIR}
EnvironmentFile=${SMS_DIR}/.env
ExecStart=/usr/bin/python3 ${SMS_DIR}/run.py
Restart=always
RestartSec=5
StandardOutput=append:${SMS_DIR}/sms-monitor.log
StandardError=append:${SMS_DIR}/sms-monitor.log

[Install]
WantedBy=multi-user.target
EOF

# --- Panel Search ---
echo ""
echo "========== Panel Search → $PANEL_DIR =========="
rm -rf /tmp/panel-search-src
git clone -b "$PANEL_BRANCH" --depth 1 "$REPO" /tmp/panel-search-src
mkdir -p "$PANEL_DIR"
rsync -a --exclude '.git' --exclude '__pycache__' /tmp/panel-search-src/ "$PANEL_DIR/"
cd "$PANEL_DIR"

python3 -m venv .venv
.venv/bin/pip install -q -r requirements-panel-search.txt

# 1 vCPU VPS — zyada workers mat lagao
cat > "$PANEL_DIR/.env" <<EOF
PANEL_SEARCH_BOT_TOKEN=${PANEL_TOKEN}
PANEL_SEARCH_OWNER_IDS=${PANEL_OWNER}
PANEL_SEARCH_AUTH_KEY=${PANEL_AUTH}
PANEL_SEARCH_DATABASE_URL=sqlite:///${PANEL_DIR}/panel_search.db
PANEL_SEARCH_NOTIFY_CHAT_ID=${PANEL_OWNER}
PANEL_SEARCH_CONCURRENCY=32
PANEL_SEARCH_MAX_WORKERS=48
PANEL_SEARCH_FETCH_TIMEOUT=2.5
PANEL_SEARCH_SKIP_LIVE_IF_CACHED=true
PANEL_SEARCH_BOTH_SKIP_UNCACHED_LIVE=true
PANEL_SEARCH_VARIANT_LIMIT=2
PANEL_SEARCH_PARALLEL_SUBPATHS=4
EOF
chmod 600 "$PANEL_DIR/.env"

.venv/bin/python3 -c "from panel_search_bot.database import init_db; init_db()" 2>/dev/null || true

cat > /etc/systemd/system/panel-search-bot.service <<EOF
[Unit]
Description=Panel Search Telegram Bot
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=${PANEL_DIR}
EnvironmentFile=${PANEL_DIR}/.env
ExecStart=${PANEL_DIR}/.venv/bin/python3 -m panel_search_bot.run_bot
Restart=always
RestartSec=5
StandardOutput=append:${PANEL_DIR}/panel_search.log
StandardError=append:${PANEL_DIR}/panel_search.log

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable sms-monitor panel-search-bot
systemctl restart sms-monitor panel-search-bot
sleep 3

echo ""
echo "========== Status =========="
systemctl --no-pager is-active sms-monitor panel-search-bot || true
echo ""
echo "--- SMS log (tail) ---"
tail -8 "$SMS_DIR/sms-monitor.log" 2>/dev/null || journalctl -u sms-monitor -n 8 --no-pager || true
echo ""
echo "--- Panel log (tail) ---"
tail -8 "$PANEL_DIR/panel_search.log" 2>/dev/null || journalctl -u panel-search-bot -n 8 --no-pager || true
echo ""
echo "✅ Dono bot systemd pe chal rahe hain."
echo "   SMS:   systemctl status sms-monitor   | log: tail -f $SMS_DIR/sms-monitor.log"
echo "   Panel: systemctl status panel-search-bot | log: tail -f $PANEL_DIR/panel_search.log"
echo "   API (SMS webhook): http://$(curl -4 -s ifconfig.me 2>/dev/null || echo 'VPS_IP'):8000"
echo ""
echo "Panel DB cache ke liye (optional): scp panel_search.db root@VPS:$PANEL_DIR/"
