#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
cd "$ROOT"

if ! command -v java >/dev/null 2>&1; then
  echo "Java is required."
  exit 1
fi

if [ ! -x "./gradlew" ]; then
  if command -v gradle >/dev/null 2>&1; then
    gradle wrapper --gradle-version 8.2.1
  else
    echo "Install Gradle or add gradlew to build Virtus GL."
    exit 1
  fi
fi

./gradlew :app:assembleDebug
APK="$ROOT/app/build/outputs/apk/debug/app-debug.apk"
if [ -f "$APK" ]; then
  cp "$APK" "$ROOT/virtus-gl-debug.apk"
  echo "Built: $ROOT/virtus-gl-debug.apk"
else
  echo "Build finished but APK not found."
  exit 1
fi
