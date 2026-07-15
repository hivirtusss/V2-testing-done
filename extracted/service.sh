#!/system/bin/sh
MODDIR=${0%/*}

# Remove legacy wildcard (*) that hooks ALL apps — use ACTION tab selection instead
TARGET="$MODDIR/target_packages.txt"
if [ -f "$TARGET" ]; then
  if grep -qx '*' "$TARGET" 2>/dev/null || grep -q '^\*$' "$TARGET" 2>/dev/null; then
    grep -v '^\*$' "$TARGET" > "$TARGET.clean" 2>/dev/null || : > "$TARGET.clean"
    mv "$TARGET.clean" "$TARGET"
  fi
fi

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

