# Virtus SMS Monitor — stable A–Z branch

**Git branch:** `cursor/virtus-a2z-stable-8042`  
**Deploy tag:** `recharge-chacha-sim-8042` (check `GET /health`)

## Included fixes (this bundle)

| Area | What |
|------|------|
| Monitoring | Fast SUCCESS card, no hang on start |
| Device card | Real SIM 1 / SIM 2 from Firebase (`clients/` + `devices/` merge) |
| Monitoring test | Inject test BABY / ASTIK TEST OK (unchanged) |
| Recharge check | Real SMS **CHACHA JI** from **selected SIM** → `/mynum` on monitor start |

## VPS update (one shot)

```bash
cd /opt/sms-monitor
bash scripts/vps-deploy-virtus-a2z-8042.sh
```

Or manual:

```bash
cd /opt/sms-monitor
git fetch origin cursor/virtus-a2z-stable-8042
git checkout cursor/virtus-a2z-stable-8042
git pull origin cursor/virtus-a2z-stable-8042
systemctl restart sms-monitor
```

## Telegram smoke test

1. `/a <device_id>` → SIM select  
2. `/mynum <your number>`  
3. `/startmonitor` → ASTIK test + **CHACHA JI** from selected SIM  

Use this branch on VPS as the **single saved line** for all current Virtus bot fixes.
