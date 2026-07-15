#!/system/bin/sh
# Opens the module WebUI app picker @Hivirtus (works on KernelSU / Magisk)
MODDIR=${0%/*}
ID=zygisk_floating_menu

echo "@Hivirtus: Opening app selection WebUI..."

# KernelSU — open WebUI via deep link (most reliable)
if am start -a android.intent.action.VIEW -d "kernelsu://webui/${ID}" >/dev/null 2>&1; then
  echo "Opened in KernelSU Manager"
  exit 0
fi

# KernelSU — try known manager packages / activity names
for PKG in me.weishu.kernelsu com.vvb2060.kernelsu; do
  pm path "$PKG" >/dev/null 2>&1 || continue
  if am start -n "${PKG}/.ui.webui.WebUIActivity" -d "kernelsu://webui/${ID}" >/dev/null 2>&1; then
    echo "Opened WebUI via ${PKG}"
    exit 0
  fi
  if am start -n "${PKG}/me.weishu.kernelsu.ui.webui.WebUIActivity" -d "kernelsu://webui/${ID}" >/dev/null 2>&1; then
    echo "Opened WebUI via ${PKG}"
    exit 0
  fi
done

# Magisk / MMRL WebUI deep link
if am start -a android.intent.action.VIEW -d "magisk://webui/${ID}" >/dev/null 2>&1; then
  echo "Opened in Magisk/MMRL"
  exit 0
fi

# APatch WebUI
if am start -a android.intent.action.VIEW -d "apatch://webui/${ID}" >/dev/null 2>&1; then
  echo "Opened in APatch"
  exit 0
fi

echo ""
echo "WebUI auto-open failed."
echo "MANUAL: In KernelSU/Magisk, TAP THE MODULE NAME (Virtus v3 @Hivirtus) — not only Action."
echo "The app list will open inside the manager WebView."
echo ""
exit 0
