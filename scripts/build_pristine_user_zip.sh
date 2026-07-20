#!/usr/bin/env bash
# Ship user's Drive zip with ORIGINAL classes.dex bytes (zero smali rebuild).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="${1:-$ROOT/user_file/user_working.zip}"
OUT="${2:-$ROOT/releases/virtus_v25_pristine.zip}"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

unzip -q "$SRC" -d "$STAGE"
cd "$STAGE"
chmod 755 post-fs-data.sh service.sh customize.sh refresh_pkglist.sh action.sh 2>/dev/null || true
rm -f "$OUT"
zip -qr "$OUT" .
echo "pristine zip (original dex): $OUT"
echo "classes.dex bytes: $(wc -c < "$STAGE/classes.dex")"
echo "dex md5: $(md5sum "$STAGE/classes.dex" | awk '{print $1}')"
