#!/system/bin/sh
# Virtus backup — Neo/Swift style (VirtusBackup/) — Device ID inside backup only
MODDIR="/data/adb/modules/zygisk_floating_menu"
BACKUP_ROOT="/storage/emulated/0/VirtusBackup"
CMD="${1:-}"
PKG="${2:-}"
ARG3="${3:-}"
ARG4="${4:-}"

log() { echo "[virtus_backup] $*" >&2; }

pkg_installed() { pm path "$PKG" >/dev/null 2>&1; }

read_data_dir() {
  dumpsys package "$PKG" 2>/dev/null | grep -m1 'dataDir=' | sed 's/.*dataDir=//; s/ .*//; s/\r//'
}

read_de_data_dir() {
  echo "/data/user_de/0/$PKG"
}

sdcard_app_dir() {
  for p in "/storage/emulated/0/Android/data/$PKG" "/sdcard/Android/data/$PKG"; do
    [ -d "$p" ] && echo "$p" && return 0
  done
  return 1
}

obb_dir() {
  for p in "/storage/emulated/0/Android/obb/$PKG" "/sdcard/Android/obb/$PKG"; do
    [ -d "$p" ] && echo "$p" && return 0
  done
  return 1
}

find_app_data() {
  if ! pkg_installed; then
    log "app not installed: $PKG"
    return 1
  fi
  D="$(read_data_dir)"
  if [ -n "$D" ] && [ -d "$D" ]; then
    echo "$D"
    return 0
  fi
  for b in /data/user/0 /data/user/10 /data/user/999 /data/data; do
    [ -d "$b/$PKG" ] && echo "$b/$PKG" && return 0
  done
  return 1
}

backup_dir_for_id() {
  BID="$1"
  [ -d "$BACKUP_ROOT/$PKG/0/$BID" ] && echo "$BACKUP_ROOT/$PKG/0/$BID" && return 0
  # legacy MT2
  for d in "/storage/emulated/0/MT2/Backup"/${PKG}_*virtus_${BID}; do
    [ -d "$d" ] && echo "$d" && return 0
  done
  return 1
}

json_escape() {
  printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

write_properties() {
  DEST="$1"
  NOTE="$2"
  AID="$3"
  HAS_APK="$4"
  HAS_DATA="$5"
  HAS_EXT="$6"
  HAS_DE="$7"
  HAS_OBB="$8"
  VER="$9"
  CODE="${10}"
  TS="${11}"
  NNOTE="$(json_escape "$NOTE")"
  cat > "$DEST/backup.properties" <<EOF
{
  "backupDate": "$TS",
  "packageName": "$PKG",
  "packageLabel": "$PKG",
  "profileId": 0,
  "versionName": "$VER",
  "versionCode": $CODE,
  "hasApk": $HAS_APK,
  "hasAppData": $HAS_DATA,
  "hasExternalData": $HAS_EXT,
  "hasDeviceProtectedData": $HAS_DE,
  "hasObbData": $HAS_OBB,
  "android_id": "$AID",
  "note": "$NNOTE"
}
EOF
  [ -n "$AID" ] && printf '%s' "$AID" > "$DEST/device_id.txt"
  [ -n "$NOTE" ] && printf '%s' "$NOTE" > "$DEST/note.txt"
}

copy_apks() {
  DEST="$1"
  HAS=0
  for apk in $(pm path "$PKG" 2>/dev/null | sed 's/^package://'); do
    [ -f "$apk" ] || continue
    base="$(basename "$apk")"
    cp "$apk" "$DEST/$base" 2>/dev/null && HAS=1
  done
  echo "$HAS"
}

apply_id_from_backup() {
  ARCH="$1"
  AID=""
  if [ -f "$ARCH/device_id.txt" ]; then
    AID="$(cat "$ARCH/device_id.txt" 2>/dev/null | tr -cd '0-9a-f')"
  elif [ -f "$ARCH/backup.properties" ]; then
    AID="$(grep -o '"android_id"[[:space:]]*:[[:space:]]*"[^"]*"' "$ARCH/backup.properties" 2>/dev/null | sed 's/.*"\([^"]*\)"$/\1/' | tr -cd '0-9a-f')"
  fi
  [ ${#AID} -ne 16 ] && return 0
  SAFE="$(echo "$PKG" | tr '.' '_')"
  printf '%s' "$AID" > "$MODDIR/device_id"
  printf '%s' "$AID" > "$MODDIR/device_id_${SAFE}"
  chmod 644 "$MODDIR/device_id" "$MODDIR/device_id_${SAFE}" 2>/dev/null
  date +%s > "$MODDIR/.virtus_sync" 2>/dev/null || true
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
  AID="$(echo "$ARG4" | tr 'A-Z' 'a-z' | tr -cd '0-9a-f')"
  [ ${#AID} -ne 16 ] && AID=""
  if ! pkg_installed; then
    log "app not installed"
    exit 1
  fi
  am force-stop "$PKG" 2>/dev/null
  sync
  sleep 1
  SRC="$(find_app_data)" || {
    log "no app data — login + force-stop first"
    exit 1
  }
  FC="$(find "$SRC" -type f 2>/dev/null | wc -l)"
  [ "$FC" -lt 1 ] && { log "app data empty"; exit 1; }

  TS="$(date +%Y-%m-%d.%H-%M-%S)"
  DEST="$BACKUP_ROOT/$PKG/0/$TS"
  mkdir -p "$DEST" || { log "cannot create $DEST"; exit 1; }

  VER="$(dumpsys package "$PKG" 2>/dev/null | awk -F= '/versionName=/{print $2; exit}' | tr -d "'")"
  CODE="$(dumpsys package "$PKG" 2>/dev/null | awk -F= '/versionCode=/{print $2; exit}' | tr -cd '0-9')"
  [ -z "$VER" ] && VER="unknown"
  [ -z "$CODE" ] && CODE=0

  HAS_APK="$(copy_apks "$DEST")"
  HAS_DATA=0
  HAS_EXT=0
  HAS_DE=0
  HAS_OBB=0

  (cd "$(dirname "$SRC")" && tar -cpf - "$(basename "$SRC")") | gzip -9 > "$DEST/data.tar.gz" && HAS_DATA=1 \
    || { log "data archive failed"; rm -rf "$DEST"; exit 1; }

  SD="$(sdcard_app_dir)"
  if [ -n "$SD" ] && [ -d "$SD" ]; then
    (cd "$(dirname "$SD")" && tar -cpf - "$(basename "$SD")") | gzip -9 > "$DEST/external_data.tar.gz" 2>/dev/null && HAS_EXT=1
  fi

  DE="$(read_de_data_dir)"
  if [ -d "$DE" ]; then
    (cd /data/user_de/0 && tar -cpf - "$PKG") | gzip -9 > "$DEST/device_protected_data.tar.gz" 2>/dev/null && HAS_DE=1
  fi

  OBB="$(obb_dir)"
  if [ -n "$OBB" ] && [ -d "$OBB" ]; then
    (cd "$(dirname "$OBB")" && tar -cpf - "$(basename "$OBB")") | gzip -9 > "$DEST/obb_data.tar.gz" 2>/dev/null && HAS_OBB=1
  fi

  write_properties "$DEST" "$NOTE" "$AID" \
    "$([ "$HAS_APK" = 1 ] && echo true || echo false)" \
    "$([ "$HAS_DATA" = 1 ] && echo true || echo false)" \
    "$([ "$HAS_EXT" = 1 ] && echo true || echo false)" \
    "$([ "$HAS_DE" = 1 ] && echo true || echo false)" \
    "$([ "$HAS_OBB" = 1 ] && echo true || echo false)" \
    "$VER" "$CODE" "$TS"

  du -sh "$DEST" 2>/dev/null | awk '{print $1}' > "$DEST/size.txt"
  date '+%Y-%m-%d %H:%M:%S' > "$DEST/created.txt"
  echo "$FC" > "$DEST/files_count.txt"
  chmod -R 755 "$DEST" 2>/dev/null
  log "Neo backup -> $DEST ($FC files)"
  echo "$TS"
  exit 0
}

cmd_list() {
  for base in "$BACKUP_ROOT/$PKG/0" "/storage/emulated/0/MT2/Backup"; do
    [ -d "$base" ] || continue
    if [ "$base" = "/storage/emulated/0/MT2/Backup" ]; then
      for d in "$base"/${PKG}_*; do
        [ -d "$d" ] || continue
        BASE="$(basename "$d")"
        ID="${BASE##*virtus_}"
        CREATED="$(cat "$d/created.txt" 2>/dev/null)"
        NOTE="$(cat "$d/note.txt" 2>/dev/null | tr '\n' ' ')"
        SIZE="$(cat "$d/size.txt" 2>/dev/null)"
        AID=""; [ -f "$d/device_id.txt" ] && AID="$(cat "$d/device_id.txt")"
        FC="$(find "$d/data" -type f 2>/dev/null | wc -l)"
        echo "$ID|$CREATED|$NOTE|$SIZE|1|$AID|$FC"
      done
      continue
    fi
    for d in "$base"/*; do
      [ -f "$d/backup.properties" ] || [ -d "$d/data" ] || [ -f "$d/data.tar.gz" ] || continue
      [ -d "$d" ] || continue
      ID="$(basename "$d")"
      CREATED="$(cat "$d/created.txt" 2>/dev/null)"
      NOTE="$(cat "$d/note.txt" 2>/dev/null | tr '\n' ' ')"
      [ -z "$NOTE" ] && NOTE="$(grep -o '"note"[[:space:]]*:[[:space:]]*"[^"]*"' "$d/backup.properties" 2>/dev/null | sed 's/.*"\([^"]*\)"$/\1/')"
      SIZE="$(cat "$d/size.txt" 2>/dev/null)"
      AID=""; [ -f "$d/device_id.txt" ] && AID="$(cat "$d/device_id.txt")"
      [ -z "$AID" ] && [ -f "$d/backup.properties" ] && AID="$(grep -o '"android_id"[[:space:]]*:[[:space:]]*"[^"]*"' "$d/backup.properties" | sed 's/.*"\([^"]*\)"$/\1/')"
      FC="$(cat "$d/files_count.txt" 2>/dev/null)"
      [ -z "$FC" ] && FC=0
      echo "$ID|$CREATED|$NOTE|$SIZE|1|$AID|$FC"
    done
  done
  exit 0
}

extract_tar() {
  ARCHIVE="$1"
  TARGET_DIR="$2"
  [ -f "$ARCHIVE" ] || return 0
  mkdir -p "$TARGET_DIR"
  gzip -dc "$ARCHIVE" | tar -xpf - -C "$TARGET_DIR" 2>/dev/null || return 1
}

cmd_restore() {
  ID="$ARG3"
  ARCH="$(backup_dir_for_id "$ID")"
  [ -n "$ARCH" ] || { log "backup not found"; exit 1; }
  if ! pkg_installed; then
    log "install app first"
    exit 1
  fi
  am force-stop "$PKG" 2>/dev/null
  pm clear "$PKG" >/dev/null 2>&1
  sleep 2

  # Legacy folder layout (data/)
  if [ -d "$ARCH/data" ]; then
    DEST="$(read_data_dir)"; [ -z "$DEST" ] && DEST="/data/user/0/$PKG"
    mkdir -p "$DEST"
    rm -rf "$DEST"/* 2>/dev/null
    cp -a "$ARCH/data/." "$DEST/" || { log "restore failed"; exit 1; }
    fix_owner "$DEST"
    if [ -d "$ARCH/sdcard_data" ] || [ -d "$ARCH/external" ]; then
      SD="$(sdcard_app_dir)" || SD="/storage/emulated/0/Android/data/$PKG"
      mkdir -p "$SD"
      rm -rf "$SD"/* 2>/dev/null
      [ -d "$ARCH/sdcard_data" ] && cp -a "$ARCH/sdcard_data/." "$SD/" 2>/dev/null
      [ -d "$ARCH/external" ] && cp -a "$ARCH/external/." "$SD/" 2>/dev/null
    fi
    apply_id_from_backup "$ARCH"
    echo "restored"
    exit 0
  fi

  # Neo tar.gz layout
  DEST="$(read_data_dir)"; [ -z "$DEST" ] && DEST="/data/user/0/$PKG"
  mkdir -p "$DEST"
  rm -rf "$DEST"/* 2>/dev/null
  if [ -f "$ARCH/data.tar.gz" ]; then
    extract_tar "$ARCH/data.tar.gz" "$(dirname "$DEST")" || { log "data extract failed"; exit 1; }
    fix_owner "$DEST"
  fi
  if [ -f "$ARCH/external_data.tar.gz" ]; then
    extract_tar "$ARCH/external_data.tar.gz" "/storage/emulated/0/Android/data" 2>/dev/null \
      || extract_tar "$ARCH/external_data.tar.gz" "/storage/emulated/0/Android" 2>/dev/null
  fi
  if [ -f "$ARCH/device_protected_data.tar.gz" ]; then
    extract_tar "$ARCH/device_protected_data.tar.gz" "/data/user_de/0" 2>/dev/null
    DE="$(read_de_data_dir)"
    [ -d "$DE" ] && fix_owner "$DE"
  fi
  if [ -f "$ARCH/obb_data.tar.gz" ]; then
    extract_tar "$ARCH/obb_data.tar.gz" "/storage/emulated/0/Android/obb" 2>/dev/null \
      || extract_tar "$ARCH/obb_data.tar.gz" "/storage/emulated/0/Android" 2>/dev/null
  fi
  apply_id_from_backup "$ARCH"
  sync
  echo "restored"
  exit 0
}

cmd_delete() {
  ID="$ARG3"
  ARCH="$(backup_dir_for_id "$ID")"
  [ -n "$ARCH" ] && rm -rf "$ARCH"
  echo "deleted"
  exit 0
}

cmd_set_note() {
  ID="$ARG3"
  NOTE="$ARG4"
  ARCH="$(backup_dir_for_id "$ID")"
  [ -n "$ARCH" ] || exit 1
  printf '%s' "$NOTE" > "$ARCH/note.txt"
  if [ -f "$ARCH/backup.properties" ]; then
    AID="$(grep -o '"android_id"[[:space:]]*:[[:space:]]*"[^"]*"' "$ARCH/backup.properties" 2>/dev/null | sed 's/.*"\([^"]*\)"$/\1/')"
    VER="$(grep -o '"versionName"[[:space:]]*:[[:space:]]*"[^"]*"' "$ARCH/backup.properties" | sed 's/.*"\([^"]*\)"$/\1/')"
    CODE="$(grep -o '"versionCode"[[:space:]]*:[[:space:]]*[0-9]*' "$ARCH/backup.properties" | grep -o '[0-9]*$')"
    TS="$(grep -o '"backupDate"[[:space:]]*:[[:space:]]*"[^"]*"' "$ARCH/backup.properties" | sed 's/.*"\([^"]*\)"$/\1/')"
    write_properties "$ARCH" "$NOTE" "$AID" true true false false false "${VER:-unknown}" "${CODE:-0}" "${TS:-unknown}"
  fi
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
  if ! pkg_installed; then echo "not_installed"; exit 1; fi
  SRC="$(find_app_data)" && echo "ok:$SRC" || echo "no_data"
  exit 0
}

cmd_save_id() {
  AID="$(echo "$ARG3" | tr 'A-Z' 'a-z' | tr -cd '0-9a-f')"
  [ ${#AID} -ne 16 ] && exit 1
  SAFE="$(echo "$PKG" | tr '.' '_')"
  printf '%s' "$AID" > "$MODDIR/device_id"
  printf '%s' "$AID" > "$MODDIR/device_id_${SAFE}"
  chmod 644 "$MODDIR/device_id" "$MODDIR/device_id_${SAFE}" 2>/dev/null
  date +%s > "$MODDIR/.virtus_sync" 2>/dev/null || true
  echo "ok"
  exit 0
}

[ -z "$PKG" ] && { log "package required"; exit 1; }
mkdir -p "$MODDIR/bin" 2>/dev/null

case "$CMD" in
  create) cmd_create ;;
  list) cmd_list ;;
  restore) cmd_restore ;;
  delete) cmd_delete ;;
  set_note) cmd_set_note ;;
  reset) cmd_reset ;;
  check) cmd_check ;;
  save_id) cmd_save_id ;;
  *) log "usage: create|list|restore|delete|set_note|reset|check|save_id"; exit 1 ;;
esac
