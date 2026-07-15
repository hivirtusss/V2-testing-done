#!/system/bin/sh
# Virtus backup — MT Manager folder (MT2/Backup) + Device ID
MODDIR="/data/adb/modules/zygisk_floating_menu"
CONFIG_DIR="$MODDIR/virtus_config"
MT_ROOT="/storage/emulated/0/MT2/Backup"
CMD="${1:-}"
PKG="${2:-}"
ARG3="${3:-}"
ARG4="${4:-}"

log() { echo "[virtus_backup] $*" >&2; }

pkg_installed() {
  pm path "$PKG" >/dev/null 2>&1
}

identity_file() {
  echo "$CONFIG_DIR/$(echo "$PKG" | tr '.' '_').json"
}

device_id_file() {
  echo "$MODDIR/device_id_$(echo "$PKG" | tr '.' '_')"
}

read_data_dir() {
  dumpsys package "$PKG" 2>/dev/null | grep -m1 'dataDir=' | sed 's/.*dataDir=//; s/ .*//; s/\r//'
}

wake_app_data() {
  am force-stop "$PKG" 2>/dev/null
  monkey -p "$PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1 \
    || am start -n "$(cmd package resolve-activity --brief "$PKG" 2>/dev/null | tail -1)" >/dev/null 2>&1 \
    || am start -a android.intent.action.MAIN -c android.intent.category.LAUNCHER "$PKG" >/dev/null 2>&1
  sleep 2
}

find_app_data() {
  if ! pkg_installed; then
    log "app not installed: $PKG"
    return 1
  fi

  DATA_DIR="$(read_data_dir)"
  if [ -n "$DATA_DIR" ] && [ -d "$DATA_DIR" ]; then
    echo "$DATA_DIR"
    return 0
  fi

  for base in /data/user/0 /data/user/10 /data/user/999 /data/user_de/0 /data/data; do
    if [ -d "$base/$PKG" ]; then
      echo "$base/$PKG"
      return 0
    fi
  done

  if [ -n "$DATA_DIR" ]; then
    wake_app_data
    [ -d "$DATA_DIR" ] && echo "$DATA_DIR" && return 0
  fi

  wake_app_data
  for base in /data/user/0 /data/user/10 /data/user_de/0 /data/data; do
    if [ -d "$base/$PKG" ]; then
      echo "$base/$PKG"
      return 0
    fi
  done

  DATA_DIR="$(read_data_dir)"
  if [ -n "$DATA_DIR" ]; then
    mkdir -p "$DATA_DIR" 2>/dev/null
    wake_app_data
    [ -d "$DATA_DIR" ] && echo "$DATA_DIR" && return 0
  fi

  return 1
}

find_backup_dir() {
  BID="$1"
  for d in "$MT_ROOT"/${PKG}_*virtus_${BID} "$MT_ROOT"/${PKG}_*_${BID}; do
    [ -d "$d/data" ] && echo "$d" && return 0
  done
  [ -d "$MT_ROOT/$BID/data" ] && echo "$MT_ROOT/$BID" && return 0
  return 1
}

copy_apk() {
  DEST="$1"
  APK_PATH="$(pm path "$PKG" 2>/dev/null | head -1 | sed 's/^package://')"
  [ -n "$APK_PATH" ] && [ -f "$APK_PATH" ] && cp "$APK_PATH" "$DEST/base.apk" 2>/dev/null
}

save_meta() {
  DEST="$1"
  NOTE="$2"
  printf '%s' "$NOTE" > "$DEST/note.txt"
  date '+%Y-%m-%d %H:%M:%S' > "$DEST/created.txt"
  du -sh "$DEST" 2>/dev/null | awk '{print $1}' > "$DEST/size.txt"
  VER="$(dumpsys package "$PKG" 2>/dev/null | awk -F= '/versionName=/{print $2; exit}' | tr -d "'")"
  CODE="$(dumpsys package "$PKG" 2>/dev/null | awk -F= '/versionCode=/{print $2; exit}')"
  echo "${VER:-unknown}" > "$DEST/version.txt"
  echo "${CODE:-0}" > "$DEST/version_code.txt"
  echo "$PKG" > "$DEST/package.txt"
}

apply_runtime_id() {
  AID="$(echo "$1" | tr 'A-Z' 'a-z' | tr -cd '0-9a-f')"
  [ ${#AID} -ne 16 ] && return 0
  DEVFILE="$(device_id_file)"
  printf '%s' "$AID" > "$DEVFILE"
  printf '%s' "$AID" > "$MODDIR/device_id"
  chmod 644 "$DEVFILE" "$MODDIR/device_id" 2>/dev/null
  mkdir -p "$CONFIG_DIR"
  printf '{"package":"%s","android_id":"%s","signature_spoof":false}' "$PKG" "$AID" > "$(identity_file)"
  chmod 644 "$(identity_file)" 2>/dev/null
  date +%s > "$MODDIR/.virtus_sync" 2>/dev/null || true
}

save_identity() {
  DEST="$1"
  AID="$2"
  IDFILE="$(identity_file)"
  DEVFILE="$(device_id_file)"
  if [ -n "$AID" ]; then
    apply_runtime_id "$AID"
  fi
  if [ -f "$IDFILE" ]; then
    cp "$IDFILE" "$DEST/identity.json"
  else
    echo "{\"package\":\"$PKG\",\"android_id\":\"\",\"signature_spoof\":false}" > "$DEST/identity.json"
  fi
  AID="$(grep -o '"android_id"[[:space:]]*:[[:space:]]*"[^"]*"' "$DEST/identity.json" 2>/dev/null | head -1 | sed 's/.*"\([^"]*\)"$/\1/')"
  if [ -n "$AID" ]; then
    printf '%s' "$AID" > "$DEST/device_id.txt"
    apply_runtime_id "$AID"
  elif [ -f "$DEVFILE" ]; then
    cp "$DEVFILE" "$DEST/device_id.txt"
  fi
}

restore_identity() {
  SRC="$1"
  IDFILE="$(identity_file)"
  if [ -f "$SRC/identity.json" ]; then
    mkdir -p "$CONFIG_DIR"
    cp "$SRC/identity.json" "$IDFILE"
    chmod 644 "$IDFILE" 2>/dev/null
  fi
  if [ -f "$SRC/device_id.txt" ]; then
    apply_runtime_id "$(cat "$SRC/device_id.txt" 2>/dev/null)"
  fi
}

fix_data_owner() {
  DEST="$1"
  UID="$(dumpsys package "$PKG" 2>/dev/null | awk '/userId=/{print $1; exit}' | sed 's/userId=//')"
  [ -n "$UID" ] || return 0
  chown -R "$UID:$UID" "$DEST" 2>/dev/null
  restorecon -R "$DEST" 2>/dev/null
  chmod -R u+rwX "$DEST" 2>/dev/null
}

cmd_create() {
  NOTE="$ARG3"
  AID="$ARG4"
  am force-stop "$PKG" 2>/dev/null
  sync
  sleep 1
  SRC="$(find_app_data)" || {
    log "app data not found — open app, login, force-stop, retry"
    exit 1
  }
  mkdir -p "$MT_ROOT" "$CONFIG_DIR" 2>/dev/null || {
    log "cannot create $MT_ROOT — grant storage to root/shell"
    exit 1
  }
  ID="$(date +%Y%m%d_%H%M%S)_$$"
  VER="$(dumpsys package "$PKG" 2>/dev/null | awk -F= '/versionName=/{print $2; exit}' | tr -d "'")"
  [ -z "$VER" ] && VER="unknown"
  MT_NAME="${PKG}_${VER}_virtus_${ID}"
  DEST="$MT_ROOT/$MT_NAME"
  mkdir -p "$DEST/data" || exit 1
  cp -a "$SRC/." "$DEST/data/" || { log "copy failed from $SRC"; rm -rf "$DEST"; exit 1; }
  copy_apk "$DEST" || log "apk copy skipped"
  save_identity "$DEST" "$AID"
  save_meta "$DEST" "$NOTE"
  chmod -R 755 "$DEST" 2>/dev/null
  log "saved to $DEST"
  echo "$ID"
  exit 0
}

cmd_list() {
  mkdir -p "$MT_ROOT" 2>/dev/null
  for d in "$MT_ROOT"/${PKG}_*; do
    [ -d "$d/data" ] || continue
    BASE="$(basename "$d")"
    ID="${BASE##*virtus_}"
    [ "$ID" = "$BASE" ] && ID="$BASE"
    CREATED="$(cat "$d/created.txt" 2>/dev/null)"
    NOTE="$(cat "$d/note.txt" 2>/dev/null | tr '\n' ' ')"
    SIZE="$(cat "$d/size.txt" 2>/dev/null)"
    MT="1"
    AID=""
    [ -f "$d/device_id.txt" ] && AID="$(cat "$d/device_id.txt" 2>/dev/null)"
    [ -z "$AID" ] && [ -f "$d/identity.json" ] && AID="$(grep -o '"android_id"[[:space:]]*:[[:space:]]*"[^"]*"' "$d/identity.json" 2>/dev/null | head -1 | sed 's/.*"\([^"]*\)"$/\1/')"
    FC="$(find "$d/data" -type f 2>/dev/null | wc -l)"
    echo "$ID|$CREATED|$NOTE|$SIZE|$MT|$AID|$FC"
  done
  exit 0
}

cmd_restore() {
  ID="$ARG3"
  ARCH="$(find_backup_dir "$ID")"
  [ -n "$ARCH" ] || { log "backup not found: $ID"; exit 1; }
  SRC="$ARCH/data"
  [ -d "$SRC" ] || { log "backup data missing"; exit 1; }
  if ! pkg_installed; then
    log "install app first: $PKG"
    exit 1
  fi
  am force-stop "$PKG" 2>/dev/null
  pm clear "$PKG" >/dev/null 2>&1 || true
  sleep 1
  DEST="$(read_data_dir)"
  [ -z "$DEST" ] && DEST="/data/user/0/$PKG"
  mkdir -p "$DEST"
  rm -rf "$DEST"/* 2>/dev/null
  cp -a "$SRC/." "$DEST/" || { log "restore copy failed"; exit 1; }
  fix_data_owner "$DEST"
  restore_identity "$ARCH"
  echo "restored"
  exit 0
}

cmd_delete() {
  ID="$ARG3"
  ARCH="$(find_backup_dir "$ID")"
  [ -n "$ARCH" ] && rm -rf "$ARCH"
  echo "deleted"
  exit 0
}

cmd_set_note() {
  ID="$ARG3"
  NOTE="$ARG4"
  ARCH="$(find_backup_dir "$ID")"
  [ -n "$ARCH" ] || { log "backup not found"; exit 1; }
  printf '%s' "$NOTE" > "$ARCH/note.txt"
  echo "ok"
  exit 0
}

cmd_reset() {
  am force-stop "$PKG" 2>/dev/null
  pm clear "$PKG" >/dev/null 2>&1
  echo "reset"
  exit 0
}

cmd_check() {
  if ! pkg_installed; then
    echo "not_installed"
    exit 1
  fi
  SRC="$(find_app_data)" && echo "ok:$SRC" || echo "no_data"
  exit 0
}

cmd_save_id() {
  AID="$(echo "$ARG3" | tr 'A-Z' 'a-z' | tr -cd '0-9a-f')"
  [ ${#AID} -ne 16 ] && { log "need 16 hex android id"; exit 1; }
  apply_runtime_id "$AID"
  echo "ok"
  exit 0
}

[ -z "$PKG" ] && { log "package required"; exit 1; }
mkdir -p "$CONFIG_DIR" "$MODDIR/bin" "$MT_ROOT" 2>/dev/null

case "$CMD" in
  create) cmd_create ;;
  list) cmd_list ;;
  restore) cmd_restore ;;
  delete) cmd_delete ;;
  set_note) cmd_set_note ;;
  reset) cmd_reset ;;
  check) cmd_check ;;
  save_id) cmd_save_id ;;
  *) log "usage: create|list|restore|delete|set_note|reset|check|save_id <pkg> ..."; exit 1 ;;
esac
