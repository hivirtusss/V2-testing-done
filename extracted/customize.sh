#!/system/bin/sh
TARGET="$MODPATH/target_packages.txt"
PKGFILE="$MODPATH/pkglist.txt"
mkdir -p "$MODPATH/webroot"
if [ ! -f "$TARGET" ]; then
  : > "$TARGET"
else
  grep -v '^\*$' "$TARGET" 2>/dev/null | grep -v '^\s*$' > "$TARGET.tmp" || : > "$TARGET.tmp"
  mv "$TARGET.tmp" "$TARGET"
fi
# Cache installed user apps for WebUI (SukiSU listUserPackages often returns wrong data)
{
  pm list packages -3 2>/dev/null
  pm list packages -3 -u 2>/dev/null
  cmd package list packages --user 0 -3 2>/dev/null
} | sed 's/^package://g' | sort -u | grep -v '^\s*$' > "$PKGFILE" || : > "$PKGFILE"
chmod 644 "$PKGFILE" 2>/dev/null
chmod 755 "$MODPATH/action.sh" 2>/dev/null
chmod 755 "$MODPATH/post-fs-data.sh" 2>/dev/null
chmod 755 "$MODPATH/service.sh" 2>/dev/null
