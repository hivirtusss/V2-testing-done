#!/system/bin/sh
# Virtus backup v4 — silent backup, Device ID stored in backup folder only
MODDIR="/data/adb/modules/zygisk_floating_menu"
BACKUP_ROOT="$MODDIR/backups"
CONFIG_DIR="$MODDIR/virtus_config"
MT_ROOT="/storage/emulated/0/MT2/Backup"
CMD="${1:-}"
PKG="${2:-}"
ARG3="${3:-}"
ARG4="${4:-}"

log() { echo "[virtus_backup] $*" >&2; }

pkg_installed() {
  pm path "$PKG" >/dev/null 2>&1 && return 0
  pm list packages "$PKG" 2>/dev/null | grep -qx "package:$PKG" && return 0
  cmd package list packages --user 0 "$PKG" 2>/dev/null | grep -qx "package:$PKG" && return 0
  return 1
}

read_data_dir() {
  dumpsys package "$PKG" 2>/dev/null | while IFS= read -r line; do
    case "$line" in
      *dataDir=*)
        D="${line#*dataDir=}"
        D="${D%% *}"
        [ -n "$D" ] && [ -d "$D" ] && echo "$D" && exit 0
        ;;
    esac
  done
}

find_app_data() {
  if ! pkg_installed; then
    log "not installed: $PKG"
    return 1
  fi
  D="$(read_data_dir | head -1)"
  if [ -n "$D" ] && [ -d "$D" ]; then echo "$D"; return 0; fi
  for b in /data/user/0 /data/user/10 /data/user/999 /data/user_de/0 /data/data; do
    [ -d "$b/$PKG" ] && echo "$b/$PKG" && return 0
  done
  for udir in /data/user/*/"$PKG" /data/user_de/*/"$PKG"; do
    [ -d "$udir" ] && echo "$udir" && return 0
  done
  find /data/user /data/user_de -maxdepth 2 -type d -name "$PKG" 2>/dev/null | head -1
}

count_files() { find "$1" -type f 2>/dev/null | wc -l; }

sdcard_app_dir() {
  for p in "/storage/emulated/0/Android/data/$PKG" "/sdcard/Android/data/$PKG"; do
    [ -d "$p" ] && echo "$p" && return 0
  done
  return 1
}

copy_apk() {
  DEST="$1"
  APK="$(pm path "$PKG" 2>/dev/null | head -1 | sed 's/^package://')"
  [ -n "$APK" ] && [ -f "$APK" ] && cp "$APK" "$DEST/base.apk" 2>/dev/null
}

sync_runtime_identity() {
  AID="$1"
  [ -z "$AID" ] && return 0
  mkdir -p "$CONFIG_DIR"
  SAFE="$(echo "$PKG" | tr '.' '_')"
  printf '{"package":"%s","android_id":"%s","signature_spoof":false,"updated_at":%s}\n' \
    "$PKG" "$AID" "$(date +%s 2>/dev/null || echo 0)" > "$CONFIG_DIR/${SAFE}.json"
  chmod 666 "$CONFIG_DIR/${SAFE}.json" 2>/dev/null || chmod 644 "$CONFIG_DIR/${SAFE}.json" 2>/dev/null || true
  date +%s > "$MODDIR/.virtus_sync" 2>/dev/null || true
}

save_meta() {
  DEST="$1"; NOTE="$2"
  printf '%s' "$NOTE" > "$DEST/note.txt"
  date '+%Y-%m-%d %H:%M:%S' > "$DEST/created.txt"
  FC="$(count_files "$DEST/data")"
  echo "$FC" > "$DEST/files_count.txt"
  du -sh "$DEST" 2>/dev/null | awk '{print $1}' > "$DEST/size.txt"
  dumpsys package "$PKG" 2>/dev/null | awk -F= '/versionName=/{print $2; exit}' > "$DEST/version.txt"
  dumpsys package "$PKG" 2>/dev/null | awk -F= '/versionCode=/{print $2; exit}' > "$DEST/version_code.txt"
  echo "$PKG" > "$DEST/package.txt"
}

save_identity_to_backup() {
  DEST="$1"
  AID="$2"
  if [ -z "$AID" ]; then
    AID="$(grep -o '"android_id"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_DIR/$(echo "$PKG" | tr '.' '_').json" 2>/dev/null \
      | sed 's/.*"\([^"]*\)"$/\1/')"
  fi
  AID="$(echo "$AID" | tr 'A-Z' 'a-z' | tr -cd '0-9a-f')"
  if [ ${#AID} -ne 16 ]; then
    echo "{\"package\":\"$PKG\",\"android_id\":\"\"}" > "$DEST/identity.json"
    return 0
  fi
  TS="$(date +%s 2>/dev/null || echo 0)"
  printf '{"package":"%s","android_id":"%s","signature_spoof":false,"updated_at":%s}\n' \
    "$PKG" "$AID" "$TS" > "$DEST/identity.json"
  printf '%s' "$AID" > "$DEST/device_id.txt"
  sync_runtime_identity "$AID"
}

restore_identity() {
  BID="$1"
  SRC="$BACKUP_ROOT/$PKG/$BID"
  mkdir -p "$CONFIG_DIR"
  if [ -f "$SRC/identity.json" ]; then
    cp "$SRC/identity.json" "$CONFIG_DIR/$(echo "$PKG" | tr '.' '_').json"
    chmod 666 "$CONFIG_DIR/$(echo "$PKG" | tr '.' '_').json" 2>/dev/null || true
  elif [ -f "$SRC/device_id.txt" ]; then
    AID="$(cat "$SRC/device_id.txt" 2>/dev/null)"
    sync_runtime_identity "$AID"
  fi
  rm -f "$MODDIR/device_id_$(echo "$PKG" | tr '.' '_')" 2>/dev/null
  date +%s > "$MODDIR/.virtus_sync" 2>/dev/null || true
}

fix_owner() {
  D="$1"
  UID="$(dumpsys package "$PKG" 2>/dev/null | awk '/userId=/{print $1; exit}' | sed 's/userId=//')"
  [ -n "$UID" ] && chown -R "$UID:$UID" "$D" 2>/dev/null
  restorecon -R "$D" 2>/dev/null
  chmod -R u+rwX "$D" 2>/dev/null
}

backup_data_tree() {
  SRC="$1"; DEST="$2"
  am force-stop "$PKG" 2>/dev/null
  sync
  sleep 1
  rm -rf "$DEST/data" 2>/dev/null
  mkdir -p "$DEST/data"
  (cd "$(dirname "$SRC")" && tar -cpf - "$(basename "$SRC")") | (cd "$DEST/data" && tar -xpf -) || return 1
  FC="$(count_files "$DEST/data")"
  [ "$FC" -gt 0 ] || return 1
  return 0
}

backup_sdcard() {
  SRC="$1"; DEST="$2"
  rm -rf "$DEST/sdcard_data" 2>/dev/null
  mkdir -p "$DEST/sdcard_data"
  (cd "$(dirname "$SRC")" && tar -cpf - "$(basename "$SRC")") | (cd "$DEST/sdcard_data" && tar -xpf -) 2>/dev/null
}

restore_data_tree() {
  ARCH="$1"; DEST="$2"
  mkdir -p "$DEST"
  rm -rf "$DEST"/* 2>/dev/null
  if [ -d "$ARCH/data/$PKG" ]; then
    cp -a "$ARCH/data/$PKG/." "$DEST/" || return 1
  else
    INNER="$(find "$ARCH/data" -maxdepth 2 -type d -name "$PKG" 2>/dev/null | head -1)"
    [ -n "$INNER" ] && cp -a "$INNER/." "$DEST/" || return 1
  fi
  fix_owner "$DEST"
  return 0
}

cmd_create() {
  NOTE="$ARG3"
  AID="$ARG4"
  SRC="$(find_app_data | head -1)"
  if [ -z "$SRC" ] || [ ! -d "$SRC" ]; then
    log "data dir not found — open target app, login, force-stop, then backup"
    exit 1
  fi
  FC="$(count_files "$SRC")"
  SD="$(sdcard_app_dir)"
  SDFC=0
  [ -n "$SD" ] && SDFC="$(count_files "$SD")"
  if [ "$FC" -lt 1 ] && [ "$SDFC" -lt 1 ]; then
    log "app data empty ($SRC) — login, then force-stop app before backup"
    exit 1
  fi
  mkdir -p "$BACKUP_ROOT/$PKG" "$CONFIG_DIR"
  ID="$(date +%Y%m%d_%H%M%S)_$$"
  DEST="$BACKUP_ROOT/$PKG/$ID"
  mkdir -p "$DEST"
  backup_data_tree "$SRC" "$DEST" || { log "backup data failed"; rm -rf "$DEST"; exit 1; }
  SD="$(sdcard_app_dir)" && backup_sdcard "$SD" "$DEST"
  copy_apk "$DEST"
  save_identity_to_backup "$DEST" "$AID"
  save_meta "$DEST" "$NOTE"
  FC2="$(count_files "$DEST/data")"
  echo "$FC2" > "$DEST/files_count.txt"
  log "backed up $FC2 data files from $SRC (silent, no app launch)"
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
    FC="$(cat "$d/files_count.txt" 2>/dev/null)"
    MT="0"; [ -f "$d/base.apk" ] && MT="1"
    AID=""; [ -f "$d/device_id.txt" ] && AID="$(cat "$d/device_id.txt" 2>/dev/null)"
    echo "$ID|$CREATED|$NOTE|$SIZE|$MT|$AID|$FC"
  done
  exit 0
}

cmd_restore() {
  ID="$ARG3"
  ARCH="$BACKUP_ROOT/$PKG/$ID"
  [ -d "$ARCH/data" ] || { log "backup missing"; exit 1; }
  FC="$(count_files "$ARCH/data")"
  [ "$FC" -gt 0 ] || { log "backup data empty — recreate backup after login"; exit 1; }
  pkg_installed || { log "install app first"; exit 1; }
  am force-stop "$PKG" 2>/dev/null
  pm clear "$PKG" >/dev/null 2>&1
  sleep 2
  DEST="$(find_app_data)" || DEST="$(read_data_dir)"
  [ -z "$DEST" ] && DEST="/data/user/0/$PKG"
  mkdir -p "$DEST"
  restore_data_tree "$ARCH" "$DEST" || { log "restore failed"; exit 1; }
  if [ -d "$ARCH/sdcard_data/$PKG" ]; then
    SD="$(sdcard_app_dir)" || SD="/storage/emulated/0/Android/data/$PKG"
    mkdir -p "$(dirname "$SD")"
    rm -rf "$SD" 2>/dev/null
    mkdir -p "$SD"
    cp -a "$ARCH/sdcard_data/$PKG/." "$SD/" 2>/dev/null
  fi
  restore_identity "$ID"
  sync
  log "restored $FC files to $DEST"
  echo "restored"
  exit 0
}

cmd_delete() {
  rm -rf "$BACKUP_ROOT/$PKG/$ARG3"
  echo "deleted"; exit 0
}

cmd_set_note() {
  printf '%s' "$ARG4" > "$BACKUP_ROOT/$PKG/$ARG3/note.txt"
  echo "ok"; exit 0
}

cmd_reset() {
  am force-stop "$PKG" 2>/dev/null
  pm clear "$PKG" >/dev/null 2>&1
  echo "reset"; exit 0
}

cmd_check() {
  if ! pkg_installed; then
    echo "not_installed"
    exit 1
  fi
  SRC="$(find_app_data | head -1)"
  if [ -z "$SRC" ] || [ ! -d "$SRC" ]; then
    echo "no_data"
    exit 1
  fi
  FC="$(count_files "$SRC")"
  SD="$(sdcard_app_dir)"
  SDFC=0
  [ -n "$SD" ] && SDFC="$(count_files "$SD")"
  echo "ok:$SRC:files=$FC:sdcard=$([ -n "$SD" ] && echo "$SDFC" || echo 0)"
  exit 0
}

cmd_load_id() {
  BASE="$BACKUP_ROOT/$PKG"
  LATEST=""
  if [ -d "$BASE" ]; then
    LATEST="$(ls -1t "$BASE" 2>/dev/null | head -1)"
  fi
  if [ -n "$LATEST" ] && [ -f "$BASE/$LATEST/device_id.txt" ]; then
    cat "$BASE/$LATEST/device_id.txt"
    exit 0
  fi
  CFG="$CONFIG_DIR/$(echo "$PKG" | tr '.' '_').json"
  if [ -f "$CFG" ]; then
    grep -o '"android_id"[[:space:]]*:[[:space:]]*"[^"]*"' "$CFG" 2>/dev/null \
      | sed 's/.*"\([^"]*\)"$/\1/'
    exit 0
  fi
  exit 1
}

[ -z "$PKG" ] && { log "package required"; exit 1; }
mkdir -p "$BACKUP_ROOT" "$CONFIG_DIR" "$MODDIR/bin"

case "$CMD" in
  create) cmd_create ;;
  list) cmd_list ;;
  restore) cmd_restore ;;
  delete) cmd_delete ;;
  set_note) cmd_set_note ;;
  reset) cmd_reset ;;
  check) cmd_check ;;
  load_id) cmd_load_id ;;
  *) log "usage: create|list|restore|delete|set_note|reset|check|load_id <pkg> ..."; exit 1 ;;
esac
