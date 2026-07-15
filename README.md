# Virtus V3 — Zygisk Floating Menu + Controller

**Author:** [@Hivirtus](https://github.com/hivirtusss)

KernelSU / SukiSU / Magisk Zygisk module with per-app bubble menu, plus a controller APK for identity spoof and MT Manager–compatible backups.

## Download

| File | Description |
|------|-------------|
| [zygisk_floating_menu_hivirtus_selection.zip](releases/zygisk_floating_menu_hivirtus_selection.zip) | Module ZIP (v34) — injects bubble in WebUI-selected apps |
| [virtus_controller_v1.1.apk](releases/virtus_controller_v1.1.apk) | Controller APK — Device ID, backup, MT export |
| [virtus_emergency_uninstall.zip](releases/virtus_emergency_uninstall.zip) | Emergency uninstall if module breaks boot |

## Install

1. Flash **module ZIP** in KernelSU / SukiSU / Magisk (Zygisk enabled).
2. Install **Virtus Controller APK**.
3. Reboot → open module **Action** → pick apps in WebUI → **Save** → reboot again.
4. Open Virtus Controller for Device ID, backups, and MT Manager export.

## How APK + ZIP work together

| Component | Role |
|-----------|------|
| **ZIP module** | Zygisk inject → red bubble menu in selected apps |
| **Controller APK** | Device ID config, unlimited backup, MT Manager export |
| **Shared path** | `/data/adb/modules/zygisk_floating_menu/` |

APK writes `virtus_config/<package>.json` and backups → module reads on next app inject via `IdentityGuard`.

## Module info

- **id:** `zygisk_floating_menu`
- **name:** Zygisk Mode Menu Virtus V3
- **versionCode:** 34

## Repository layout

```
extracted/          # Shippable module (flash this folder as ZIP)
virtus-controller/  # Controller APK source (Kotlin)
patch_smali/        # Dex patches (MenuLoader, IdentityGuard, etc.)
user_smali/         # Base smali (90 classes, size-safe)
scripts/            # build_safe_dex.sh, build_release_zip.sh
releases/           # Pre-built ZIP + APK downloads
```

## Build module ZIP

```bash
./scripts/build_safe_dex.sh extracted/classes.dex
./scripts/build_release_zip.sh
```

**Important:** `classes.dex` must stay ~240KB. Do not ship full recompiled dex (~278KB+) — it breaks Zygisk injection.

## Build Controller APK

```bash
export ANDROID_HOME=/path/to/android-sdk
cd virtus-controller && ./gradlew assembleRelease
```

## Emergency uninstall

If a bad build causes bootloop:

```bash
adb shell "su -c 'rm -rf /data/adb/modules/zygisk_floating_menu'"
```

Or flash `virtus_emergency_uninstall.zip` from recovery.

## License

For personal / rooted device use. Module based on user's original `zygisk_floating_menu` upload (v23), extended with backup, identity config, and controller APK.
