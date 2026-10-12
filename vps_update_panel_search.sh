#!/usr/bin/env bash
# Sirf Panel Search bot update — SMS monitor (/opt/sms-monitor) touch nahi.
set -euo pipefail

PANEL_DIR="${PANEL_DIR:-/opt/panel-search-bot}"
BR="${PANEL_BRANCH:-cursor/panel-search-bot-8042}"
REPO="${VPS_REPO:-https://github.com/hivirtusss/V2-testing-done.git}"

if [ "$(id -u)" -ne 0 ]; then
  echo "❌ root se chalao"
  exit 1
fi

rm -rf /tmp/panel-search-upd
git clone -b "$BR" --depth 1 "$REPO" /tmp/panel-search-upd
mkdir -p "$PANEL_DIR"
rsync -a --exclude '.git' --exclude '.env' --exclude 'panel_search.db' --exclude '.venv' \
  /tmp/panel-search-upd/panel_search_bot/ "$PANEL_DIR/panel_search_bot/"
rsync -a /tmp/panel-search-upd/requirements-panel-search.txt "$PANEL_DIR/"
[ -f "$PANEL_DIR/.venv/bin/pip" ] && "$PANEL_DIR/.venv/bin/pip" install -q -r "$PANEL_DIR/requirements-panel-search.txt"

# Force live fetch on online scan (purani .env override hatao)
if [ -f "$PANEL_DIR/.env" ]; then
  sed -i 's/^PANEL_SEARCH_ONLINE_SKIP_CACHED_LIVE=.*/PANEL_SEARCH_ONLINE_SKIP_CACHED_LIVE=false/' "$PANEL_DIR/.env" || true
  grep -q '^PANEL_SEARCH_ONLINE_SKIP_CACHED_LIVE=' "$PANEL_DIR/.env" || \
    echo 'PANEL_SEARCH_ONLINE_SKIP_CACHED_LIVE=false' >> "$PANEL_DIR/.env"
fi

systemctl restart panel-search-bot 2>/dev/null || (
  cd "$PANEL_DIR" && bash stop_panel_search.sh 2>/dev/null; bash start_panel_search.sh
)
echo "✅ Panel Search updated (SMS monitor untouched)"
