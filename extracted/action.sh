#!/system/bin/sh
# Magisk/KernelSU module Action button — open app hook picker @Hivirtus
MODDIR=${0%/*}
LOG="$MODDIR/action.log"

APP=/system/bin/app_process64
[ -x "$APP" ] || APP=/system/bin/app_process

{
  echo "=== Virtus Action $(date) ==="
  export CLASSPATH="${MODDIR}/classes.dex"
  # Run detached so Magisk UI can close while picker stays open
  nohup "$APP" /system/bin com.floatingmenu.ModuleActionPicker >> "$LOG" 2>&1 &
  echo "Started picker pid=$!"
  sleep 1
} >> "$LOG" 2>&1
