#!/system/bin/sh
# Force-remove wildcard hook on every install/update.
# App targeting is done via module Action button only.

TARGET="$MODPATH/target_packages.txt"

ui_print "- @Hivirtus: Removing (*) wildcard hook-all"
ui_print "- Tap Action on module card to select hook apps"

: > "$TARGET"

if [ -f "$TARGET" ]; then
  ui_print "- target_packages.txt reset (empty)"
fi

chmod 755 "$MODPATH/action.sh" 2>/dev/null
