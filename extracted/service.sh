#!/system/bin/sh
MODDIR=${0%/*}

TARGET="$MODDIR/target_packages.txt"

# Always strip wildcard — never hook all apps
if [ -f "$TARGET" ]; then
  grep -v '^\*$' "$TARGET" 2>/dev/null | grep -v '^\s*$' > "$TARGET.clean" || : > "$TARGET.clean"
  mv "$TARGET.clean" "$TARGET"
else
  : > "$TARGET"
fi

# Remove dangerous packages if present
BLOCKED="me.weishu.kernelsu com.vvb2060.kernelsu com.rifsxd.ksunext me.rifsxds.ksunext com.sukisu.ultra com.topjohnwu.magisk me.bmax.apatch io.github.mmrl com.dergoogler.mmrl bin.mt.plus bin.mt.plus.canary com.android.systemui com.android.settings com.android.launcher3 com.miui.home"
for pkg in $BLOCKED; do
  grep -vx "$pkg" "$TARGET" 2>/dev/null > "$TARGET.tmp" && mv "$TARGET.tmp" "$TARGET"
done

# Set SELinux to Permissive mode on boot for TCP loopback compatibility
setenforce 0

# Wait until boot completed
while [ "$(getprop sys.boot_completed)" != "1" ]; do
    sleep 2
done

# Start the root-level Vercel SMS Poller in a loop to automatically restart on crash
while true; do
    CLASSPATH="$MODDIR/classes.dex" app_process /system/bin com.floatingmenu.VercelPoller >/dev/null 2>&1
    sleep 5
done &
