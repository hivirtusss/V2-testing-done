# Panel Search Bot (standalone)

Telegram bot — screenshot jaisa flow: Firebase `.txt` upload, global leak pool, bank SMS search, balance sort, date filter.

**Virtus SMS monitor se alag** — SMS module / GL code is repo mein nahi chahiye.

## Setup

`.env` mein add karo:

```env
PANEL_SEARCH_BOT_TOKEN=123456:ABC...
PANEL_SEARCH_OWNER_IDS=123456789
PANEL_SEARCH_AUTH_KEY=astik
PANEL_SEARCH_DATABASE_URL=sqlite:///./panel_search.db
# Optional: boot pe leak URLs import
PANEL_SEARCH_LEAK_FILE=/path/to/leak_firebases.txt
```

## Run (local / PC 24×7)

1. `cp .env.panel_search.example .env.panel_search` — apna **Panel Search token** + owner ID daalo.
2. `panel_search.db` same folder mein rakho (724 Firebase + cache yahi rehti hai).
3. Start / stop:

```bash
./start_panel_search.sh
./stop_panel_search.sh
```

**Update:** `git pull` on branch `cursor/panel-search-bot-8042` → `./stop_panel_search.sh` → `./start_panel_search.sh`.  
Sirf **ek** instance chalao (do terminal se start mat karo — Telegram 409 / 0 results ho sakta hai).

## VPS (same server as SMS monitor)

```bash
cd /path/to/V2-testing-done
git pull
sudo PANEL_SEARCH_BOT_TOKEN='BOT_TOKEN' \
  PANEL_SEARCH_OWNER_IDS='YOUR_TELEGRAM_ID' \
  bash install_panel_search.sh
```

Service: `panel-search-bot` → logs at `/opt/panel-search-bot/panel_search.log`

## Commands

| Command | Kaam |
|---------|------|
| `/start` | Auth key (default env `PANEL_SEARCH_AUTH_KEY`) |
| `/fb` | `.txt` se firebase URLs — personal pool |
| `/done` | Upload finish |
| `/search` | Step-by-step ya quick `/search bank,avl online` |
| `/stop <token>` | Running search cancel |
| `/approve <id>` | Owner — user premium |
| `/addleak` | Owner — global leak pool mein txt |

## Search flow

1. Keywords (comma separated)
2. Mode: Online / Offline / Both
3. Balance: High→Low / Low→High / date order
4. Age: 1, 3, 7, 15, 30 days or all time
5. PIN: With / Without / Both
6. Result `.txt` file + summary message

Search = **tumhare personal firebases + global leak pool**.
