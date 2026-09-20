# Virtus SMS Module APK

Rebranded from Astik SMS Module — connects to Telegram bot via Firebase.

## How It Works

1. **Bot**: `/key https://your-firebase.firebaseio.com` sets license key
2. **APK**: Enter same Firebase URL in Virtus app → START SERVICE
3. **Bot**: `/fy <device_id>` → SIM → `/addchannel` → `/mynum` → `/startmonitor`
4. **Channel SMS** → Firebase `messages/{device_id}/` → APK injects with same sender ID

## Firebase Structure

```
{your-firebase}/
  virtus_config.json       ← monitoring, device_id, firebase_url
  messages/{device_id}/    ← inject queue (sender, body, injected)
  devices/{device_id}/     ← device heartbeat
```

## Install APK

```bash
# Signed APK location:
apk/virtus-sms-module.apk
```

1. Install on rooted Android phone
2. Grant SMS + notification permissions
3. Enter Firebase URL (same as `/key` in bot)
4. Toggle **START SERVICE** ON
5. Press **TEST INJECTION** — inbox mein `BABY` se `ASTIK TEST OK — module alive` aayega
6. Bot `/startmonitor` par `Chacha Jii Pani Pila Do` test SMS bhejta hai

## Requirements

- Rooted phone (Magisk) for SMS injection
- LSPosed optional (xposed_init present but MainHook not required for core flow)
- Internet access for Firebase polling

## Build From Source

```bash
/workspace/apktool b apk/virtus_decompiled -o virtus_unsigned.apk
jarsigner -keystore virtus.keystore virtus_unsigned.apk virtus
```
