#!/usr/bin/env bash
# Assemble classes.dex from original user smali + minimal safe patches.
# Dex size must stay ~240KB (original 239932). Do NOT add new classes or base64 blobs.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
OUT="${1:-$ROOT/extracted/classes.dex}"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

python3 "$ROOT/scripts/prepare_logo.py"

cp -r "$ROOT/user_smali/." "$WORK/"
cp "$ROOT/patch_smali/com/floatingmenu/IdentityGuard.smali" "$WORK/com/floatingmenu/"
cp "$ROOT/patch_smali/com/floatingmenu/MenuLoader\$20.smali" "$WORK/com/floatingmenu/"
python3 "$ROOT/scripts/patch_android_id_hook.py" "$WORK"
cp "$ROOT/patch_smali/com/floatingmenu/MenuLoader\$1\$1.smali" "$WORK/com/floatingmenu/"
cp "$ROOT/patch_smali/com/floatingmenu/MenuLoader\$1.smali" "$WORK/com/floatingmenu/"
cp "$ROOT/patch_smali/com/floatingmenu/MenuLoader\$8\$1.smali" "$WORK/com/floatingmenu/"
cp "$ROOT/patch_smali/com/floatingmenu/MenuLoader\$1\$1\$1\$1.smali" "$WORK/com/floatingmenu/"
# Keep user's MenuLoader.smali (native is_target_package + isTargetApplication) — do NOT override.

FM="$WORK/com/floatingmenu/FloatingMenu\$1.smali"
FO="$WORK/com/floatingmenu/FloatingMenu.smali"
python3 "$ROOT/scripts/patch_logo.py" "$FM" "$ROOT/tools/virtus_v_logo.b64"
python3 "$ROOT/scripts/patch_bubble_drag.py" "$FM"

apply_red_theme() {
  local file="$1"
  sed -i \
    -e 's/"Zygisk Mod Menu By @Hivirtus"/"Zygisk Mode Menu Virtus V3"/' \
    -e 's/"@Hivirtus | Zygisk Mode Menu Virtus v3"/"Zygisk Mode Menu Virtus V3"/' \
    -e 's/"Zygisk Injected. Developed for Android."/"Virtus V3 Security Tester"/' \
    -e 's/"Zygisk Devlope By @Hivirtus"/"Virtus V3 Security Tester"/' \
    -e 's/"System SIM Card Configuration"/"System SIM Configuration"/' \
    -e 's/"@Hivirtus | System SIM Configuration"/"System SIM Configuration"/' \
    -e 's/const-string v5, "M"/const-string v5, "V"/' \
    -e 's/const\/high16 v6, 0x41a00000    # 20.0f/const\/high16 v6, 0x0/' \
    -e 's/const\/high16 v7, 0x43160000    # 150.0f/const\/high16 v7, 0x0/' \
    -e 's/const v7, -0x9c990f/const v7, -0x1000000/g' \
    -e 's/const v8, -0xb0b91b/const v8, -0x760000/g' \
    -e 's/const v5, -0x11eee7d9/const v5, -0x19ededee/g' \
    -e 's/const v8, -0xc8beaf/const v8, -0x3be1c6/g' \
    -e 's/const v4, -0xc8beaf/const v4, -0x3be1c6/g' \
    -e 's/const v6, -0xc8beaf/const v6, -0x3be1c6/g' \
    -e 's/const v16, -0xc8beaf/const v16, -0x3be1c6/g' \
    -e 's/const v1, -0xc8beaf/const v1, -0x3be1c6/g' \
    -e 's/const v5, -0x635c51/const v5, -0x1/g' \
    -e 's/const v4, -0x635c51/const v4, -0x1/g' \
    -e 's/const v3, -0x635c51/const v3, -0x1/g' \
    -e 's/const v14, -0x635c51/const v14, -0x1/g' \
    -e 's/const v18, -0x635c51/const v18, -0x1/g' \
    -e 's/const v13, -0x635c51/const v13, -0x1/g' \
    -e 's/const v2, -0x635c51/const v2, -0x1/g' \
    -e 's/const v7, -0x635c51/const v7, -0x1/g' \
    -e 's/const v8, -0xb4aa9d/const v8, -0x888888/g' \
    -e 's/const v1, -0xb4aa9d/const v1, -0x888888/g' \
    -e 's/const v2, -0xb4aa9d/const v2, -0x888888/g' \
    -e 's/const v24, -0xb4aa9d/const v24, -0x888888/g' \
    -e 's/const v17, -0xb4aa9d/const v17, -0x888888/g' \
    -e 's/const v9, -0xe0d6c9/const v9, -0x660000/g' \
    -e 's/const v1, -0xe0d6c9/const v1, -0x660000/g' \
    -e 's/const v10, -0xe0d6c9/const v10, -0x660000/g' \
    -e 's/const v13, -0xda9c15/const v13, -0x2cd0d1/g' \
    -e 's/const v4, -0xef467f/const v4, -0x2cd0d1/g' \
    -e 's/const v6, -0xef467f/const v6, -0x2cd0d1/g' \
    -e 's/const v2, -0x948d80/const v2, -0x66999a/g' \
    "$file"
}

apply_red_theme "$FM"
apply_red_theme "$FO"
python3 "$ROOT/scripts/patch_white_title.py" "$FM"
python3 "$ROOT/scripts/patch_floating_show.py" "$FO"
python3 "$ROOT/scripts/patch_pm_blocklist.py" "$WORK/com/floatingmenu/MenuLoader\$20.smali"

find "$WORK" -name '*.smali' -print0 | xargs -0 sed -i 's/ZygiskMenu @Hivirtus/SysFrameworkService/g'

java -jar "$ROOT/smali.jar" a "$WORK" -o "$OUT"
BYTES=$(wc -c < "$OUT")
echo "Built $OUT ($BYTES bytes)"
if [ "$BYTES" -gt 248000 ]; then
  echo "ERROR: dex too large ($BYTES > 248000) — aborting" >&2
  exit 1
fi
