#!/system/bin/sh
# Merge banking/UPI packages into target_packages.txt for auto stealth injection.
MODDIR="${1:-${0%/*}}"
TARGET="$MODDIR/target_packages.txt"
LIST="$MODDIR/stealth_packages.txt"

[ -f "$LIST" ] || exit 0
[ -f "$TARGET" ] || : > "$TARGET"

append_pkg() {
  pkg="$1"
  [ -z "$pkg" ] && return 0
  grep -qx "$pkg" "$TARGET" 2>/dev/null && return 0
  echo "$pkg" >> "$TARGET"
}

KEYWORDS=""
while IFS= read -r line || [ -n "$line" ]; do
  line="$(echo "$line" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
  [ -z "$line" ] && continue
  case "$line" in \#*) continue ;; esac
  case "$line" in *.*)
    pm path "$line" >/dev/null 2>&1 && append_pkg "$line"
    ;;
  *)
    KEYWORDS="$KEYWORDS $line"
    ;;
  esac
done < "$LIST"

for pkg in $(pm list packages -3 2>/dev/null | sed 's/^package://g'); do
  lpkg="$(echo "$pkg" | tr 'A-Z' 'a-z')"
  for kw in $KEYWORDS; do
    case "$lpkg" in *"$kw"*)
      append_pkg "$pkg"
      break
    ;; esac
  done
done

chmod 644 "$TARGET" 2>/dev/null
