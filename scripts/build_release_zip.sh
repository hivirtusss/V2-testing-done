#!/usr/bin/env bash
# Build release zip — bubble-safe user dex + minimal IdentityGuard hook (default).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

if [ "${USE_USER_DEX:-0}" = "1" ]; then
  unzip -p "$ROOT/user_file/user_upload.zip" classes.dex > "$ROOT/extracted/classes.dex"
  echo "Using pure user dex (bubble-only, no IdentityGuard)"
else
  chmod +x "$ROOT/scripts/build_minimal_identity_dex.sh"
  "$ROOT/scripts/build_minimal_identity_dex.sh" "$ROOT/extracted/classes.dex"
fi

# Always ship original zygisk .so from user upload (proven bubble base)
unzip -p "$ROOT/user_file/user_upload.zip" zygisk/arm64-v8a.so > "$ROOT/extracted/zygisk/arm64-v8a.so"
unzip -p "$ROOT/user_file/user_upload.zip" zygisk/armeabi-v7a.so > "$ROOT/extracted/zygisk/armeabi-v7a.so"

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
cp -a "$ROOT/extracted/." "$STAGE/"

cd "$STAGE"
chmod 755 post-fs-data.sh service.sh customize.sh refresh_pkglist.sh action.sh 2>/dev/null || true
chmod 755 bin/virtus_backup.sh bin/virtus_identity.sh 2>/dev/null || true
rm -f "$ROOT/zygisk_floating_menu_hivirtus_selection.zip"
zip -r "$ROOT/zygisk_floating_menu_hivirtus_selection.zip" .
echo "Release zip: $ROOT/zygisk_floating_menu_hivirtus_selection.zip ($(wc -c < "$ROOT/zygisk_floating_menu_hivirtus_selection.zip") bytes)"
echo "classes.dex: $(wc -c < "$ROOT/extracted/classes.dex") bytes"
