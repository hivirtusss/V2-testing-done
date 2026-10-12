#!/usr/bin/env bash
# Hostinger Web Terminal / VPS — bina PC ke update + restart (phone se paste OK)
set -euo pipefail

INSTALL_DIR="${PANEL_INSTALL_DIR:-/opt/panel-search-bot}"
BRANCH="${PANEL_SEARCH_BRANCH:-cursor/panel-search-bot-8042}"
REPO="${PANEL_SEARCH_REPO:-https://github.com/hivirtusss/V2-testing-done.git}"

echo "🔍 Panel Search remote update → $INSTALL_DIR (branch $BRANCH)"

if [ ! -d "$INSTALL_DIR/.git" ]; then
  echo "❌ $INSTALL_DIR mein git nahi — pehle vps_panel_search_setup.sh chalao."
  exit 1
fi

cd "$INSTALL_DIR"
git fetch origin "$BRANCH"
git checkout "$BRANCH"
git pull origin "$BRANCH"

if [ -d .venv ]; then
  .venv/bin/pip install -q -r requirements-panel-search.txt
fi

DB="${INSTALL_DIR}/panel_search.db"
if [ -f "$DB" ]; then
  if command -v sqlite3 >/dev/null 2>&1; then
    echo "🔄 Offline flags reset (taaki scan dubara chale)…"
    sqlite3 "$DB" "UPDATE firebase_dbs SET is_online=NULL WHERE is_online=0;"
  fi
fi

systemctl restart panel-search-bot
sleep 1
systemctl --no-pager status panel-search-bot || true
echo ""
echo "✅ Done. Logs: journalctl -u panel-search-bot -n 30 --no-pager"
