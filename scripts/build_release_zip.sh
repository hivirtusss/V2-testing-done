#!/usr/bin/env bash
# Build release zip — user zygisk + minimal IdentityGuard dex (Android Faker style ID hook).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

chmod +x "$ROOT/scripts/build_minimal_identity_dex.sh"
"$ROOT/scripts/build_minimal_identity_dex.sh" "$ROOT/extracted/classes.dex"
unzip -p "$ROOT/user_file/user_upload.zip" zygisk/arm64-v8a.so > "$ROOT/extracted/zygisk/arm64-v8a.so"
unzip -p "$ROOT/user_file/user_upload.zip" zygisk/armeabi-v7a.so > "$ROOT/extracted/zygisk/armeabi-v7a.so"

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
cp -a "$ROOT/extracted/." "$STAGE/"

cd "$STAGE"
chmod 755 post-fs-data.sh service.sh customize.sh refresh_pkglist.sh action.sh 2>/dev/null || true
chmod 755 bin/virtus_backup.sh 2>/dev/null || true
rm -f "$ROOT/zygisk_floating_menu_hivirtus_selection.zip"
zip -r "$ROOT/zygisk_floating_menu_hivirtus_selection.zip" .
cp "$ROOT/zygisk_floating_menu_hivirtus_selection.zip" "$ROOT/releases/zygisk_floating_menu_v25.zip"
echo "Release: $(wc -c < "$ROOT/zygisk_floating_menu_hivirtus_selection.zip") bytes, dex $(wc -c < "$ROOT/extracted/classes.dex")"
