#!/usr/bin/env bash
# Hostinger / Ubuntu VPS — Panel Search 24x7 (systemd). Root se chalao.
set -euo pipefail
INSTALL_DIR="${PANEL_INSTALL_DIR:-/opt/panel-search-bot}"
REPO="${PANEL_REPO:-https://github.com/hivirtusss/V2-testing-done.git}"
BRANCH="${PANEL_SEARCH_BRANCH:-cursor/panel-search-bot-8042}"

if [ "$(id -u)" -ne 0 ]; then
  echo "❌ Root se chalao: sudo bash vps_panel_search_setup.sh"
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -y -qq git python3 python3-venv rsync curl

TOKEN="${PANEL_SEARCH_BOT_TOKEN:-}"
OWNER="${PANEL_SEARCH_OWNER_IDS:-8674644868}"
AUTH="${PANEL_SEARCH_AUTH_KEY:-astik}"

if [ -z "$TOKEN" ] && [ -f /root/.env.panel_search ]; then
  set -a
  # shellcheck disable=SC1091
  source /root/.env.panel_search
  set +a
  TOKEN="${PANEL_SEARCH_BOT_TOKEN:-}"
  OWNER="${PANEL_SEARCH_OWNER_IDS:-$OWNER}"
fi

if [ -z "$TOKEN" ]; then
  echo "❌ Set token: PANEL_SEARCH_BOT_TOKEN=xxx PANEL_SEARCH_OWNER_IDS=8674644868 bash vps_panel_search_setup.sh"
  exit 1
fi

rm -rf /tmp/panel-search-src
git clone -b "$BRANCH" --depth 1 "$REPO" /tmp/panel-search-src
mkdir -p "$INSTALL_DIR"
rsync -a --exclude '.git' /tmp/panel-search-src/ "$INSTALL_DIR/"
cd "$INSTALL_DIR"

python3 -m venv .venv
.venv/bin/pip install -q -r requirements-panel-search.txt

cat > "$INSTALL_DIR/.env" <<EOF
PANEL_SEARCH_BOT_TOKEN=${TOKEN}
PANEL_SEARCH_OWNER_IDS=${OWNER}
PANEL_SEARCH_AUTH_KEY=${AUTH}
PANEL_SEARCH_DATABASE_URL=sqlite:///${INSTALL_DIR}/panel_search.db
PANEL_SEARCH_NOTIFY_CHAT_ID=${OWNER}
PANEL_SEARCH_CONCURRENCY=256
PANEL_SEARCH_MAX_WORKERS=256
PANEL_SEARCH_FETCH_TIMEOUT=2.2
PANEL_SEARCH_SKIP_LIVE_IF_CACHED=true
PANEL_SEARCH_BOTH_SKIP_UNCACHED_LIVE=true
PANEL_SEARCH_VARIANT_LIMIT=2
PANEL_SEARCH_PARALLEL_SUBPATHS=6
EOF
chmod 600 "$INSTALL_DIR/.env"

if [ ! -f "$INSTALL_DIR/panel_search.db" ]; then
  echo "⚠️  panel_search.db abhi nahi — Mac se: scp panel_search.db root@$(curl -s ifconfig.me 2>/dev/null || echo VPS_IP):${INSTALL_DIR}/"
  .venv/bin/python3 -c "from panel_search_bot.database import init_db; init_db()"
fi

cat > /etc/systemd/system/panel-search-bot.service <<EOF
[Unit]
Description=Panel Search Telegram Bot
After=network-online.target

[Service]
Type=simple
WorkingDirectory=${INSTALL_DIR}
EnvironmentFile=${INSTALL_DIR}/.env
ExecStart=${INSTALL_DIR}/.venv/bin/python3 -m panel_search_bot.run_bot
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable panel-search-bot
systemctl restart panel-search-bot
sleep 2
systemctl --no-pager status panel-search-bot || true
echo ""
echo "✅ Panel Search VPS pe chal raha hai."
echo "   Logs: journalctl -u panel-search-bot -f"
