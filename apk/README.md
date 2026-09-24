# Virtus SMS Module APK

Astik-style inject module — same poll + inject flow, Virtus branding.

## Flow (same as Astik)

1. **Bot admin**: `/key generate` → user: `/key KEY-XXXX-XXXX-XXXX-XXXX`
2. **APK (mynum phone)**: same KEY enter → **START SERVICE ON**
3. **Bot**: `/fy <device_id>` → SIM select → `/mynum <number>` → `/addchannel` → `/startmonitor`
4. Bot pushes inject to `{device_firebase}/messages/num-{mynum}/`
5. APK reads config from `virtus-module-default-rtdb.../config/{KEY}.json`
6. APK polls `{firebase_url}/messages/{device_id}` and injects sender + body into inbox

## Firebase Structure

```
https://virtus-module-default-rtdb.firebaseio.com/
  config/{KEY}.json          ← monitoring, firebase_url, device_id=num-{mynum}
  license_keys/{KEY}/meta    ← active:true (bot-generated keys only)

{device_firebase}/
  messages/num-{mynum}/      ← inject queue {sender, body, injected}
  devices/{device_id}/       ← monitored device heartbeat
```

## Download

**iOS (iPhone):** Telegram bot mein `/apk` → **Download APK (tap)** button dabao.

Direct HTTPS link (tap on iPhone Safari / Telegram):

```
https://raw.githubusercontent.com/hivirtusss/V2-testing-done/cursor/astik-minimal-flow-8042/apk/virtus-sms-module.apk
```

VPS (optional): `http://YOUR_SERVER:8000/download/apk` or mobile page `/apk`

Telegram bot: `/apk`

## Install

1. Install on **rooted** Android (mynum / inject phone)
2. Grant SMS + notification permissions
3. Enter admin-generated `KEY-XXXX-...`
4. Toggle **START SERVICE** ON
5. **TEST INJECTION** → inbox: `BABY` / `ASTIK TEST OK — module alive`
6. Bot `/startmonitor` bhi same test inject karta hai (KEY optional on bot)

## Requirements

- Root (Magisk) for SmsInjector / SmsBroadcaster
- Internet for Firebase SSE + poll
- Only bot-generated keys get config published (random keys = no monitoring)

## Build

```bash
cd apk && bash build-apk.sh
```
