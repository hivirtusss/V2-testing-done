#!/system/bin/sh
ui_print "================================"
ui_print " Virtus Emergency Uninstall"
ui_print "================================"
ui_print "- Deleting zygisk_floating_menu..."
rm -rf /data/adb/modules/zygisk_floating_menu
rm -rf /data/adb/modules/zygisk_floating_menu.disabled
ui_print "- Module removed."
ui_print "- REBOOT your phone now!"
ui_print "================================"
