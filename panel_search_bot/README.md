# Panel Search Bot (standalone)

Telegram bot — screenshot jaisa flow: Firebase `.txt` upload, global leak pool, bank SMS search, balance sort, date filter.

**Virtus module / Virtus GL se alag** — un folders mein koi change nahi chahiye.

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

## Run

```bash
python3 -m panel_search_bot.run_bot
```

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
