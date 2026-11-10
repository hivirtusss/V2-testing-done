#!/usr/bin/env bash
# Import Panda Firebase dump into sms-monitor pool + rescan (run on VPS from repo root).
set -euo pipefail
cd "$(dirname "$0")/.."
if [[ -f data/panda_firebase_dump.txt ]]; then
  python3 scripts/parse_panda_firebase_dump.py data/panda_firebase_dump.txt
fi
echo "Pool URLs: $(grep -cve '^#' data/firebase_pool.txt || true)"
systemctl restart sms-monitor 2>/dev/null || true
echo "On next bot start, ensure_pool_loaded() will upsert all URLs into firebase_sources."
