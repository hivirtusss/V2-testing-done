#!/system/bin/sh
ID=zygisk_floating_menu

echo "Virtus V3: opening app picker WebUI..."

launch() {
  # Show errors in Action screen if launch fails
  am start --user 0 "$@" 2>&1
}

# SukiSU Ultra — module id MUST be in URI ?id=
if pm path com.sukisu.ultra >/dev/null 2>&1; then
  launch -a android.intent.action.VIEW \
    -d "ksu://webui?id=${ID}" \
    -n com.sukisu.ultra/com.sukisu.ultra.ui.webui.WebUIActivity && exit 0
  launch -a android.intent.action.VIEW -d "ksu://webui?id=${ID}" && exit 0
fi

# KernelSU
if pm path me.weishu.kernelsu >/dev/null 2>&1; then
  launch -a android.intent.action.VIEW \
    -d "ksu://webui?id=${ID}" \
    -n me.weishu.kernelsu/me.weishu.kernelsu.ui.webui.WebUIActivity && exit 0
fi
if pm path com.vvb2060.kernelsu >/dev/null 2>&1; then
  launch -a android.intent.action.VIEW \
    -d "ksu://webui?id=${ID}" \
    -n com.vvb2060.kernelsu/com.vvb2060.kernelsu.ui.webui.WebUIActivity && exit 0
fi

# KSU Next
if pm path com.rifsxd.ksunext >/dev/null 2>&1 || pm path me.rifsxds.ksunext >/dev/null 2>&1; then
  PKG=$(pm path com.rifsxd.ksunext 2>/dev/null | head -1 | cut -d: -f2 | cut -d/ -f1)
  [ -z "$PKG" ] && PKG=$(pm path me.rifsxds.ksunext 2>/dev/null | head -1 | cut -d: -f2 | cut -d/ -f1)
  launch -a android.intent.action.VIEW \
    -d "ksu://webui?id=${ID}" \
    -n "${PKG}/${PKG}.ui.webui.WebUIActivity" && exit 0
fi

# KsuWebUI Standalone (works when manager Action fails)
if pm path io.github.a13e300.ksuwebui >/dev/null 2>&1; then
  launch -n io.github.a13e300.ksuwebui/.WebUIActivity -e id "${ID}" && exit 0
fi

# MMRL / WebUI X
for PKG in com.dergoogler.mmrl.wx com.dergoogler.mmrl io.github.mmrl; do
  pm path "$PKG" >/dev/null 2>&1 || continue
  launch -n "${PKG}/.ui.activity.webui.WebUIActivity" -e MOD_ID "${ID}" && exit 0
done

# APatch / Magisk deep links
if pm path me.bmax.apatch >/dev/null 2>&1; then
  launch -a android.intent.action.VIEW -d "apatch://webui?id=${ID}" && exit 0
fi
if pm path com.topjohnwu.magisk >/dev/null 2>&1; then
  launch -a android.intent.action.VIEW -d "magisk://webui?id=${ID}" && exit 0
fi

echo ""
echo "Could not open WebUI automatically."
echo "Try: tap the WebUI button on this module page (not Action),"
echo "or install KsuWebUI Standalone from GitHub (KOWX712/KsuWebUIStandalone)."
exit 1
