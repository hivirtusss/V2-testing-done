#!/system/bin/sh
# Virtus backup v6 — v25 cp -a style + improved dataDir detect + device_id sync
MODDIR="/data/adb/modules/zygisk_floating_menu"
BACKUP_ROOT="$MODDIR/backups"
CONFIG_DIR="$MODDIR/virtus_config"
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
  dumpsys package "$PKG" 2>/dev/null | grep -m1 'dataDir=' | sed 's/.*dataDir=//; s/ .*//; s/\r//'
}

resolve_data_dir() {
  if ! pkg_installed; then
    return 1
  fi
  D="$(read_data_dir)"
  if [ -n "$D" ] && [ -d "$D" ]; then
    echo "$D"
    return 0
  fi
  for b in /data/user/0 /data/user/10 /data/user/999 /data/user_de/0 /data/data; do
    if [ -d "$b/$PKG" ]; then
      echo "$b/$PKG"
      return 0
    fi
  done
  for udir in /data/user/*/"$PKG" /data/user_de/*/"$PKG"; do
    [ -d "$udir" ] || continue
    echo "$udir"
    return 0
  done
  FOUND="$(find /data/user /data/user_de -maxdepth 2 -type d -name "$PKG" 2>/dev/null | head -1)"
  if [ -n "$FOUND" ] && [ -d "$FOUND" ]; then
    echo "$FOUND"
    return 0
  fi
  if [ -n "$D" ]; then
    mkdir -p "$D" 2>/dev/null
    [ -d "$D" ] && echo "$D" && return 0
  fi
  return 1
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
  AID="$(echo "$1" | tr 'A-Z' 'a-z' | tr -cd '0-9a-f')"
  [ ${#AID} -ne 16 ] && return 0
  SAFE="$(echo "$PKG" | tr '.' '_')"
  mkdir -p "$CONFIG_DIR"
  TS="$(date +%s 2>/dev/null || echo 0)"
  printf '{"package":"%s","android_id":"%s","signature_spoof":true,"updated_at":%s}\n' \
    "$PKG" "$AID" "$TS" > "$CONFIG_DIR/${SAFE}.json"
  chmod 666 "$CONFIG_DIR/${SAFE}.json" 2>/dev/null || chmod 644 "$CONFIG_DIR/${SAFE}.json" 2>/dev/null || true
  printf '%s' "$AID" > "$MODDIR/device_id" 2>/dev/null
  printf '%s' "$AID" > "$MODDIR/device_id_${SAFE}" 2>/dev/null
  chmod 644 "$MODDIR/device_id" "$MODDIR/device_id_${SAFE}" 2>/dev/null || true
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
  [ -z "$AID" ] && [ -f "$MODDIR/device_id_$(echo "$PKG" | tr '.' '_')" ] && \
    AID="$(cat "$MODDIR/device_id_$(echo "$PKG" | tr '.' '_')" 2>/dev/null)"
  [ -z "$AID" ] && [ -f "$MODDIR/device_id" ] && AID="$(cat "$MODDIR/device_id" 2>/dev/null)"
  AID="$(echo "$AID" | tr 'A-Z' 'a-z' | tr -cd '0-9a-f')"
  if [ ${#AID} -ne 16 ]; then
    echo "{\"package\":\"$PKG\",\"android_id\":\"\"}" > "$DEST/identity.json"
    return 0
  fi
  TS="$(date +%s 2>/dev/null || echo 0)"
  printf '{"package":"%s","android_id":"%s","signature_spoof":true,"updated_at":%s}\n' \
    "$PKG" "$AID" "$TS" > "$DEST/identity.json"
  printf '%s' "$AID" > "$DEST/device_id.txt"
  sync_runtime_identity "$AID"
}

restore_identity() {
  BID="$1"
  SRC="$BACKUP_ROOT/$PKG/$BID"
  SAFE="$(echo "$PKG" | tr '.' '_')"
  mkdir -p "$CONFIG_DIR"
  if [ -f "$SRC/identity.json" ]; then
    cp "$SRC/identity.json" "$CONFIG_DIR/${SAFE}.json"
    chmod 666 "$CONFIG_DIR/${SAFE}.json" 2>/dev/null || true
  fi
  AID=""
  [ -f "$SRC/device_id.txt" ] && AID="$(cat "$SRC/device_id.txt" 2>/dev/null)"
  [ -z "$AID" ] && [ -f "$SRC/identity.json" ] && \
    AID="$(grep -o '"android_id"[[:space:]]*:[[:space:]]*"[^"]*"' "$SRC/identity.json" | sed 's/.*"\([^"]*\)"$/\1/')"
  sync_runtime_identity "$AID"
}

fix_owner() {
  D="$1"
  UID="$(dumpsys package "$PKG" 2>/dev/null | awk '/userId=/{print $1; exit}' | sed 's/userId=//')"
  [ -n "$UID" ] && chown -R "$UID:$UID" "$D" 2>/dev/null
  restorecon -R "$D" 2>/dev/null
  chmod -R u+rwX "$D" 2>/dev/null
}

cmd_create() {
  NOTE="$ARG3"
  AID="$ARG4"
  if ! pkg_installed; then
    log "app not installed: $PKG"
    exit 1
  fi
  am force-stop "$PKG" 2>/dev/null
  sync
  sleep 1
  SRC="$(resolve_data_dir 2>/dev/null | head -1)"
  SD="$(sdcard_app_dir)"
  SDFC=0
  [ -n "$SD" ] && SDFC="$(count_files "$SD")"
  FC=0
  if [ -n "$SRC" ] && [ -d "$SRC" ]; then
    FC="$(count_files "$SRC")"
  fi
  if [ "$FC" -lt 1 ] && [ "$SDFC" -lt 1 ]; then
    log "app data empty — open app, login, force-stop, then backup (dir=${SRC:-none})"
    exit 1
  fi
  mkdir -p "$BACKUP_ROOT/$PKG" "$CONFIG_DIR"
  ID="$(date +%Y%m%d_%H%M%S)_$$"
  DEST="$BACKUP_ROOT/$PKG/$ID"
  mkdir -p "$DEST/data" || exit 1
  if [ "$FC" -ge 1 ]; then
    cp -a "$SRC/." "$DEST/data/" || { log "copy failed from $SRC"; rm -rf "$DEST"; exit 1; }
  fi
  if [ "$SDFC" -ge 1 ] && [ -n "$SD" ]; then
    mkdir -p "$DEST/sdcard_data"
    cp -a "$SD/." "$DEST/sdcard_data/" 2>/dev/null || true
  fi
  copy_apk "$DEST"
  save_identity_to_backup "$DEST" "$AID"
  save_meta "$DEST" "$NOTE"
  FC2="$(count_files "$DEST/data")"
  log "backed up $FC2 internal + $SDFC sdcard files from ${SRC:-n/a}"
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
  [ "$FC" -gt 0 ] || { log "backup data empty — recreate after login"; exit 1; }
  pkg_installed || { log "install app first"; exit 1; }
  am force-stop "$PKG" 2>/dev/null
  pm clear "$PKG" >/dev/null 2>&1
  sleep 2
  DEST="$(resolve_data_dir 2>/dev/null | head -1)"
  [ -z "$DEST" ] && DEST="$(read_data_dir)"
  [ -z "$DEST" ] && DEST="/data/user/0/$PKG"
  mkdir -p "$DEST"
  rm -rf "$DEST"/* 2>/dev/null
  cp -a "$ARCH/data/." "$DEST/" || { log "restore failed"; exit 1; }
  fix_owner "$DEST"
  if [ -d "$ARCH/sdcard_data" ]; then
    SD="$(sdcard_app_dir)" || SD="/storage/emulated/0/Android/data/$PKG"
    mkdir -p "$SD"
    rm -rf "$SD"/* 2>/dev/null
    cp -a "$ARCH/sdcard_data/." "$SD/" 2>/dev/null
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
  SRC="$(resolve_data_dir 2>/dev/null | head -1)"
  if [ -z "$SRC" ] || [ ! -d "$SRC" ]; then
    echo "no_data"
    exit 1
  fi
  FC="$(count_files "$SRC")"
  SD="$(sdcard_app_dir)"
  SDFC=0
  [ -n "$SD" ] && SDFC="$(count_files "$SD")"
  echo "ok:$SRC:files=$FC:sdcard=$SDFC"
  exit 0
}

cmd_load_id() {
  SAFE="$(echo "$PKG" | tr '.' '_')"
  if [ -f "$CONFIG_DIR/${SAFE}.json" ]; then
    grep -o '"android_id"[[:space:]]*:[[:space:]]*"[^"]*"' "$CONFIG_DIR/${SAFE}.json" 2>/dev/null \
      | sed 's/.*"\([^"]*\)"$/\1/' | head -1
    exit 0
  fi
  if [ -f "$MODDIR/device_id_${SAFE}" ]; then
    cat "$MODDIR/device_id_${SAFE}"
    exit 0
  fi
  if [ -f "$MODDIR/device_id" ]; then
    cat "$MODDIR/device_id"
    exit 0
  fi
  BASE="$BACKUP_ROOT/$PKG"
  LATEST=""
  [ -d "$BASE" ] && LATEST="$(ls -1t "$BASE" 2>/dev/null | head -1)"
  if [ -n "$LATEST" ] && [ -f "$BASE/$LATEST/device_id.txt" ]; then
    cat "$BASE/$LATEST/device_id.txt"
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
