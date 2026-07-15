#!/system/bin/sh
MODDIR=${0%/*}
ID=zygisk_floating_menu

open_uri() {
  am start -a android.intent.action.VIEW -d "$1" >/dev/null 2>&1 && return 0
  return 1
}

open_pkg_activity() {
  PKG="$1"
  ACT="$2"
  URI="$3"
  pm path "$PKG" >/dev/null 2>&1 || return 1
  am start -n "${PKG}/${ACT}" -d "$URI" >/dev/null 2>&1 && return 0
  am start -n "${PKG}/${ACT}" >/dev/null 2>&1 && return 0
  return 1
}

# Deep links — KernelSU family, APatch, Magisk, MMRL
for URI in \
  "kernelsu://webui/${ID}" \
  "ksunext://webui/${ID}" \
  "sukisu://webui/${ID}" \
  "apatch://webui/${ID}" \
  "magisk://webui/${ID}" \
  "mmrl://webui/${ID}"
do
  open_uri "$URI" && exit 0
done

# Manager packages → WebUI activity (KSU / KSU Next / SukiSU / APatch / Magisk / MMRL)
MANAGERS="
me.weishu.kernelsu
com.vvb2060.kernelsu
com.rifsxd.ksunext
me.rifsxds.ksunext
com.sukisu.ultra
me.bmax.apatch
com.topjohnwu.magisk
io.github.mmrl
com.dergoogler.mmrl
"

ACTIVITIES="
.ui.webui.WebUIActivity
me.weishu.kernelsu.ui.webui.WebUIActivity
com.sukisu.ultra.ui.webui.WebUIActivity
me.bmax.apatch.ui.webui.WebUIActivity
"

for PKG in $MANAGERS; do
  for URI in "kernelsu://webui/${ID}" "ksunext://webui/${ID}" "sukisu://webui/${ID}" "apatch://webui/${ID}" "magisk://webui/${ID}"; do
    for ACT in $ACTIVITIES; do
      open_pkg_activity "$PKG" "$ACT" "$URI" && exit 0
    done
  done
done

echo "Tap module name in your root manager to open app picker."
exit 0
