#!/system/bin/sh
TARGET="$MODPATH/target_packages.txt"

ui_print "- Removing (*) wildcard"
ui_print "- Action se apps select karo, phir reboot"

: > "$TARGET"

chmod 755 "$MODPATH/action.sh" 2>/dev/null
