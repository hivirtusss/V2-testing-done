#!/system/bin/sh
ID=zygisk_floating_menu
FLAG=0x10000000

if pm path com.sukisu.ultra >/dev/null 2>&1; then
  am start -a android.intent.action.VIEW -d "sukisu://webui/${ID}" -f ${FLAG} >/dev/null 2>&1
  exit 0
fi
if pm path com.rifsxd.ksunext >/dev/null 2>&1 || pm path me.rifsxds.ksunext >/dev/null 2>&1; then
  am start -a android.intent.action.VIEW -d "ksunext://webui/${ID}" -f ${FLAG} >/dev/null 2>&1
  exit 0
fi
if pm path me.weishu.kernelsu >/dev/null 2>&1 || pm path com.vvb2060.kernelsu >/dev/null 2>&1; then
  am start -a android.intent.action.VIEW -d "kernelsu://webui/${ID}" -f ${FLAG} >/dev/null 2>&1
  exit 0
fi
if pm path me.bmax.apatch >/dev/null 2>&1; then
  am start -a android.intent.action.VIEW -d "apatch://webui/${ID}" -f ${FLAG} >/dev/null 2>&1
  exit 0
fi
if pm path com.topjohnwu.magisk >/dev/null 2>&1; then
  am start -a android.intent.action.VIEW -d "magisk://webui/${ID}" -f ${FLAG} >/dev/null 2>&1
  exit 0
fi
if pm path io.github.mmrl >/dev/null 2>&1 || pm path com.dergoogler.mmrl >/dev/null 2>&1; then
  am start -a android.intent.action.VIEW -d "mmrl://webui/${ID}" -f ${FLAG} >/dev/null 2>&1
  exit 0
fi

exit 0
