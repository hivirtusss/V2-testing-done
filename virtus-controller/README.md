# Virtus Controller v2.0

System Error style controller for **Virtus Zygisk module** (`zygisk_floating_menu`).

## Features

- **Home** — only WebUI-selected apps (from `target_packages.txt`)
- **Launch** + **Settings** per app (like System Error)
- **Android ID** — 16 hex, save to module config
- **Data Management** — Reset, Create Backup, Restore / Note / Delete
- Backups include **Device ID + app data + APK** (MT Manager compatible)

## Install

1. Flash module ZIP v36+ → reboot
2. WebUI → select apps → Save → reboot
3. Install `virtus_controller_v2.0.apk`
4. Grant root when prompted

## Backup flow

1. Open app → Settings (gear)
2. Set Android ID → **Save**
3. Enter note → **Create Backup**
4. Restore brings back **data + Device ID** together

## Build

```bash
export ANDROID_HOME=/path/to/android-sdk
cd virtus-controller && ./gradlew assembleRelease
```
