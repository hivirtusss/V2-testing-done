#!/usr/bin/env bash
# Standalone Virtus Emulator Root Hide module (NOT v25 mono).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_ZIP="${1:-$ROOT/zygisk_floating_menu_hivirtus_selection.zip}"
OUT_ZIP="${2:-$ROOT/releases/virtus_emu_roothide.zip}"
WORK="$(mktemp -d)"
STAGE="$(mktemp -d)"
trap 'rm -rf "$WORK" "$STAGE"' EXIT

for jar in smali.jar baksmali.jar; do
  if [ ! -f "$ROOT/$jar" ]; then
    echo "Missing $ROOT/$jar — download smali 2.5.2 fat jars first." >&2
    exit 1
  fi
done

unzip -q "$SRC_ZIP" -d "$STAGE"
java -jar "$ROOT/baksmali.jar" d "$STAGE/classes.dex" -o "$WORK/smali"
python3 "$ROOT/scripts/apply_emu_roothide_dex.py" "$WORK/smali"
java -jar "$ROOT/smali.jar" a "$WORK/smali" -o "$STAGE/classes.dex"

cat > "$STAGE/module.prop" <<'EOF'
id=virtus_emu_roothide
name=Virtus Emulator Root Hide
version=emu-1
versionCode=1
author=@Hivirtus
description=Emulator only: hide root/Magisk from apps. Does nothing on real phones.
webui=webroot
zygote=true
EOF

cat > "$STAGE/customize.sh" <<'EOF'
#!/system/bin/sh
TARGET="$MODPATH/target_packages.txt"
mkdir -p "$MODPATH/webroot"
echo '*' > "$TARGET"
sh "$MODPATH/refresh_pkglist.sh" "$MODPATH"
chmod 755 "$MODPATH/action.sh" 2>/dev/null
chmod 755 "$MODPATH/post-fs-data.sh" 2>/dev/null
chmod 755 "$MODPATH/service.sh" 2>/dev/null
chmod 755 "$MODPATH/refresh_pkglist.sh" 2>/dev/null
EOF
chmod 755 "$STAGE/customize.sh"

cat > "$STAGE/post-fs-data.sh" <<'EOF'
#!/system/bin/sh
MODDIR=${0%/*}
TARGET="$MODDIR/target_packages.txt"
sh "$MODDIR/refresh_pkglist.sh" "$MODDIR"
# Emulator module: keep wildcard + refresh user app list for injection.
if [ ! -f "$TARGET" ]; then
  echo '*' > "$TARGET"
fi
if ! grep -qx '*' "$TARGET" 2>/dev/null; then
  echo '*' >> "$TARGET"
fi
PKG="$MODDIR/pkglist.txt"
if [ -f "$PKG" ]; then
  while IFS= read -r line; do
    [ -z "$line" ] && continue
    grep -qx "$line" "$TARGET" 2>/dev/null || echo "$line" >> "$TARGET"
  done < "$PKG"
fi
EOF
chmod 755 "$STAGE/post-fs-data.sh"

cat > "$STAGE/service.sh" <<'EOF'
#!/system/bin/sh
MODDIR=${0%/*}
TARGET="$MODDIR/target_packages.txt"
[ -f "$MODDIR/refresh_pkglist.sh" ] && sh "$MODDIR/refresh_pkglist.sh" "$MODDIR"
PKG="$MODDIR/pkglist.txt"
[ -f "$PKG" ] || exit 0
while IFS= read -r line; do
  [ -z "$line" ] && continue
  grep -qx "$line" "$TARGET" 2>/dev/null || echo "$line" >> "$TARGET"
done < "$PKG"
EOF
chmod 755 "$STAGE/service.sh"

mkdir -p "$ROOT/releases"
rm -f "$OUT_ZIP"
(cd "$STAGE" && zip -qr "$OUT_ZIP" .)
echo "built $OUT_ZIP ($(wc -c < "$OUT_ZIP") bytes)"
echo "classes.dex: $(wc -c < "$STAGE/classes.dex") bytes"
md5sum "$STAGE/classes.dex"
