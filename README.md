# Remote SMS Monitor Bot 📱

Android phone se aane wale SMS ko remotely monitor karo — Telegram bot notifications + web dashboard ke saath.

## Features

- **Telegram Bot** — har naye SMS par instant notification
- **Webhook API** — Android SMS forwarder apps se connect
- **Web Dashboard** — browser mein sabhi SMS dekho
- **Search** — Telegram mein `/search otp` se OTP dhundho
- **Secure** — API key authentication

## Quick Setup

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
│   ├── main.py          # FastAPI server + dashboard
│   ├── telegram_bot.py  # Telegram bot commands
│   ├── database.py      # SQLite storage
│   ├── models.py        # Pydantic models
│   └── config.py        # Settings
├── run.py               # Entry point
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
