#!/usr/bin/env bash
# Clean v25 mono zip: user base only — no backup extras, bubble always show, telegram mono.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/user_file/user_upload.zip"
OUT="$ROOT/releases/virtus_v25_mono.zip"
WORK="$(mktemp -d)"
STAGE="$(mktemp -d)"
trap 'rm -rf "$WORK" "$STAGE"' EXIT

python3 "$ROOT/scripts/patch_telegram_mono_dex.py" "$SRC" "$WORK/classes.dex"

unzip -q "$SRC" -d "$STAGE"
cp "$WORK/classes.dex" "$STAGE/classes.dex"

# Drop any backup / controller extras if present in source tree.
rm -rf "$STAGE/bin" "$STAGE/backups" "$STAGE/virtus_config" "$STAGE/classes.dex.enc" "$STAGE/decrypt_dex.sh"

cat > "$STAGE/module.prop" <<'EOF'
id=zygisk_floating_menu
name=Zygisk Mode Menu By V3 @Hivirtus 🔥
version=v25
versionCode=25
author=@Hivirtus
description=Zygisk Mode Menu By V3 @Hivirtus 🔥
webui=webroot
zygote=true
EOF

cd "$STAGE"
chmod 755 post-fs-data.sh service.sh customize.sh refresh_pkglist.sh action.sh 2>/dev/null || true
rm -f "$OUT"
zip -qr "$OUT" .
echo "built $OUT ($(wc -c < "$OUT") bytes)"
echo "classes.dex: $(wc -c < "$STAGE/classes.dex") bytes"
unzip -l "$OUT" | awk 'NR>3 && NF {print $4}' | sort

ORIG_DEX=$(unzip -p "$SRC" classes.dex | md5sum | awk '{print $1}')
NEW_DEX=$(md5sum "$STAGE/classes.dex" | awk '{print $1}')
echo "dex: $ORIG_DEX -> $NEW_DEX"
