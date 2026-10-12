#!/usr/bin/env bash
# Panel Search bot — VPS install (systemd). Virtus module alag rehta hai.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

TOKEN="${PANEL_SEARCH_BOT_TOKEN:-}"
OWNER_IDS="${PANEL_SEARCH_OWNER_IDS:-}"
AUTH_KEY="${PANEL_SEARCH_AUTH_KEY:-astik}"
LEAK_FILE="${PANEL_SEARCH_LEAK_FILE:-}"

while [ $# -gt 0 ]; do
  case "$1" in
    --token) TOKEN="$2"; shift 2 ;;
    --owner-id) OWNER_IDS="$2"; shift 2 ;;
    --auth-key) AUTH_KEY="$2"; shift 2 ;;
    --leak-file) LEAK_FILE="$2"; shift 2 ;;
    *) echo "Unknown arg: $1"; exit 1 ;;
  esac
done

echo "🔍 Panel Search Bot — VPS Install"
echo "================================"

python3 -m pip install -r requirements.txt -q

write_env() {
  local target="$1"
  cat > "$target" <<EOF
# Panel Search Bot (standalone)
PANEL_SEARCH_BOT_TOKEN=${TOKEN}
PANEL_SEARCH_OWNER_IDS=${OWNER_IDS}
PANEL_SEARCH_AUTH_KEY=${AUTH_KEY}
PANEL_SEARCH_DATABASE_URL=sqlite:///${2}/panel_search.db
PANEL_SEARCH_NOTIFY_CHAT_ID=${OWNER_IDS}
EOF
  if [ -n "$LEAK_FILE" ]; then
    echo "PANEL_SEARCH_LEAK_FILE=${LEAK_FILE}" >> "$target"
  fi
  chmod 600 "$target"
}

if [ "$(id -u)" -eq 0 ]; then
  INSTALL_DIR="/opt/panel-search-bot"
  echo "Installing to $INSTALL_DIR"
  mkdir -p "$INSTALL_DIR"
  rsync -a --exclude '.git' --exclude '__pycache__' --exclude 'venv' --exclude '.venv' \
    "$ROOT_DIR/" "$INSTALL_DIR/"
  cd "$INSTALL_DIR"
  python3 -m pip install -r requirements.txt -q

  if [ -z "$TOKEN" ] || [ -z "$OWNER_IDS" ]; then
    if [ -f "$INSTALL_DIR/.env" ]; then
      echo "Using existing $INSTALL_DIR/.env (pass --token / --owner-id to overwrite)"
    else
      echo "❌ PANEL_SEARCH_BOT_TOKEN aur --owner-id required (ya pehle se .env ho)"
      exit 1
    fi
  else
    write_env "$INSTALL_DIR/.env" "$INSTALL_DIR"
  fi

  cat > /etc/systemd/system/panel-search-bot.service <<EOF
[Unit]
Description=Panel Search Telegram Bot (Firebase SMS search)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=root
WorkingDirectory=${INSTALL_DIR}
EnvironmentFile=${INSTALL_DIR}/.env
ExecStart=/usr/bin/python3 -m panel_search_bot.run_bot
Restart=always
RestartSec=5
StandardOutput=append:${INSTALL_DIR}/panel_search.log
StandardError=append:${INSTALL_DIR}/panel_search.log

[Install]
WantedBy=multi-user.target
EOF

  systemctl daemon-reload
  systemctl enable panel-search-bot
  systemctl restart panel-search-bot
  sleep 1
  systemctl --no-pager status panel-search-bot || true
  echo ""
  echo "✅ panel-search-bot service running"
  echo "   Logs: tail -f ${INSTALL_DIR}/panel_search.log"
  echo "   Status: systemctl status panel-search-bot"
else
  if [ -z "$TOKEN" ] || [ -z "$OWNER_IDS" ]; then
    echo "❌ Non-root install needs: PANEL_SEARCH_BOT_TOKEN=... PANEL_SEARCH_OWNER_IDS=... $0"
    exit 1
  fi
  write_env "$ROOT_DIR/.env.panel_search" "$ROOT_DIR"
  echo "✅ Wrote .env.panel_search — run: ./start_panel_search.sh"
fi
