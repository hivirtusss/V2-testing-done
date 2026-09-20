import logging
from contextlib import asynccontextmanager
from datetime import datetime, timezone

from fastapi import Depends, FastAPI, HTTPException, Query, Request
from fastapi.responses import HTMLResponse
from sqlalchemy.orm import Session

from app.config import get_settings
from app.database import SMSMessage, get_db, init_db
from app.models import SMSResponse, SMSWebhookPayload
from app.telegram_bot import build_telegram_app, notify_new_sms

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
settings = get_settings()


@asynccontextmanager
async def lifespan(app: FastAPI):
    init_db()
    telegram_app = build_telegram_app()
    polling_task = None

    if telegram_app:
        await telegram_app.initialize()
        await telegram_app.start()
        await telegram_app.updater.start_polling(drop_pending_updates=True)
        logger.info("Telegram bot started")

    yield

    if telegram_app:
        await telegram_app.updater.stop()
        await telegram_app.stop()
        await telegram_app.shutdown()
        logger.info("Telegram bot stopped")


app = FastAPI(
    title="Remote SMS Monitor Bot",
    description="Webhook API + Telegram bot for remote SMS monitoring",
    version="1.0.0",
    lifespan=lifespan,
)


def verify_api_key(key: str = Query(..., alias="key")) -> None:
    if key != settings.api_secret_key:
        raise HTTPException(status_code=401, detail="Invalid API key")


@app.get("/", response_class=HTMLResponse)
async def dashboard(db: Session = Depends(get_db)):
    messages = (
        db.query(SMSMessage)
        .order_by(SMSMessage.received_at.desc())
        .limit(50)
        .all()
    )
    total = db.query(SMSMessage).count()

    rows = ""
    for sms in messages:
        time_str = sms.received_at.astimezone(timezone.utc).strftime("%d %b %Y %H:%M")
        safe_msg = sms.message.replace("<", "&lt;").replace(">", "&gt;")
        rows += f"""
        <tr>
            <td>{time_str}</td>
            <td><code>{sms.device_name}</code></td>
            <td><strong>{sms.sender}</strong></td>
            <td>{safe_msg}</td>
        </tr>"""

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SMS Monitor Dashboard</title>
    <style>
        * {{ margin: 0; padding: 0; box-sizing: border-box; }}
        body {{ font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
                background: #0f172a; color: #e2e8f0; padding: 2rem; }}
        h1 {{ margin-bottom: 0.5rem; color: #38bdf8; }}
        .stats {{ color: #94a3b8; margin-bottom: 2rem; }}
        table {{ width: 100%; border-collapse: collapse; background: #1e293b; border-radius: 8px; overflow: hidden; }}
        th {{ background: #334155; padding: 12px; text-align: left; font-size: 0.85rem; }}
        td {{ padding: 12px; border-top: 1px solid #334155; font-size: 0.9rem; word-break: break-word; }}
        tr:hover {{ background: #273549; }}
        code {{ background: #0f172a; padding: 2px 6px; border-radius: 4px; }}
        .empty {{ text-align: center; padding: 3rem; color: #64748b; }}
    </style>
</head>
<body>
    <h1>📱 SMS Monitor Dashboard</h1>
    <p class="stats">Total messages: <strong>{total}</strong></p>
    {"<table><thead><tr><th>Time</th><th>Device</th><th>From</th><th>Message</th></tr></thead><tbody>" + rows + "</tbody></table>" if messages else '<p class="empty">No SMS messages yet. Configure your Android forwarder to start monitoring.</p>'}
</body>
</html>"""


@app.get("/health")
async def health():
    return {"status": "ok", "telegram_configured": bool(settings.telegram_bot_token)}


@app.post("/api/sms", response_model=SMSResponse)
async def receive_sms(
    payload: SMSWebhookPayload,
    _: None = Depends(verify_api_key),
    db: Session = Depends(get_db),
):
    sms = SMSMessage(
        sender=payload.sender,
        message=payload.message,
        device_name=payload.device_name,
        received_at=payload.timestamp or datetime.now(timezone.utc),
    )
    db.add(sms)
    db.commit()
    db.refresh(sms)

    try:
        await notify_new_sms(sms)
    except Exception as exc:
        logger.error("Telegram notification failed: %s", exc)

    logger.info("SMS received from %s on %s", sms.sender, sms.device_name)
    return sms


@app.post("/api/sms/simple")
async def receive_sms_simple(
    request: Request,
    key: str = Query(...),
    sender: str = Query(default="unknown"),
    device: str = Query(default="android"),
    db: Session = Depends(get_db),
):
    """Simple GET/POST endpoint for basic SMS forwarder apps."""
    if key != settings.api_secret_key:
        raise HTTPException(status_code=401, detail="Invalid API key")

    body = await request.body()
    message = body.decode("utf-8").strip() if body else ""

    if not message:
        form = await request.form()
        message = str(form.get("message", form.get("text", "")))

    if not message:
        raise HTTPException(status_code=400, detail="Message body required")

    sms = SMSMessage(sender=sender, message=message, device_name=device)
    db.add(sms)
    db.commit()
    db.refresh(sms)

    try:
        await notify_new_sms(sms)
    except Exception as exc:
        logger.error("Telegram notification failed: %s", exc)

    return {"ok": True, "id": sms.id}


@app.get("/api/sms", response_model=list[SMSResponse])
async def list_sms(
    _: None = Depends(verify_api_key),
    db: Session = Depends(get_db),
    limit: int = Query(default=20, le=100),
    sender: str | None = None,
):
    query = db.query(SMSMessage).order_by(SMSMessage.received_at.desc())
    if sender:
        query = query.filter(SMSMessage.sender == sender)
    return query.limit(limit).all()
