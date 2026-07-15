#!/system/bin/sh
TARGET="$MODPATH/target_packages.txt"
mkdir -p "$MODPATH/webroot" "$MODPATH/virtus_config" "$MODPATH/backups" "$MODPATH/bin"
if [ ! -f "$TARGET" ]; then
  : > "$TARGET"
else
  grep -v '^\*$' "$TARGET" 2>/dev/null | grep -v '^\s*$' > "$TARGET.tmp" || : > "$TARGET.tmp"
  mv "$TARGET.tmp" "$TARGET"
fi
sh "$MODPATH/refresh_pkglist.sh" "$MODPATH"
chmod 755 "$MODPATH/action.sh" 2>/dev/null
chmod 755 "$MODPATH/post-fs-data.sh" 2>/dev/null
chmod 755 "$MODPATH/service.sh" 2>/dev/null
chmod 755 "$MODPATH/refresh_pkglist.sh" 2>/dev/null
chmod 755 "$MODPATH/bin/virtus_backup.sh" 2>/dev/null || true
chmod 755 "$MODPATH/bin/virtus_identity.sh" 2>/dev/null || true
chmod 777 "$MODPATH/virtus_config" "$MODPATH/backups" 2>/dev/null || true
