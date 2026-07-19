#!/system/bin/sh
# Early boot: keep target list strict (no wildcard = hook all apps).
MODDIR=${0%/*}
TARGET="$MODDIR/target_packages.txt"

sh "$MODDIR/refresh_pkglist.sh" "$MODDIR"

if [ ! -f "$TARGET" ]; then
  : > "$TARGET"
  exit 0
fi

# Wildcard hooks EVERY app — caused keep stopping on OnePlus / ColorOS.
if grep -q '^\*$' "$TARGET" 2>/dev/null; then
  grep -v '^\*$' "$TARGET" > "$TARGET.tmp" 2>/dev/null || : > "$TARGET.tmp"
  mv "$TARGET.tmp" "$TARGET"
fi

BLOCKED="me.weishu.kernelsu com.vvb2060.kernelsu com.rifsxd.ksunext me.rifsxds.ksunext com.sukisu.ultra com.topjohnwu.magisk me.bmax.apatch io.github.mmrl com.android.systemui com.android.settings com.android.vending com.google.android.gms com.google.android.gsf com.android.phone android"
for pkg in $BLOCKED; do
  grep -vx "$pkg" "$TARGET" > "$TARGET.tmp" 2>/dev/null && mv "$TARGET.tmp" "$TARGET"
done
