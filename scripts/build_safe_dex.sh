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

# Red Virtus V3 UI — match smali_out colors (NO base64 logo swap — keeps dex safe)
FM="$WORK/com/floatingmenu/FloatingMenu\$1.smali"
sed -i \
  -e 's/"Zygisk Mod Menu By @Hivirtus"/"@Hivirtus | Zygisk Mode Menu Virtus v3"/' \
  -e 's/"Zygisk Injected. Developed for Android."/"Zygisk Devlope By @Hivirtus"/' \
  -e 's/"System SIM Card Configuration"/"@Hivirtus | System SIM Configuration"/' \
  -e 's/const-string v5, "M"/const-string v5, "V"/' \
  -e 's/const v7, -0x9c990f/const v7, -0x3be1c6/g' \
  -e 's/const v8, -0xb0b91b/const v8, -0x760000/g' \
  -e 's/const v5, -0x11eee7d9/const v5, -0x19ededee/g' \
  -e 's/const v8, -0xc8beaf/const v8, -0x3be1c6/g' \
  -e 's/const v4, -0xc8beaf/const v4, -0x3be1c6/g' \
  -e 's/const v6, -0xc8beaf/const v6, -0x3be1c6/g' \
  -e 's/const v16, -0xc8beaf/const v16, -0x3be1c6/g' \
  -e 's/const v1, -0xc8beaf/const v1, -0x3be1c6/g' \
  -e 's/const v5, -0x635c51/const v5, -0x50306/g' \
  -e 's/const v4, -0x635c51/const v4, -0x50306/g' \
  -e 's/const v3, -0x635c51/const v3, -0x50306/g' \
  -e 's/const v14, -0x635c51/const v14, -0x50306/g' \
  -e 's/const v18, -0x635c51/const v18, -0x50306/g' \
  -e 's/const v13, -0x635c51/const v13, -0x50306/g' \
  -e 's/const v2, -0x635c51/const v2, -0x50306/g' \
  -e 's/const v7, -0x635c51/const v7, -0x50306/g' \
  -e 's/const v8, -0xb4aa9d/const v8, -0x7f9fa0/g' \
  -e 's/const v1, -0xb4aa9d/const v1, -0x7f9fa0/g' \
  -e 's/const v2, -0xb4aa9d/const v2, -0x7f9fa0/g' \
  -e 's/const v24, -0xb4aa9d/const v24, -0x7f9fa0/g' \
  -e 's/const v17, -0xb4aa9d/const v17, -0x7f9fa0/g' \
  -e 's/const v9, -0xe0d6c9/const v9, -0x66999a/g' \
  -e 's/const v1, -0xe0d6c9/const v1, -0x66999a/g' \
  -e 's/const v13, -0xda9c15/const v13, -0xff0033/g' \
  -e 's/const v4, -0xef467f/const v4, -0xff0033/g' \
  -e 's/const v2, -0x948d80/const v2, -0x50306/g' \
  "$FM"

java -jar "$ROOT/smali.jar" a "$WORK" -o "$OUT"
BYTES=$(wc -c < "$OUT")
echo "Built $OUT ($BYTES bytes)"
if [ "$BYTES" -gt 245000 ]; then
  echo "ERROR: dex too large ($BYTES > 245000) — aborting" >&2
  exit 1
fi
