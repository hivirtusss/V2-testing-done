#!/system/bin/sh
ID=zygisk_floating_menu
for u in \
  "kernelsu://webui/${ID}" \
  "ksunext://webui/${ID}" \
  "sukisu://webui/${ID}" \
  "apatch://webui/${ID}" \
  "magisk://webui/${ID}" \
  "mmrl://webui/${ID}"
do
  am start -a android.intent.action.VIEW -d "$u" -f 0x10000000 >/dev/null 2>&1 && exit 0
done
exit 0
