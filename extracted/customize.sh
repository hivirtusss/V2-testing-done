#!/system/bin/sh
TARGET="$MODPATH/target_packages.txt"
if [ ! -f "$TARGET" ]; then
  : > "$TARGET"
fi
chmod 755 "$MODPATH/action.sh" 2>/dev/null
