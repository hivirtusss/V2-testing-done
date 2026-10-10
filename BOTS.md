# 3 bots — alag env, alag token (mix mat karo)

| Bot | Config file | Start |
|-----|-------------|--------|
| **SMS Monitor (Virtus APK)** | root `.env` → `TELEGRAM_BOT_TOKEN` | `./start.sh` |
| **Aadhaar (Virtus doc)** | `.env.aadhaar` → `AADHAAR_BOT_TOKEN` | `./start_aadhaar_bot.sh` |
| **Panel Search** | `_run/panel-search/.env.panel_search` | `cd _run/panel-search && ./start_panel_search.sh` |

Stop side bots (Panel + Aadhaar process): `./stop_side_bots.sh`  
SMS stop: `./stop.sh`

Aadhaar code sirf `aadhaar_bot/` — Virtus SMS / Panel code touch mat karo.
