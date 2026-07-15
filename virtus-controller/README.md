# Virtus Controller APK

System Error style controller app for **Virtus Zygisk module** (`zygisk_floating_menu`).

## Install (both required)

1. Flash **ZIP module** (`zygisk_floating_menu_hivirtus_selection.zip`) in KernelSU/SukiSU
2. Install **Virtus Controller APK** (`virtus_controller_v1.apk`)
3. Module WebUI → select target apps → Save → **reboot**
4. Open Virtus Controller → set Device ID / backups per app

## How APK + ZIP work together

| Component | Role |
|-----------|------|
| **ZIP module** | Zygisk inject → bubble menu in selected apps |
| **Controller APK** | Device ID, signature config, unlimited backups |
| **Shared folder** | `/data/adb/modules/zygisk_floating_menu/` |

APK writes config → ZIP injection reads on next app open.

```
APK Save → virtus_config/<package>.json
         → backups/<package>/<timestamp>/
              ↓
ZIP inject (classes.dex) → IdentityGuard loads config in target app
```

## Features

- **Apps** — pick target package
- **Identity** — Android ID (16 hex), signature spoof toggle
- **Backup** — unlimited create/list/restore/delete (root)
- **Module** — status + open WebUI

## Requirements

- Root (KernelSU / Magisk / APatch)
- Virtus module v33+ installed
- Android 8+

## Build

```bash
export ANDROID_HOME=/workspace/android-sdk
cd virtus-controller && ./gradlew assembleRelease
```
