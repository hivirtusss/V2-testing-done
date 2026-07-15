#!/system/bin/sh
TARGET="$MODPATH/target_packages.txt"
mkdir -p "$MODPATH/webroot"
if [ ! -f "$TARGET" ]; then
  : > "$TARGET"
else
  grep -v '^\*$' "$TARGET" 2>/dev/null | grep -v '^\s*$' > "$TARGET.tmp" || : > "$TARGET.tmp"
  mv "$TARGET.tmp" "$TARGET"
fi
chmod 755 "$MODPATH/action.sh" 2>/dev/null
chmod 755 "$MODPATH/post-fs-data.sh" 2>/dev/null
chmod 755 "$MODPATH/service.sh" 2>/dev/null
