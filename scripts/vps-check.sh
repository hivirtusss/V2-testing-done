#!/usr/bin/env bash
# Quick VPS health — server + bot running?
set -euo pipefail
PORT="${PORT:-8000}"
echo "=== sms-monitor service ==="
systemctl is-active sms-monitor 2>/dev/null || systemctl is-active virtus-bot 2>/dev/null || echo "service not found"
systemctl status sms-monitor 2>/dev/null | head -8 || systemctl status virtus-bot 2>/dev/null | head -8 || true
echo ""
echo "=== health ==="
curl -sf "http://127.0.0.1:${PORT}/health" | python3 -m json.tool 2>/dev/null || echo "FAIL — bot not responding on :${PORT}"
echo ""
echo "=== recent logs ==="
journalctl -u sms-monitor -n 15 --no-pager 2>/dev/null || journalctl -u virtus-bot -n 15 --no-pager 2>/dev/null || true
