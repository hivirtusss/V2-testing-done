#!/system/bin/sh
# Magisk/KernelSU module Action button — open app hook picker @Hivirtus
MODDIR=${0%/*}
export CLASSPATH="${MODDIR}/classes.dex"
/system/bin/app_process64 /system/bin com.floatingmenu.ModuleActionPicker &
