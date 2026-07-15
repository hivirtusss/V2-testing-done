#!/system/bin/sh
MODDIR=${0%/*}

setenforce 0

while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 2
done

while true; do
  CLASSPATH="$MODDIR/classes.dex" app_process /system/bin com.floatingmenu.VercelPoller >/dev/null 2>&1
  sleep 5
done &
