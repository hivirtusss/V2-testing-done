#!/usr/bin/env bash
# Build release zip — ships plaintext classes.dex (required for Zygisk injection).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

"$ROOT/scripts/build_safe_dex.sh" "$ROOT/extracted/classes.dex"
"$ROOT/scripts/encrypt_dex.sh"

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
cp -a "$ROOT/extracted/." "$STAGE/"

cd "$STAGE"
chmod 755 decrypt_dex.sh post-fs-data.sh service.sh customize.sh refresh_pkglist.sh 2>/dev/null || true
zip -r "$ROOT/zygisk_floating_menu_hivirtus_selection.zip" .
echo "Release zip: $ROOT/zygisk_floating_menu_hivirtus_selection.zip ($(wc -c < "$ROOT/zygisk_floating_menu_hivirtus_selection.zip") bytes)"
