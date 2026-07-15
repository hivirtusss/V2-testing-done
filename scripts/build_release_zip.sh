#!/usr/bin/env bash
# Build release zip from extracted/ — uses user's working classes.dex (no dex rebuild).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

# Only rebuild dex when explicitly requested (default: ship extracted/classes.dex as-is)
if [ "${REBUILD_DEX:-0}" = "1" ]; then
  "$ROOT/scripts/build_safe_dex.sh" "$ROOT/extracted/classes.dex"
fi

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
cp -a "$ROOT/extracted/." "$STAGE/"

cd "$STAGE"
chmod 755 post-fs-data.sh service.sh customize.sh refresh_pkglist.sh action.sh 2>/dev/null || true
chmod 755 bin/virtus_backup.sh 2>/dev/null || true
zip -r "$ROOT/zygisk_floating_menu_hivirtus_selection.zip" .
echo "Release zip: $ROOT/zygisk_floating_menu_hivirtus_selection.zip ($(wc -c < "$ROOT/zygisk_floating_menu_hivirtus_selection.zip") bytes)"
echo "classes.dex: $(wc -c < "$ROOT/extracted/classes.dex") bytes (user base)"
