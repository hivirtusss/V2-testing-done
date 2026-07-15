#!/system/bin/sh
# Virtus unlimited app-data backup (System Error style, no count limit)
MODDIR="/data/adb/modules/zygisk_floating_menu"
BACKUP_ROOT="$MODDIR/backups"
CMD="${1:-}"
PKG="${2:-}"
ARG3="${3:-}"

log() { echo "[virtus_backup] $*" >&2; }

find_app_data() {
  for base in /data/user/0 /data/user/10 /data/data; do
    [ -d "$base/$PKG" ] && echo "$base/$PKG" && return 0
  done
  return 1
}

cmd_create() {
  NOTE="$ARG3"
  SRC="$(find_app_data)" || { log "app data not found: $PKG"; exit 1; }
  ID="$(date +%Y%m%d_%H%M%S)_$$"
  DEST="$BACKUP_ROOT/$PKG/$ID"
  mkdir -p "$DEST" || exit 1
  cp -a "$SRC/." "$DEST/data/" 2>/dev/null || {
    mkdir -p "$DEST/data"
    cp -a "$SRC/." "$DEST/data/" || exit 1
  }
  echo "$NOTE" > "$DEST/note.txt"
  date -Iseconds > "$DEST/created.txt"
  du -sh "$DEST" 2>/dev/null | awk '{print $1}' > "$DEST/size.txt"
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
    NOTE="$(cat "$d/note.txt" 2>/dev/null)"
    SIZE="$(cat "$d/size.txt" 2>/dev/null)"
    echo "$ID|$CREATED|$NOTE|$SIZE"
  done
  exit 0
}

cmd_restore() {
  ID="$ARG3"
  SRC="$BACKUP_ROOT/$PKG/$ID/data"
  [ -d "$SRC" ] || { log "backup not found"; exit 1; }
  DEST="$(find_app_data)" || { log "app data dir missing"; exit 1; }
  pm clear "$PKG" >/dev/null 2>&1 || true
  mkdir -p "$DEST"
  rm -rf "$DEST"/*
  cp -a "$SRC/." "$DEST/" || exit 1
  chmod -R 771 "$DEST" 2>/dev/null
  chown -R "$(stat -c '%u:%g' "$(dirname "$DEST")" 2>/dev/null)" "$DEST" 2>/dev/null || true
  echo "restored"
  exit 0
}

cmd_delete() {
  ID="$ARG3"
  rm -rf "$BACKUP_ROOT/$PKG/$ID"
  echo "deleted"
  exit 0
}

[ -z "$PKG" ] && { log "package required"; exit 1; }
mkdir -p "$BACKUP_ROOT/$PKG"

case "$CMD" in
  create) cmd_create ;;
  list) cmd_list ;;
  restore) cmd_restore ;;
  delete) cmd_delete ;;
  *) log "usage: $0 create|list|restore|delete <package> [note|id]"; exit 1 ;;
esac
