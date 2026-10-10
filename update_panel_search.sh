#!/usr/bin/env bash
# PC pe 15 min: sirf yeh script — code update + bot restart ( .env.panel_search / panel_search.db touch mat hote )
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT_DIR"

BRANCH="${PANEL_SEARCH_BRANCH:-cursor/panel-search-bot-8042}"

echo "📥 Pull branch: $BRANCH"
git fetch origin "$BRANCH"
git checkout "$BRANCH"
git pull origin "$BRANCH"

if [ -x "$ROOT_DIR/stop_panel_search.sh" ]; then
  bash "$ROOT_DIR/stop_panel_search.sh" || true
fi
bash "$ROOT_DIR/start_panel_search.sh"

echo ""
echo "✅ Panel Search updated + running."
echo "   Config: .env.panel_search | DB: panel_search.db (yeh git se change nahi hote)"
