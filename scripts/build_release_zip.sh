#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cp "$ROOT/user_file/user_upload.zip" "$ROOT/releases/virtus_original.zip"
