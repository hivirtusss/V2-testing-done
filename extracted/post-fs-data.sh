#!/system/bin/sh
# Run early boot — strip wildcard before any app injection decisions.
MODDIR=${0%/*}
TARGET="$MODDIR/target_packages.txt"
PKGFILE="$MODDIR/pkglist.txt"

# Refresh app list cache for WebUI
{
  pm list packages -3 2>/dev/null
  pm list packages -3 -u 2>/dev/null
  cmd package list packages --user 0 -3 2>/dev/null
} | sed 's/^package://g' | sort -u | grep -v '^\s*$' > "$PKGFILE" 2>/dev/null || : > "$PKGFILE"
chmod 644 "$PKGFILE" 2>/dev/null

if [ ! -f "$TARGET" ]; then
  : > "$TARGET"
  exit 0
fi

if grep -qx '*' "$TARGET" 2>/dev/null; then
  grep -v '^\*$' "$TARGET" > "$TARGET.tmp" 2>/dev/null || : > "$TARGET.tmp"
  mv "$TARGET.tmp" "$TARGET"
fi

# Drop unsafe packages that crash when hooked (root tools / system UI)
BLOCKED="me.weishu.kernelsu com.vvb2060.kernelsu com.rifsxd.ksunext me.rifsxds.ksunext com.sukisu.ultra com.topjohnwu.magisk me.bmax.apatch io.github.mmrl com.android.systemui com.android.settings com.android.vending com.google.android.gms com.google.android.gsf"
for pkg in $BLOCKED; do
  grep -vx "$pkg" "$TARGET" > "$TARGET.tmp" 2>/dev/null && mv "$TARGET.tmp" "$TARGET"
done
