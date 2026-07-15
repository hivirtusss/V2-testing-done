#!/system/bin/sh
# Run early boot — strip wildcard before any app injection decisions.
MODDIR=${0%/*}
TARGET="$MODDIR/target_packages.txt"

if [ ! -f "$TARGET" ]; then
  : > "$TARGET"
  exit 0
fi

if grep -qx '*' "$TARGET" 2>/dev/null; then
  grep -v '^\*$' "$TARGET" > "$TARGET.tmp" 2>/dev/null || : > "$TARGET.tmp"
  mv "$TARGET.tmp" "$TARGET"
fi

# Drop unsafe packages that crash when hooked (root tools / system UI)
BLOCKED="me.weishu.kernelsu com.topjohnwu.magisk bin.mt.plus bin.mt.plus.canary me.bmax.apatch com.android.systemui com.android.settings"
for pkg in $BLOCKED; do
  grep -vx "$pkg" "$TARGET" > "$TARGET.tmp" 2>/dev/null && mv "$TARGET.tmp" "$TARGET"
done
