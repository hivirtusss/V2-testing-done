# KC GL — No Activation Key Patch

Patches the **KC GL** APK from Google Drive so login works with **id + password only** (no recharge/activation key).

**Virtus GL is unchanged** — it keeps the full ShuanQ key flow. This pipeline only targets the original `com.android.lc` KC GL APK.

## Prerequisites

1. Download the Drive APK to `apk/drive-analysis/drive-app.apk`
2. `apktool.jar` at `/tmp/apktool.jar` (or set `APKTOOL`)

## Build

```bash
bash apk/kc-no-key/build.sh
```

Output: `apk/kc-no-key/kc-gl-no-key.apk` (unsigned; sign before install).

## What gets patched

| Target | Change |
|--------|--------|
| Login screen | Hide Activation / recharge button |
| Login callback | Bypass VIP check (`FUCKYOU` gate) — login proceeds after id+pass |
| Start Cheat | Skip `isExpire()` / viptime check |
| Profile VIP label | Hide "Membership is not activated" |
| Recharge handler | Disabled |

Native checks in `libkernel.so` may still apply for some features; these patches remove the Java-side activation gates.
