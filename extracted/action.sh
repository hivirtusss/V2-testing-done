#!/system/bin/sh
ID=zygisk_floating_menu
URI="ksu://webui?id=${ID}"

open_webui() {
  PKG="$1"
  ACT="$2"
  am start -n "${PKG}/${ACT}" -a android.intent.action.VIEW -d "${URI}" --activity-new-task >/dev/null 2>&1
}

if pm path com.sukisu.ultra >/dev/null 2>&1; then
  open_webui com.sukisu.ultra com.sukisu.ultra.ui.webui.WebUIActivity
  exit 0
fi
if pm path me.weishu.kernelsu >/dev/null 2>&1; then
  open_webui me.weishu.kernelsu me.weishu.kernelsu.ui.webui.WebUIActivity
  exit 0
fi
if pm path com.vvb2060.kernelsu >/dev/null 2>&1; then
  open_webui com.vvb2060.kernelsu com.vvb2060.kernelsu.ui.webui.WebUIActivity
  exit 0
fi
if pm path com.rifsxd.ksunext >/dev/null 2>&1 || pm path me.rifsxds.ksunext >/dev/null 2>&1; then
  PKG=$(pm path com.rifsxd.ksunext 2>/dev/null | head -1 | cut -d: -f2 | cut -d/ -f1)
  [ -z "$PKG" ] && PKG=$(pm path me.rifsxds.ksunext 2>/dev/null | head -1 | cut -d: -f2 | cut -d/ -f1)
  open_webui "$PKG" "${PKG}.ui.webui.WebUIActivity"
  exit 0
fi
if pm path me.bmax.apatch >/dev/null 2>&1; then
  am start -a android.intent.action.VIEW -d "apatch://webui?id=${ID}" --activity-new-task >/dev/null 2>&1
  exit 0
fi
if pm path com.topjohnwu.magisk >/dev/null 2>&1; then
  am start -a android.intent.action.VIEW -d "magisk://webui?id=${ID}" --activity-new-task >/dev/null 2>&1
  exit 0
fi
if pm path io.github.mmrl >/dev/null 2>&1; then
  am start -n io.github.mmrl/.ui.activity.webui.WebUIActivity -e MOD_ID "${ID}" --activity-new-task >/dev/null 2>&1
  exit 0
fi
if pm path com.dergoogler.mmrl >/dev/null 2>&1; then
  am start -n com.dergoogler.mmrl/.ui.activity.webui.WebUIActivity -e MOD_ID "${ID}" --activity-new-task >/dev/null 2>&1
  exit 0
fi

exit 0
