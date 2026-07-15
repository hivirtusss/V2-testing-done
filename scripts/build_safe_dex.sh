#!/usr/bin/env bash
# Assemble classes.dex from original user smali + minimal safe patches.
# Dex size must stay ~240KB (original 239932). Do NOT add new classes or base64 blobs.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${1:-$ROOT/extracted/classes.dex}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

cp -r "$ROOT/user_smali/." "$WORK/"
cp "$ROOT/patch_smali/com/floatingmenu/MenuLoader\$1\$1.smali" "$WORK/com/floatingmenu/"
cp "$ROOT/patch_smali/com/floatingmenu/MenuLoader\$1.smali" "$WORK/com/floatingmenu/"
cp "$ROOT/patch_smali/com/floatingmenu/MenuLoader\$8\$1.smali" "$WORK/com/floatingmenu/"
cp "$ROOT/patch_smali/com/floatingmenu/MenuLoader.smali" "$WORK/com/floatingmenu/"

FM="$WORK/com/floatingmenu/FloatingMenu\$1.smali"
python3 "$ROOT/scripts/patch_logo.py" "$FM" "$ROOT/tools/virtus_v_logo.b64"

# Text + layout only — keep ORIGINAL menu colours from user_smali (green/teal theme)
sed -i \
  -e 's/"Zygisk Mod Menu By @Hivirtus"/"Zygisk Mode Menu Virtus V3"/' \
  -e 's/"@Hivirtus | Zygisk Mode Menu Virtus v3"/"Zygisk Mode Menu Virtus V3"/' \
  -e 's/"Zygisk Injected. Developed for Android."/"Virtus V3 Security Tester"/' \
  -e 's/"Zygisk Devlope By @Hivirtus"/"Virtus V3 Security Tester"/' \
  -e 's/"System SIM Card Configuration"/"System SIM Configuration"/' \
  -e 's/"@Hivirtus | System SIM Configuration"/"System SIM Configuration"/' \
  -e 's/const-string v5, "M"/const-string v5, "V"/' \
  -e 's/const\/16 v9, 0x33/const\/16 v9, 0x11/' \
  -e 's/const\/high16 v6, 0x41a00000    # 20.0f/const\/high16 v6, 0x0/' \
  -e 's/const\/high16 v7, 0x43160000    # 150.0f/const\/high16 v7, 0x0/' \
  "$FM"

java -jar "$ROOT/smali.jar" a "$WORK" -o "$OUT"
BYTES=$(wc -c < "$OUT")
echo "Built $OUT ($BYTES bytes)"
if [ "$BYTES" -gt 245000 ]; then
  echo "ERROR: dex too large ($BYTES > 245000) — aborting" >&2
  exit 1
fi
