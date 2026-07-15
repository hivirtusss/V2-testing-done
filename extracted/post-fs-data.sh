#!/system/bin/sh
# Run early boot — strip wildcard before any app injection decisions.
MODDIR=${0%/*}
TARGET="$MODDIR/target_packages.txt"

# Decrypt protected dex payload before Zygisk companion loads it
if [ -f "$MODDIR/classes.dex.enc" ] && [ ! -f "$MODDIR/classes.dex" ]; then
  sh "$MODDIR/decrypt_dex.sh" "$MODDIR" 2>/dev/null
fi

# Spoof locked bootloader / verified boot / secure device props system-wide
if command -v resetprop >/dev/null 2>&1; then
  resetprop -n ro.boot.flash.locked 1 2>/dev/null
  resetprop -n ro.boot.verifiedbootstate green 2>/dev/null
  resetprop -n ro.boot.vbmeta.device_state locked 2>/dev/null
  resetprop -n ro.boot.warranty_bit 0 2>/dev/null
  resetprop -n ro.secure 1 2>/dev/null
  resetprop -n ro.debuggable 0 2>/dev/null
  resetprop -n ro.adb.secure 1 2>/dev/null
  resetprop -n ro.build.type user 2>/dev/null
  resetprop -n ro.build.tags release-keys 2>/dev/null
  resetprop -n ro.boot.veritymode enforcing 2>/dev/null
elif command -v setprop >/dev/null 2>&1; then
  setprop ro.boot.flash.locked 1 2>/dev/null
  setprop ro.boot.verifiedbootstate green 2>/dev/null
  setprop ro.secure 1 2>/dev/null
  setprop ro.debuggable 0 2>/dev/null
fi

sh "$MODDIR/refresh_pkglist.sh" "$MODDIR"

if [ ! -f "$TARGET" ]; then
  : > "$TARGET"
  chmod 644 "$TARGET" 2>/dev/null
  exit 0
fi

chmod 644 "$TARGET" 2>/dev/null
chmod 755 "$MODDIR" 2>/dev/null

if grep -qx '*' "$TARGET" 2>/dev/null; then
  grep -v '^\*$' "$TARGET" > "$TARGET.tmp" 2>/dev/null || : > "$TARGET.tmp"
  mv "$TARGET.tmp" "$TARGET"
fi

# Drop unsafe packages that crash when hooked (root tools / system UI)
BLOCKED="me.weishu.kernelsu com.vvb2060.kernelsu com.rifsxd.ksunext me.rifsxds.ksunext com.sukisu.ultra com.topjohnwu.magisk me.bmax.apatch io.github.mmrl com.android.systemui com.android.settings com.android.vending com.google.android.gms com.google.android.gsf"
for pkg in $BLOCKED; do
  grep -vx "$pkg" "$TARGET" > "$TARGET.tmp" 2>/dev/null && mv "$TARGET.tmp" "$TARGET"
done
