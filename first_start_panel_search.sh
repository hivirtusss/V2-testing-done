#!/usr/bin/env bash
# Pehli baar (ya fresh PC): branch + deps + Panel Search start — ek command
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

BRANCH="${PANEL_SEARCH_BRANCH:-cursor/panel-search-bot-8042}"

echo "📥 Git: $BRANCH"
git fetch origin "$BRANCH"
git checkout "$BRANCH"
git pull origin "$BRANCH"

if [ ! -f .env.panel_search ]; then
  if [ -f .env.panel_search.example ]; then
    cp .env.panel_search.example .env.panel_search
    echo ""
    echo "❌ .env.panel_search ban gaya — ab isme PANEL_SEARCH_BOT_TOKEN + OWNER_ID daalo,"
    echo "   phir dubara: bash first_start_panel_search.sh"
    exit 1
  fi
  echo "❌ .env.panel_search missing. Example file bhi nahi mila."
  exit 1
fi

set -a
# shellcheck disable=SC1091
source .env.panel_search
set +a
if [ -z "${PANEL_SEARCH_BOT_TOKEN:-}" ]; then
  echo "❌ .env.panel_search mein PANEL_SEARCH_BOT_TOKEN khali hai."
  exit 1
fi

if [ ! -f panel_search.db ] && [ ! -f "${PANEL_SEARCH_DATABASE_URL#sqlite:///}" ] 2>/dev/null; then
  echo "⚠️  panel_search.db nahi mili — empty DB se start (724 Firebase baad mein /fb se)."
fi

if [ -x "$ROOT_DIR/stop_panel_search.sh" ]; then
  bash "$ROOT_DIR/stop_panel_search.sh" 2>/dev/null || true
fi
bash "$ROOT_DIR/start_panel_search.sh"

echo ""
echo "✅ Panel Search chal raha hai. Telegram pe /search try karo."
echo "   Log: tail -f panel_search.log"
