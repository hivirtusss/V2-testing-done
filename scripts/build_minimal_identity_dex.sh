#!/usr/bin/env bash
# User smali + IdentityGuard only — bubble-safe device ID hook (no TargetListGuard / MenuLoader overrides).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${1:-$ROOT/extracted/classes.dex}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

cp -r "$ROOT/user_smali/." "$WORK/"
cp "$ROOT/patch_smali/com/floatingmenu/IdentityGuard.smali" "$WORK/com/floatingmenu/"
python3 "$ROOT/scripts/patch_android_id_hook.py" "$WORK"

find "$WORK" -name '*.smali' -print0 | xargs -0 sed -i 's/ZygiskMenu @Hivirtus/SysFrameworkService/g'

java -jar "$ROOT/smali.jar" a "$WORK" -o "$OUT"
BYTES=$(wc -c < "$OUT")
echo "Built minimal identity dex: $OUT ($BYTES bytes)"
if [ "$BYTES" -gt 248000 ]; then
  echo "ERROR: dex too large ($BYTES > 248000)" >&2
  exit 1
fi
