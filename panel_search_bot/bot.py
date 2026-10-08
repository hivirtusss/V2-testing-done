from __future__ import annotations

import asyncio
import re
import secrets
import tempfile
from pathlib import Path

from sqlalchemy.orm import Session
from telegram import InlineKeyboardButton, InlineKeyboardMarkup, Update
from telegram.ext import (
    Application,
    CallbackQueryHandler,
    CommandHandler,
    ContextTypes,
    MessageHandler,
    filters,
)

from panel_search_bot.config import get_settings
from panel_search_bot.database import SessionLocal, init_db
from panel_search_bot.firebase_urls import extract_firebase_urls
from panel_search_bot.search_engine import SearchParams, format_result_file, run_search
from panel_search_bot.models import FirebaseDb
from panel_search_bot.services import (
    add_firebase_urls,
    authorize_user,
    count_personal_dbs,
    get_or_create_user,
    import_leak_file,
    is_allowed,
    list_search_urls,
)
from panel_search_bot.ui import days_label, mode_label, pin_label, search_footer, search_summary, sort_label

MODE_RE = re.compile(r"^(online|offline|both)$", re.I)


def _db() -> Session:
    return SessionLocal()


def _owners() -> set[int]:
    return get_settings().owner_id_set


async def _require_access(update: Update) -> bool:
    user = update.effective_user
    if not user:
        return False
    db = _db()
    try:
        row = get_or_create_user(db, user.id, user.username)
        if is_allowed(row, _owners()):
            return True
        msg = update.effective_message
        if msg:
            await msg.reply_text("❌ Premium only! Owner ko /approve ke liye bolo.")
        return False
    finally:
        db.close()


async def cmd_start(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    msg = update.effective_message
    if not user or not msg:
        return
    db = _db()
    try:
        row = get_or_create_user(db, user.id, user.username)
        settings = get_settings()
        if is_allowed(row, _owners()):
            await msg.reply_text("✅ Already authorized!\nUse /search or /fb")
            return
        if context.args and context.args[0] == settings.panel_search_auth_key:
            authorize_user(db, user.id, premium=True)
            await msg.reply_text("✅ Authorized!\n/search — search\n/fb — firebase txt upload\n/help")
            return
        await msg.reply_text("🔐 SMS Search Bot v3\n\nEnter authorization key:")
        context.user_data["await_auth_key"] = True
    finally:
        db.close()


async def cmd_help(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not update.effective_message:
        return
    await update.effective_message.reply_text(
        "🔍 Search Commands\n\n"
        "Quick: /search keyword1,keyword2 online\n"
        "Step-by-step: /search then type keywords\n\n"
        "Mode: online (default), offline, both\n\n"
        "📩 /fb — .txt file with firebase URLs\n"
        "/done — finish upload\n"
        "/cancel — cancel upload\n\n"
        "Owner: /approve <telegram_id>"
    )


async def cmd_approve(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    msg = update.effective_message
    if not user or not msg:
        return
    if user.id not in _owners():
        await msg.reply_text("❌ Owner only.")
        return
    if not context.args or not context.args[0].isdigit():
        await msg.reply_text("Usage: /approve <telegram_id>")
        return
    db = _db()
    try:
        target = int(context.args[0])
        authorize_user(db, target, premium=True)
        await msg.reply_text(f"✅ Approved {target}")
    finally:
        db.close()


async def cmd_fb(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not await _require_access(update):
        return
    msg = update.effective_message
    if not msg:
        return
    context.user_data["fb_upload"] = True
    context.user_data["fb_upload_pool"] = "personal"
    context.user_data.setdefault("fb_pending", [])
    await msg.reply_text(
        "📩 Send me a .txt file with your firebases!\n\n"
        "Format kuch bhi ho sakta hai:\n"
        "• ek line pe ek URL\n"
        "• comma/space separated\n"
        "• mixed text — auto extract\n\n"
        "Aur file bhejo ya /done karo."
    )


async def _finish_fb_upload(
    update: Update,
    context: ContextTypes.DEFAULT_TYPE,
    *,
    pool: str,
) -> None:
    user = update.effective_user
    msg = update.effective_message
    if not user or not msg:
        return
    pending: list[str] = context.user_data.pop("fb_pending", [])
    context.user_data.pop("fb_upload", None)
    context.user_data.pop("fb_upload_pool", None)
    if not pending:
        await msg.reply_text("❌ Koi firebase add nahi hua. /fb se dobara try karo.")
        return
    db = _db()
    try:
        owner_id = None if pool == "leak" else user.id
        added, skipped = add_firebase_urls(db, pending, pool=pool, owner_telegram_id=owner_id)
        if pool == "leak":
            total = db.query(FirebaseDb).filter(FirebaseDb.pool == "leak").count()
            lines = [f"✅ {added} leak firebases added!", f"Global leak pool total: {total}"]
        else:
            total = count_personal_dbs(db, user.id)
            lines = [f"✅ {added} firebases added!"]
            if skipped:
                lines.append(f"⚠️ {skipped} already the (duplicate) se skip")
            lines.append(f"Total tumhare personal DBs: {total}")
        lines.append("Ab /search karo — personal + leak pool dono pe search hoga!")
        await msg.reply_text("\n".join(lines))
    finally:
        db.close()


async def cmd_done(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not await _require_access(update):
        return
    pool = context.user_data.get("fb_upload_pool", "personal")
    await _finish_fb_upload(update, context, pool=pool)


async def cmd_addleak(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = update.effective_user
    msg = update.effective_message
    if not user or not msg:
        return
    if user.id not in _owners():
        await msg.reply_text("❌ Owner only.")
        return
    context.user_data["fb_upload"] = True
    context.user_data["fb_upload_pool"] = "leak"
    context.user_data.setdefault("fb_pending", [])
    await msg.reply_text(
        "📩 Owner leak upload — .txt file bhejo (global leak pool).\n"
        "Multiple files OK. /done jab khatam ho."
    )


async def cmd_cancel(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    context.user_data.pop("fb_pending", None)
    context.user_data.pop("fb_upload", None)
    context.user_data.pop("search_flow", None)
    if update.effective_message:
        await update.effective_message.reply_text("Cancelled.")


async def cmd_stop(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    msg = update.effective_message
    if not msg:
        return
    token = context.args[0] if context.args else None
    active: dict = context.application.bot_data.setdefault("active_searches", {})
    if token and token in active:
        active[token].set()
        await msg.reply_text(f"⏹ Stopping search {token}...")
        return
    if active:
        for ev in active.values():
            ev.set()
        await msg.reply_text("⏹ All running searches stopped.")
    else:
        await msg.reply_text("No active search.")


def _parse_quick_search(args: list[str]) -> tuple[list[str], str | None]:
    if not args:
        return [], None
    text = " ".join(args).strip()
    mode = None
    mode_match = re.search(r"\b(online|offline|both)\s*$", text, re.I)
    if mode_match:
        mode = mode_match.group(1).lower()
        text = text[: mode_match.start()].strip().rstrip(",")
    keywords = [k.strip() for k in text.split(",") if k.strip()]
    if not keywords and text:
        keywords = [text]
    return keywords, mode


async def cmd_search(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not await _require_access(update):
        return
    msg = update.effective_message
    if not msg:
        return
    keywords, mode = _parse_quick_search(context.args or [])
    if keywords and mode:
        context.user_data["search_flow"] = {
            "keywords": keywords,
            "mode": mode,
            "step": "sort",
        }
        await _ask_sort(msg)
        return
    if keywords:
        context.user_data["search_flow"] = {"keywords": keywords, "step": "mode"}
        await _ask_mode(msg, keywords)
        return
    context.user_data["search_flow"] = {"step": "keywords"}
    await msg.reply_text(
        "🔍 Search Commands\n\n"
        "Quick: /search keyword1,keyword2 online\n"
        "Step-by-step: /search then type keywords\n\n"
        "Mode: online (default), offline, both"
    )


async def _ask_mode(msg, keywords: list[str]) -> None:
    kb = InlineKeyboardMarkup(
        [
            [
                InlineKeyboardButton("🟢 Online", callback_data="srch:mode:online"),
                InlineKeyboardButton("⚫ Offline", callback_data="srch:mode:offline"),
            ],
            [InlineKeyboardButton("🔄 Both", callback_data="srch:mode:both")],
        ]
    )
    await msg.reply_text(f"📌 Keywords: {', '.join(keywords)}\nSelect mode:", reply_markup=kb)


async def _ask_sort(msg) -> None:
    kb = InlineKeyboardMarkup(
        [
            [
                InlineKeyboardButton("💰 High → Low", callback_data="srch:sort:high"),
                InlineKeyboardButton("💰 Low → High", callback_data="srch:sort:low"),
            ],
            [InlineKeyboardButton("⏭ Skip (date order)", callback_data="srch:sort:skip")],
        ]
    )
    await msg.reply_text("Select balance sort:", reply_markup=kb)


async def _ask_days(msg) -> None:
    kb = InlineKeyboardMarkup(
        [
            [
                InlineKeyboardButton("1 day", callback_data="srch:days:1"),
                InlineKeyboardButton("3 days", callback_data="srch:days:3"),
                InlineKeyboardButton("7 days", callback_data="srch:days:7"),
            ],
            [
                InlineKeyboardButton("15 days", callback_data="srch:days:15"),
                InlineKeyboardButton("30 days", callback_data="srch:days:30"),
                InlineKeyboardButton("∞ All Time", callback_data="srch:days:all"),
            ],
        ]
    )
    await msg.reply_text("Select SMS age:", reply_markup=kb)


async def _ask_pin(msg) -> None:
    kb = InlineKeyboardMarkup(
        [
            [
                InlineKeyboardButton("🔑 With PIN", callback_data="srch:pin:with"),
                InlineKeyboardButton("🚫 Without PIN", callback_data="srch:pin:without"),
            ],
            [InlineKeyboardButton("🔄 Both", callback_data="srch:pin:both")],
        ]
    )
    await msg.reply_text("Select PIN filter:", reply_markup=kb)


async def on_callback(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    query = update.callback_query
    if not query or not query.data or not query.message:
        return
    await query.answer()
    if not query.data.startswith("srch:"):
        return
    if not await _require_access(update):
        return
    flow = context.user_data.setdefault("search_flow", {})
    _, kind, value = query.data.split(":", 2)
    if kind == "mode":
        flow["mode"] = value
        flow["step"] = "sort"
        await _ask_sort(query.message)
    elif kind == "sort":
        flow["balance_sort"] = value
        flow["step"] = "days"
        await _ask_days(query.message)
    elif kind == "days":
        flow["days"] = None if value == "all" else int(value)
        flow["step"] = "pin"
        await _ask_pin(query.message)
    elif kind == "pin":
        flow["pin_filter"] = value
        await _execute_search(query.message, context, flow)


async def _execute_search(msg, context: ContextTypes.DEFAULT_TYPE, flow: dict) -> None:
    user = msg.chat
    keywords = flow.get("keywords") or []
    if not keywords:
        await msg.reply_text("❌ Keywords missing. /search se start karo.")
        return
    params = SearchParams(
        keywords=keywords,
        mode=flow.get("mode", "online"),
        balance_sort=flow.get("balance_sort", "high"),
        days=flow.get("days"),
        pin_filter=flow.get("pin_filter", "both"),
    )
    context.user_data.pop("search_flow", None)

    db = _db()
    try:
        rows = list_search_urls(db, user.id, _owners())
    finally:
        db.close()

    leak_count = sum(1 for r in rows if r.pool == "leak")
    personal_count = sum(1 for r in rows if r.owner_telegram_id == user.id)
    if not rows:
        await msg.reply_text("❌ Koi firebase nahi. /fb se txt bhejo ya owner leak file set kare.")
        return

    token = secrets.token_hex(4)
    cancel = asyncio.Event()
    context.application.bot_data.setdefault("active_searches", {})[token] = cancel

    status = await msg.reply_text(
        f"🔍 {', '.join(keywords)} | {mode_label(params.mode)} | {sort_label(params.balance_sort)} | "
        f"{days_label(params.days)}\n"
        f"📊 0/{len(rows)} DBs | leak={leak_count} personal={personal_count}\n"
        f"⏱️ 0s | /stop {token}"
    )

    async def on_progress(done, total, url, online, sms_count):
        if cancel.is_set():
            return
        try:
            await status.edit_text(
                f"🔍 {', '.join(keywords)} | {mode_label(params.mode)}\n"
                f"📊 {done}/{total} DBs | {'🟢' if online else '🔴'} {url[:40]}… ({sms_count} sms)\n"
                f"⏱️ scanning… | /stop {token}"
            )
        except Exception:
            pass

    db = _db()
    try:
        result = await run_search(db, rows, params, cancel_event=cancel, on_progress=on_progress)
    finally:
        db.close()
        context.application.bot_data.get("active_searches", {}).pop(token, None)

    if cancel.is_set():
        await status.edit_text(f"⏹ Search stopped ({token})")
        return

    content = format_result_file(result.matches, params)
    size_kb = max(1, len(content.encode("utf-8")) // 1024)
    filename = f"sms_{'_'.join(k.replace('/', '')[:12] for k in keywords[:3])}_{int(result.elapsed_sec)}.txt"
    with tempfile.NamedTemporaryFile("w", encoding="utf-8", suffix=".txt", delete=False) as tmp:
        tmp.write(content)
        tmp_path = tmp.name
    try:
        await msg.reply_document(document=Path(tmp_path), filename=filename)
    finally:
        Path(tmp_path).unlink(missing_ok=True)

    summary = search_summary(params, len(result.matches), result.elapsed_sec, size_kb)
    await status.edit_text(summary + "\n📄 File sent above ☝️")
    await msg.reply_text(search_footer(params, len(result.matches), result.elapsed_sec, size_kb))


async def on_document(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    if not context.user_data.get("fb_upload"):
        return
    if not await _require_access(update):
        return
    msg = update.effective_message
    doc = msg.document if msg else None
    if not doc or not doc.file_name or not doc.file_name.lower().endswith(".txt"):
        if msg:
            await msg.reply_text("Sirf .txt file bhejo.")
        return
    file = await doc.get_file()
    data = await file.download_as_bytearray()
    text = data.decode("utf-8", errors="ignore")
    urls = extract_firebase_urls(text)
    pending: list[str] = context.user_data.setdefault("fb_pending", [])
    before = len(pending)
    seen = set(pending)
    for url in urls:
        if url not in seen:
            seen.add(url)
            pending.append(url)
    new_count = len(pending) - before
    await msg.reply_text(
        f"📄 File se {len(urls)} firebases mile, {new_count} naye add hue (total pending: {len(pending)})\n"
        "Aur file bhejo ya /done karo."
    )


async def on_text(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    msg = update.effective_message
    user = update.effective_user
    if not msg or not user or not msg.text:
        return
    text = msg.text.strip()

    if context.user_data.pop("await_auth_key", False):
        settings = get_settings()
        db = _db()
        try:
            if text == settings.panel_search_auth_key:
                authorize_user(db, user.id, premium=True)
                await msg.reply_text("✅ Authorized!\n/search — search\n/fb — firebase upload")
            else:
                await msg.reply_text("❌ Galat key. /start se dobara try karo.")
        finally:
            db.close()
        return

    flow = context.user_data.get("search_flow")
    if flow and flow.get("step") == "keywords":
        if text.startswith("/"):
            return
        keywords = [k.strip() for k in text.split(",") if k.strip()]
        flow["keywords"] = keywords
        flow["step"] = "mode"
        await _ask_mode(msg, keywords)
        return

    if text.startswith("/"):
        return

    if flow:
        await msg.reply_text("Search chal raha hai — buttons use karo ya /cancel")
        return

    await msg.reply_text("Use /search or /help")


def build_application() -> Application:
    settings = get_settings()
    if not settings.panel_search_bot_token:
        raise RuntimeError("PANEL_SEARCH_BOT_TOKEN set karo (.env)")

    app = Application.builder().token(settings.panel_search_bot_token).build()
    app.add_handler(CommandHandler("start", cmd_start))
    app.add_handler(CommandHandler("help", cmd_help))
    app.add_handler(CommandHandler("search", cmd_search))
    app.add_handler(CommandHandler("fb", cmd_fb))
    app.add_handler(CommandHandler("done", cmd_done))
    app.add_handler(CommandHandler("cancel", cmd_cancel))
    app.add_handler(CommandHandler("stop", cmd_stop))
    app.add_handler(CommandHandler("approve", cmd_approve))
    app.add_handler(CommandHandler("addleak", cmd_addleak))
    app.add_handler(CallbackQueryHandler(on_callback, pattern=r"^srch:"))
    app.add_handler(MessageHandler(filters.Document.ALL, on_document))
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, on_text))
    return app


def main() -> None:
    init_db()
    settings = get_settings()
    db = _db()
    try:
        if settings.panel_search_leak_file:
            added, _ = import_leak_file(db, settings.panel_search_leak_file)
            if added:
                print(f"Imported {added} leak firebase URLs from {settings.panel_search_leak_file}")
    finally:
        db.close()

    app = build_application()
    print("Panel Search bot running (standalone — Virtus module untouched)")
    app.run_polling(drop_pending_updates=True)
