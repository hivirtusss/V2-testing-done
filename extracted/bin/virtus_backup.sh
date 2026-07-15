#!/system/bin/sh
# Virtus backup — device ID + app data + APK (MT Manager compatible)
MODDIR="/data/adb/modules/zygisk_floating_menu"
BACKUP_ROOT="$MODDIR/backups"
CONFIG_DIR="$MODDIR/virtus_config"
MT_ROOT="/storage/emulated/0/MT2/Backup"
CMD="${1:-}"
PKG="${2:-}"
ARG3="${3:-}"
ARG4="${4:-}"

log() { echo "[virtus_backup] $*" >&2; }

identity_file() {
  echo "$CONFIG_DIR/$(echo "$PKG" | tr '.' '_').json"
}

find_app_data() {
  for base in /data/user/0 /data/user/10 /data/data; do
    [ -d "$base/$PKG" ] && echo "$base/$PKG" && return 0
  done
  return 1
}

copy_apk() {
  DEST="$1"
  APK_PATH="$(pm path "$PKG" 2>/dev/null | head -1 | sed 's/^package://')"
  [ -n "$APK_PATH" ] && [ -f "$APK_PATH" ] || return 1
  cp "$APK_PATH" "$DEST/base.apk" 2>/dev/null || cp "$APK_PATH" "$DEST/${PKG}.apk" 2>/dev/null
}

save_meta() {
  DEST="$1"
  NOTE="$2"
  printf '%s' "$NOTE" > "$DEST/note.txt"
  date '+%Y-%m-%d %H:%M:%S' > "$DEST/created.txt"
  du -sh "$DEST" 2>/dev/null | awk '{print $1}' > "$DEST/size.txt"
  VER="$(dumpsys package "$PKG" 2>/dev/null | awk -F= '/versionName=/{print $2; exit}')"
  CODE="$(dumpsys package "$PKG" 2>/dev/null | awk -F= '/versionCode=/{print $2; exit}')"
  echo "${VER:-unknown}" > "$DEST/version.txt"
  echo "${CODE:-0}" > "$DEST/version_code.txt"
}

save_identity() {
  DEST="$1"
  IDFILE="$(identity_file)"
  if [ -f "$IDFILE" ]; then
    cp "$IDFILE" "$DEST/identity.json"
  else
    echo "{\"package\":\"$PKG\",\"android_id\":\"\",\"signature_spoof\":false}" > "$DEST/identity.json"
  fi
}

restore_identity() {
  SRC="$BACKUP_ROOT/$PKG/$1/identity.json"
  IDFILE="$(identity_file)"
  [ -f "$SRC" ] || return 0
  mkdir -p "$CONFIG_DIR"
  cp "$SRC" "$IDFILE"
  chmod 644 "$IDFILE" 2>/dev/null
  date +%s > "$MODDIR/.virtus_sync" 2>/dev/null
}

fix_data_owner() {
  DEST="$1"
  UID="$(dumpsys package "$PKG" 2>/dev/null | awk '/userId=/{print $1; exit}' | sed 's/userId=//')"
  [ -n "$UID" ] || return 0
  chown -R "$UID:$UID" "$DEST" 2>/dev/null
  chmod -R u+rwX "$DEST" 2>/dev/null
}

cmd_create() {
  NOTE="$ARG3"
  SRC="$(find_app_data)" || { log "app data not found: $PKG"; exit 1; }
  mkdir -p "$BACKUP_ROOT/$PKG" "$CONFIG_DIR" 2>/dev/null
  ID="$(date +%Y%m%d_%H%M%S)_$$"
  DEST="$BACKUP_ROOT/$PKG/$ID"
  mkdir -p "$DEST/data" || exit 1
  cp -a "$SRC/." "$DEST/data/" || exit 1
  copy_apk "$DEST" || log "apk copy skipped"
  save_identity "$DEST"
  save_meta "$DEST" "$NOTE"
  chmod -R 755 "$DEST" 2>/dev/null
  echo "$ID"
  exit 0
}

cmd_list() {
  BASE="$BACKUP_ROOT/$PKG"
  [ -d "$BASE" ] || exit 0
  for d in "$BASE"/*; do
    [ -d "$d" ] || continue
    ID="$(basename "$d")"
    CREATED="$(cat "$d/created.txt" 2>/dev/null)"
    NOTE="$(cat "$d/note.txt" 2>/dev/null | tr '\n' ' ')"
    SIZE="$(cat "$d/size.txt" 2>/dev/null)"
    MT="0"
    [ -f "$d/base.apk" ] || [ -f "$d/${PKG}.apk" ] && MT="1"
    AID=""
    [ -f "$d/identity.json" ] && AID="$(grep -o '"android_id"[[:space:]]*:[[:space:]]*"[^"]*"' "$d/identity.json" 2>/dev/null | head -1 | sed 's/.*"\([^"]*\)"$/\1/')"
    echo "$ID|$CREATED|$NOTE|$SIZE|$MT|$AID"
  done
  exit 0
}

cmd_restore() {
  ID="$ARG3"
  SRC="$BACKUP_ROOT/$PKG/$ID/data"
  [ -d "$SRC" ] || { log "backup not found"; exit 1; }
  DEST="$(find_app_data)" || { log "app data dir missing — open app once"; exit 1; }
  am force-stop "$PKG" 2>/dev/null
  pm clear "$PKG" >/dev/null 2>&1 || true
  sleep 1
  mkdir -p "$DEST"
  rm -rf "$DEST"/* 2>/dev/null
  cp -a "$SRC/." "$DEST/" || exit 1
  fix_data_owner "$DEST"
  restore_identity "$ID"
  echo "restored"
  exit 0
}

cmd_delete() {
  ID="$ARG3"
  rm -rf "$BACKUP_ROOT/$PKG/$ID"
  rm -rf "$MT_ROOT/${PKG}_virtus_${ID}" 2>/dev/null
  echo "deleted"
  exit 0
}

cmd_set_note() {
  ID="$ARG3"
  NOTE="$ARG4"
  DEST="$BACKUP_ROOT/$PKG/$ID"
  [ -d "$DEST" ] || { log "backup not found"; exit 1; }
  printf '%s' "$NOTE" > "$DEST/note.txt"
  echo "ok"
  exit 0
}

cmd_reset() {
  am force-stop "$PKG" 2>/dev/null
  pm clear "$PKG" >/dev/null 2>&1
  echo "reset"
  exit 0
}

cmd_export_mt() {
  ID="$ARG3"
  SRC="$BACKUP_ROOT/$PKG/$ID"
  [ -d "$SRC/data" ] || { log "backup missing"; exit 1; }
  VER="$(cat "$SRC/version.txt" 2>/dev/null)"
  [ -z "$VER" ] && VER="unknown"
  MT_NAME="${PKG}_${VER}_virtus_${ID}"
  DEST="$MT_ROOT/$MT_NAME"
  mkdir -p "$DEST" "$MT_ROOT" 2>/dev/null || { log "cannot create MT2/Backup"; exit 1; }
  rm -rf "$DEST"
  mkdir -p "$DEST/data"
  if [ -f "$SRC/base.apk" ]; then
    cp "$SRC/base.apk" "$DEST/base.apk"
  elif [ -f "$SRC/${PKG}.apk" ]; then
    cp "$SRC/${PKG}.apk" "$DEST/${PKG}.apk"
  else
    copy_apk "$DEST" || log "warning: no apk"
  fi
  cp -a "$SRC/data/." "$DEST/data/" || exit 1
  cp "$SRC/note.txt" "$DEST/note.txt" 2>/dev/null
  cp "$SRC/identity.json" "$DEST/identity.json" 2>/dev/null
  echo "$DEST"
  exit 0
}

[ -z "$PKG" ] && { log "package required"; exit 1; }
mkdir -p "$BACKUP_ROOT" "$CONFIG_DIR"

case "$CMD" in
  create) cmd_create ;;
  list) cmd_list ;;
  restore) cmd_restore ;;
  delete) cmd_delete ;;
  set_note) cmd_set_note ;;
  reset) cmd_reset ;;
  export_mt) cmd_export_mt ;;
  *) log "usage: $0 create|list|restore|delete|set_note|reset|export_mt <pkg> [note|id] [note]"; exit 1 ;;
esac
