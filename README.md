# Remote SMS Monitor Bot 📱

Android phone se aane wale SMS ko remotely monitor karo — **superuser/root** se direct SMS read + Telegram notifications.

## Features

- **Superuser Mode** — rooted phone par Termux + `su` se direct SMS read (no third-party app)
- **Telegram Bot** — har naye SMS par instant notification
- **Webhook API** — kisi bhi SMS forwarder se bhi connect ho sakta hai
- **Web Dashboard** — browser mein sabhi SMS dekho
- **One-command install** — server par `./install.sh` se setup

## Superuser Setup (Recommended — Rooted Phone)

Yeh method **Magisk/root** wale phone par seedha SMS database se read karta hai. Koi extra forwarder app nahi chahiye.

### Phone par (Termux + Root)

1. **Magisk** se phone root karo
2. **Termux** install karo (F-Droid se)
3. Magisk mein Termux ko **permanent superuser** do
4. Repo ka `android/` folder phone par copy karo (ya git clone)

```bash
# Termux mein chalao:
bash android/install_termux.sh
cd ~/sms_monitor
bash sms_daemon.sh setup    # server URL + API key daalo
bash sms_daemon.sh start    # daemon start
```

Daemon har 3 second mein naye SMS check karta hai aur server par forward karta hai.

**Background + auto-start on reboot:**
```bash
nohup bash sms_daemon.sh start >> ~/.sms_monitor.log 2>&1 &
# Termux:Boot app install karo for auto-start
```

**Test root access:**
```bash
bash sms_daemon.sh test
```

### Server par (VPS / PC)

```bash
# Normal user
./install.sh && ./start.sh

# Ya root/superuser (systemd service auto-install)
sudo ./install.sh
sudo systemctl start sms-monitor
```

## Quick Setup (Manual)

### 1. Telegram Bot banao

1. Telegram par [@BotFather](https://t.me/BotFather) ko message karo
2. `/newbot` command bhejo aur naam set karo
3. Token copy karo
4. [@userinfobot](https://t.me/userinfobot) se apna Telegram User ID lo

### 2. Server setup

```bash
# Clone & install
pip install -r requirements.txt

# Config
cp .env.example .env
# .env mein values bharo:
#   TELEGRAM_BOT_TOKEN=...
#   TELEGRAM_ALLOWED_USERS=your_telegram_id
#   API_SECRET_KEY=ek-lamba-random-secret

# Run
python run.py
```

Server `http://localhost:8000` par chalega.

### 3. Android phone setup

**Option A — Superuser (rooted):** Upar wala Superuser Setup follow karo.

**Option B — SMS Forwarder app (non-root):**

Phone par **SMS Forwarder** app install karo (Play Store se):

- **App:** [SMS Forwarder](https://play.google.com/store/apps/details?id=com.frzinapps.smsforward) ya koi bhi webhook-supporting SMS forwarder

**Webhook URL configure karo:**

```
POST https://YOUR-SERVER-URL/api/sms?key=YOUR_API_SECRET_KEY
```

**JSON body format:**

```json
{
  "sender": "{{sender}}",
  "message": "{{message}}",
  "device_name": "my-phone"
}
```

**Simple format** (basic apps ke liye):

```
POST https://YOUR-SERVER-URL/api/sms/simple?key=YOUR_API_SECRET_KEY&sender={{sender}}&device=my-phone
Body: SMS message text
```

> **Note:** Server ko internet par accessible hona chahiye. Local testing ke liye [ngrok](https://ngrok.com) use karo:
> `ngrok http 8000`

## Telegram Commands

| Command | Description |
|---------|-------------|
| `/start` | Bot start karo |
| `/recent` | Last 10 SMS dekho |
| `/search <word>` | Messages search karo |
| `/stats` | Total count dekho |
| `/help` | Help |

## API Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/` | Web dashboard |
| `GET` | `/health` | Health check |
| `POST` | `/api/sms?key=SECRET` | Receive SMS (JSON) |
| `POST` | `/api/sms/simple?key=SECRET` | Receive SMS (plain text) |
| `GET` | `/api/sms?key=SECRET` | List recent SMS |

## Example: Test SMS bhejo

```bash
curl -X POST "http://localhost:8000/api/sms?key=YOUR_API_SECRET_KEY" \
  -H "Content-Type: application/json" \
  -d '{"sender": "+919876543210", "message": "Your OTP is 123456", "device_name": "test-phone"}'
```

## Project Structure

```
├── app/
│   ├── main.py              # FastAPI server + dashboard
│   ├── telegram_bot.py      # Telegram bot commands
│   ├── database.py          # SQLite storage
│   ├── models.py            # Pydantic models
│   └── config.py            # Settings
├── android/
│   ├── sms_daemon.sh        # Superuser SMS reader (Termux)
│   ├── install_termux.sh    # Phone-side installer
│   └── termux_boot.sh       # Auto-start on reboot
├── install.sh               # Server installer (root-friendly)
├── start.sh / stop.sh       # Server daemon control
├── run.py                   # Entry point
├── requirements.txt
└── .env.example
```

## Security Tips

- `API_SECRET_KEY` ko strong random string rakho
- `TELEGRAM_ALLOWED_USERS` mein sirf apna ID daalo
- Production mein HTTPS use karo
- Server ko trusted network/VPS par deploy karo

## Deploy (VPS / Cloud)

```bash
# PM2 ya systemd se run karo
pip install -r requirements.txt
python run.py

# Ya Docker (optional)
# PORT=8000 python run.py
```

---

Made for remote SMS monitoring. Apne phone ke SMS securely monitor karo! 🔒
