# Zygisk Mode Menu Virtus V3

Magisk / KernelSU / SukiSU Zygisk module for per-app hook selection.

## Install (safe build v13+)

1. If you previously installed a broken build (v10/v11 or patched dex), **remove it first**:
   ```bash
   adb shell "su -c 'rm -rf /data/adb/modules/zygisk_floating_menu'"
   ```
   Reboot, or flash `virtus_emergency_uninstall.zip` from recovery.

2. Install `zygisk_floating_menu_hivirtus_selection.zip` from the [release](https://github.com/hivirtusss/V2-testing-done/releases/tag/virtus-v3-hivirtus-selection).

3. Reboot. Open the module page → **Action** → pick apps in the red WebUI → Save → Reboot.

## What Action does

Opens the module WebUI (app picker). It does **not** run `app_process` or dump package lists to a terminal.

## Safe dex policy

`classes.dex` must stay ~240KB (original Zygisk injection size). Only minimal in-place smali patches are applied:

- License gate removed
- SystemUI license overlay disabled
- Title: **Zygisk Mode Menu Virtus V3**
- Red bubble theme + **V** fallback logo

Do **not** ship full recompiled dex with extra classes (~278KB+) — that crashes all apps via zygote.

Rebuild dex:

```bash
./scripts/build_safe_dex.sh extracted/classes.dex
cd extracted && zip -r ../zygisk_floating_menu_hivirtus_selection.zip .
```

## Module info

- **id:** `zygisk_floating_menu`
- **name:** Zygisk Mode Menu Virtus V3
- **description:** Zygisk Mode Virtus V3
