#!/system/bin/sh
# Device ID inject — runtime sync + clear data (Android Faker style)
MODDIR="/data/adb/modules/zygisk_floating_menu"
CONFIG_DIR="$MODDIR/virtus_config"
BACKUP_ROOT="$MODDIR/backups"
CMD="${1:-}"
PKG="${2:-}"
AID="${3:-}"

log() { echo "[virtus_identity] $*" >&2; }

safe_name() { echo "$1" | tr '.' '_'; }

ensure_dirs() {
  mkdir -p "$CONFIG_DIR" "$MODDIR/backups" "$MODDIR/bin" 2>/dev/null
  chmod 777 "$CONFIG_DIR" 2>/dev/null || true
  chmod 777 "$MODDIR/backups" 2>/dev/null || true
}

write_json() {
  P="$1"; BODY="$2"
  T="${P}.tmp.$$"
  printf '%s' "$BODY" > "$T" 2>/dev/null || return 1
  cat "$T" > "$P" 2>/dev/null || cp "$T" "$P" 2>/dev/null || { rm -f "$T"; return 1; }
  rm -f "$T" 2>/dev/null
  chmod 666 "$P" 2>/dev/null || chmod 644 "$P" 2>/dev/null || true
  return 0
}

normalize_id() {
  echo "$1" | tr 'A-Z' 'a-z' | tr -cd '0-9a-f'
}

cmd_save() {
  AID="$(normalize_id "$AID")"
  if [ ${#AID} -ne 16 ]; then
    log "android id must be 16 hex chars"
    exit 1
  fi
  ensure_dirs
  SAFE="$(safe_name "$PKG")"
  JSON="$CONFIG_DIR/${SAFE}.json"
  TS="$(date +%s 2>/dev/null || echo 0)"
  BODY="{\"package\":\"$PKG\",\"android_id\":\"$AID\",\"signature_spoof\":false,\"signature_sha256\":\"\",\"updated_at\":$TS}"
  write_json "$JSON" "$BODY" || exit 1
  rm -f "$MODDIR/device_id_${SAFE}" 2>/dev/null
  write_json "$MODDIR/.virtus_sync" "$TS" || true
  echo "ok"
  echo "$AID"
  exit 0
}

cmd_inject() {
  AID="$(normalize_id "$AID")"
  if [ ${#AID} -ne 16 ]; then
    log "android id must be 16 hex chars"
    exit 1
  fi
  ensure_dirs
  am force-stop "$PKG" 2>/dev/null
  pm clear "$PKG" >/dev/null 2>&1
  sleep 2
  cmd_save
}

cmd_load() {
  SAFE="$(safe_name "$PKG")"
  JSON="$CONFIG_DIR/${SAFE}.json"
  if [ -f "$JSON" ]; then cat "$JSON"; exit 0; fi
  BASE="$BACKUP_ROOT/$PKG"
  if [ -d "$BASE" ]; then
    LATEST="$(ls -1t "$BASE" 2>/dev/null | head -1)"
    if [ -n "$LATEST" ] && [ -f "$BASE/$LATEST/identity.json" ]; then
      cat "$BASE/$LATEST/identity.json"
      exit 0
    fi
    if [ -n "$LATEST" ] && [ -f "$BASE/$LATEST/device_id.txt" ]; then
      A="$(cat "$BASE/$LATEST/device_id.txt" 2>/dev/null)"
      echo "{\"package\":\"$PKG\",\"android_id\":\"$A\",\"signature_spoof\":false}"
      exit 0
    fi
  fi
  exit 1
}

[ -z "$PKG" ] && { log "package required"; exit 1; }

case "$CMD" in
  save) cmd_save ;;
  inject) cmd_inject ;;
  load) cmd_load ;;
  *) log "usage: $0 save|inject|load <package> [android_id]"; exit 1 ;;
esac
