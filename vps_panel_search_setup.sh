#!/usr/bin/env bash
# Apne India VPS pe root SSH ke baad — ek command (token .env se)
set -euo pipefail
INSTALL_DIR="${PANEL_INSTALL_DIR:-/opt/panel-search-bot}"
REPO="${PANEL_REPO:-https://github.com/hivirtusss/V2-testing-done.git}"
BRANCH="${PANEL_SEARCH_BRANCH:-cursor/panel-search-bot-8042}"

if [ ! -f .env.panel_search ] && [ ! -f /root/.env.panel_search ]; then
  echo "❌ Pehle .env.panel_search banao (TOKEN + OWNER_IDS), phir:"
  echo "   export \$(grep -v '^#' .env.panel_search | xargs) && sudo -E bash vps_panel_search_setup.sh"
  exit 1
fi

[ -f .env.panel_search ] && set -a && source .env.panel_search && set +a

if [ -z "${PANEL_SEARCH_BOT_TOKEN:-}" ] || [ -z "${PANEL_SEARCH_OWNER_IDS:-}" ]; then
  echo "❌ PANEL_SEARCH_BOT_TOKEN / PANEL_SEARCH_OWNER_IDS missing"
  exit 1
fi

apt-get update -qq
apt-get install -y -qq git python3 python3-venv rsync

rm -rf /tmp/panel-search-src
git clone -b "$BRANCH" --depth 1 "$REPO" /tmp/panel-search-src
mkdir -p "$INSTALL_DIR"
rsync -a --exclude '.git' /tmp/panel-search-src/ "$INSTALL_DIR/"
cd "$INSTALL_DIR"

python3 -m venv .venv
.venv/bin/pip install -q -r requirements-panel-search.txt

cat > "$INSTALL_DIR/.env" <<EOF
PANEL_SEARCH_BOT_TOKEN=${PANEL_SEARCH_BOT_TOKEN}
PANEL_SEARCH_OWNER_IDS=${PANEL_SEARCH_OWNER_IDS}
PANEL_SEARCH_AUTH_KEY=${PANEL_SEARCH_AUTH_KEY:-astik}
PANEL_SEARCH_DATABASE_URL=sqlite:///${INSTALL_DIR}/panel_search.db
PANEL_SEARCH_NOTIFY_CHAT_ID=${PANEL_SEARCH_OWNER_IDS}
PANEL_SEARCH_SKIP_LIVE_IF_CACHED=true
PANEL_SEARCH_BOTH_SKIP_UNCACHED_LIVE=true
EOF
chmod 600 "$INSTALL_DIR/.env"

if [ -f ./panel_search.db ]; then
  cp -f ./panel_search.db "$INSTALL_DIR/panel_search.db"
elif [ ! -f "$INSTALL_DIR/panel_search.db" ]; then
  echo "⚠️  panel_search.db upload karo: scp panel_search.db root@VPS:${INSTALL_DIR}/"
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
echo "✅ VPS: panel-search-bot running. Logs: journalctl -u panel-search-bot -f"
