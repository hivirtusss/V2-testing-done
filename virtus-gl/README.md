# Virtus GL

Separate launcher app inspired by KC GL flow, with **Virtus-owned** account + key system.

This project is isolated from `com.virtus.module` (SMS/OTP module). Do not mix package names or Firebase paths.

## Flow (same as KC GL)

1. Open app -> root check -> overlay permission -> plan select (lite/standard/pro)
2. Register account
3. Recharge with activation key (`KEY-XXXX-XXXX-XXXX-XXXX`)
4. Login (device bind via `ro.serialno`)
5. Dashboard with VIP timer + Start/Stop

## Firebase schema

Base URL (default): `https://virtus-gl-default-rtdb.firebaseio.com`

```
/virtus_gl/accounts/{username}
  password_hash
  device_id
  viptime        # unix seconds
  tier           # 1 lite, 2 standard, 3 pro
  last_unbind_at

/virtus_gl/keys/{KEY-XXXX-...}
  active
  days
  redeemed_by
  redeemed_at
```

## Generate keys

```bash
python3 virtus-gl/tools/generate_key.py --days 30 --count 5
```

Optional:

```bash
python3 virtus-gl/tools/generate_key.py \
  --firebase-url https://YOUR-PROJECT-default-rtdb.firebaseio.com \
  --days 7 \
  --count 10
```

Apply rules from `virtus-gl/firebase/database.rules.json` (dev-open). For production, move auth to Cloud Functions.

## Build APK

Requirements: Android SDK + JDK 17.

```bash
cd virtus-gl
bash build-apk.sh
```

Output: `virtus-gl/virtus-gl-debug.apk`

## Configure Firebase URL in app

Edit `virtus-gl/app/build.gradle`:

```gradle
buildConfigField "String", "FIREBASE_URL", "\"https://YOUR-PROJECT-default-rtdb.firebaseio.com\""
```

## Package

- App ID: `com.virtus.gl`
- Module app (untouched): `com.virtus.module`

## Next steps

- Wire native core into Start button (currently stub toast)
- Harden Firebase with server-side validation
- Add branded UI assets (logo/screens)
