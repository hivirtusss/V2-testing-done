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

# Title, bubble V fallback, red bubble gradient + panel tint
FM="$WORK/com/floatingmenu/FloatingMenu\$1.smali"
sed -i 's/"Zygisk Mod Menu By @Hivirtus"/"Zygisk Mode Menu Virtus V3"/' "$FM"
sed -i 's/const-string v5, "M"/const-string v5, "V"/' "$FM"
sed -i 's/const v7, -0x9c990f/const v7, -0x3be1c6/' "$FM"
sed -i 's/const v8, -0xb0b91b/const v8, -0x760000/' "$FM"
sed -i 's/const v5, -0x11eee7d9/const v5, -0x19ededee/' "$FM"

java -jar "$ROOT/smali.jar" a "$WORK" -o "$OUT"
BYTES=$(wc -c < "$OUT")
echo "Built $OUT ($BYTES bytes)"
if [ "$BYTES" -gt 245000 ]; then
  echo "ERROR: dex too large ($BYTES > 245000) — aborting" >&2
  exit 1
fi
