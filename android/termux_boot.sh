#!/data/data/com.termux/files/usr/bin/bash
# Place in ~/.termux/boot/ for auto-start on phone reboot.
# Requires: Termux:Boot app from F-Droid

sleep 30
bash "${HOME}/sms_monitor/sms_daemon.sh" start >> "${HOME}/.sms_monitor.log" 2>&1 &
