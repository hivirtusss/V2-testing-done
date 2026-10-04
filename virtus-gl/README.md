# Virtus GL (KC GL clone)

**Same-to-same KC GL system**, rebranded for Virtus. Virtus SMS module (`com.virtus.module`) is **not touched**.

| KC GL | Virtus GL |
|-------|-----------|
| `com.android.lc` | `com.virtus.gl` |
| KC GL | Virtus GL |
| ShuanQ key/auth | **Same ShuanQ flow (unchanged)** |
| `libkernel.so` | **Same native core** |

## Full feature parity (everything KC has)

- Root + overlay permission bootstrap
- Lite / Standard / Pro version select
- Asset deploy (fonts, image, voice, kpm)
- **Register** account
- **Activation key recharge** (`KEY`/card via ShuanQ + native)
- **Login** with device bind (`ro.serialno`)
- **Server line** switch
- **VIP timer** + heartbeat
- **Unbind device** (24h cooldown, -2h penalty)
- Personal dashboard (device info, VIP, announcements)
- **Load driver** D / KPM
- **Settings**: PUBG region select, hide ESP, gyro, touch mode, visual model
- **Config** upload / download / delete
- **Start / Stop cheat** + game launch inject
- Update check + cheat core update
- APatch super key setting
- Upload logs

## Build Virtus GL APK

1. Put KC GL decompiled tree at `apk/drive-analysis/decompiled` (already from Drive APK)
2. Run:

```bash
cd virtus-gl
bash build-apk.sh
```

Output: `virtus-gl/virtus-gl.apk` (~29MB, unsigned)

Optional own ShuanQ app credentials:

```bash
SHUANQ_APP_ID=12345 SHUANQ_APP_KEY=yourkey bash build-apk.sh
```

Sign before install:

```bash
apksigner sign --ks your.jks --out virtus-gl-signed.apk virtus-gl.apk
```

## Key / account flow (same as KC)

1. **Register** → username + password
2. **Activation** → username + card key (recharge)
3. **Login** → only works if VIP active + device allowed
4. **Start cheat** → native `libkernel.so` inject

Keys are managed on **your ShuanQ panel** (same backend KC uses unless you override AppId).

## Patch only (no build)

```bash
python3 virtus-gl/patch_rebrand.py \
  --source apk/drive-analysis/decompiled \
  --output virtus-gl/build/decompiled
```

## Notes

- This is a **rebrand + package rename** of KC GL — all screens, native libs, and auth logic stay identical.
- For production, use **your own ShuanQ AppId/AppKey** when building.
- Do not mix with Virtus OTP module APK.
