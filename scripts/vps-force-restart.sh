#!/usr/bin/env bash
# Force new bot code to load — kill stale python + restart systemd.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
PORT="${PORT:-8000}"

echo "==> stop systemd"
for svc in sms-monitor virtus-bot virtus; do
  if systemctl list-unit-files "${svc}.service" 2>/dev/null | grep -q "${svc}.service"; then
    sudo systemctl stop "$svc" 2>/dev/null || true
    echo "  stopped $svc"
  fi
done

echo "==> kill stale run.py / uvicorn (old code still in RAM)"
sudo pkill -f "${ROOT}/run.py" 2>/dev/null || true
sudo pkill -f "sms-monitor" 2>/dev/null || true
sleep 1

if [ -f "$ROOT/.sms-monitor.pid" ]; then
  oldpid="$(cat "$ROOT/.sms-monitor.pid" 2>/dev/null || true)"
  if [ -n "$oldpid" ] && kill -0 "$oldpid" 2>/dev/null; then
    kill "$oldpid" 2>/dev/null || sudo kill "$oldpid" 2>/dev/null || true
    echo "  killed nohup PID $oldpid"
  fi
  rm -f "$ROOT/.sms-monitor.pid"
fi

echo "==> start systemd"
started=0
for svc in sms-monitor virtus-bot virtus; do
  if systemctl list-unit-files "${svc}.service" 2>/dev/null | grep -q "${svc}.service"; then
    sudo systemctl daemon-reload 2>/dev/null || true
    sudo systemctl start "$svc"
    echo "  started $svc"
    started=1
    break
  fi
done

if [ "$started" -eq 0 ]; then
  echo "  no systemd — trying start.sh"
  bash "$ROOT/stop.sh" 2>/dev/null || true
  bash "$ROOT/start.sh"
fi

sleep 3
echo ""
echo "==> health (MUST show deploy_tag + git_rev)"
if curl -sf "http://127.0.0.1:${PORT}/health" | python3 -m json.tool; then
  if curl -sf "http://127.0.0.1:${PORT}/health" | grep -q deploy_tag; then
    echo ""
    echo "OK — naya bot code chal raha hai. Ab /startmonitor bhejo."
  else
    echo ""
    echo "FAIL — deploy_tag missing = PURANA bot ab bhi chal raha hai!"
    echo "  Check: systemctl status sms-monitor"
    echo "  Logs:  journalctl -u sms-monitor -n 40 --no-pager"
    exit 1
  fi
else
  echo "FAIL — bot :${PORT} pe respond nahi kar raha"
  exit 1
fi
