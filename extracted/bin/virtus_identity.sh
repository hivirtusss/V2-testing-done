#!/system/bin/sh
# Save/load Device ID to module folder (no chmod failures)
MODDIR="/data/adb/modules/zygisk_floating_menu"
CONFIG_DIR="$MODDIR/virtus_config"
CMD="${1:-}"
PKG="${2:-}"
AID="${3:-}"

log() { echo "[virtus_identity] $*" >&2; }

safe_name() { echo "$1" | tr '.' '_'; }

ensure_dirs() {
  mkdir -p "$CONFIG_DIR" "$MODDIR/backups" "$MODDIR/bin" 2>/dev/null
  # Writable for root APK saves (ignore chmod errors on read-only module mounts)
  chmod 777 "$CONFIG_DIR" 2>/dev/null || true
  chmod 777 "$MODDIR/backups" 2>/dev/null || true
}

write_file() {
  # write_file <path> <content>
  P="$1"; V="$2"
  T="${P}.tmp.$$"
  printf '%s' "$V" > "$T" 2>/dev/null || { log "write failed: $P"; return 1; }
  cat "$T" > "$P" 2>/dev/null || cp "$T" "$P" 2>/dev/null || { rm -f "$T"; return 1; }
  rm -f "$T" 2>/dev/null
  chmod 666 "$P" 2>/dev/null || chmod 644 "$P" 2>/dev/null || true
  return 0
}

cmd_save() {
  AID="$(echo "$AID" | tr 'A-Z' 'a-z' | tr -cd '0-9a-f')"
  if [ ${#AID} -ne 16 ]; then
    log "android id must be 16 hex chars"
    exit 1
  fi
  ensure_dirs
  SAFE="$(safe_name "$PKG")"
  JSON="$CONFIG_DIR/${SAFE}.json"
  DEV="$MODDIR/device_id_${SAFE}"
  TS="$(date +%s 2>/dev/null || echo 0)"
  BODY="{\"package\":\"$PKG\",\"android_id\":\"$AID\",\"signature_spoof\":false,\"signature_sha256\":\"\",\"updated_at\":$TS}"
  write_file "$JSON" "$BODY" || exit 1
  write_file "$DEV" "$AID" || exit 1
  write_file "$MODDIR/.virtus_sync" "$TS" || true
  echo "ok"
  echo "$AID"
  exit 0
}

cmd_load() {
  SAFE="$(safe_name "$PKG")"
  JSON="$CONFIG_DIR/${SAFE}.json"
  DEV="$MODDIR/device_id_${SAFE}"
  if [ -f "$JSON" ]; then cat "$JSON"; exit 0; fi
  if [ -f "$DEV" ]; then
    A="$(cat "$DEV" 2>/dev/null)"
    echo "{\"package\":\"$PKG\",\"android_id\":\"$A\",\"signature_spoof\":false}"
    exit 0
  fi
  exit 1
}

[ -z "$PKG" ] && { log "package required"; exit 1; }

case "$CMD" in
  save) cmd_save ;;
  load) cmd_load ;;
  *) log "usage: $0 save|load <package> [android_id]"; exit 1 ;;
esac
