from __future__ import annotations

import asyncio
import io
import re
import time
from enum import Enum

from telegram import InlineKeyboardButton, InlineKeyboardMarkup, Update
from telegram.ext import (
    Application,
    CallbackQueryHandler,
    CommandHandler,
    ContextTypes,
    MessageHandler,
    filters,
)

from aadhaar_bot.config import get_settings
from aadhaar_bot.database import db_session, init_db
from aadhaar_bot.name_utils import prepare_holder_name
from aadhaar_bot.services import (
    add_credits,
    approve_user,
    can_use_bot,
    consume_credit,
    get_or_create_user,
    is_owner,
    plan_line,
    revoke_user,
)
from aadhaar_bot.ui_dynamo import (
    DEV_LINE,
    bridge_down_text,
    find_record_otp_pending,
    holder_name_prompt,
    record_not_found_text,
    run_search_with_verify,
    safe_edit,
    step_header,
    verify_timeout_text,
)
from aadhaar_bot.pdf_worker import unlock_pdf
from aadhaar_bot.uidai_client import UidaiBackend

MOBILE_RE = re.compile(r"^\d{10}$")
OTP_RE = re.compile(r"^\d{6}$")

CB_GET = "aadhaar:get"
CB_PLANS = "aadhaar:plans"
CB_HELP = "aadhaar:help"
CB_GENDER_M = "aadhaar:gender:m"
CB_GENDER_F = "aadhaar:gender:f"
CB_NAME_MANUAL = "aadhaar:name_manual"
CB_DL_PDF = "aadhaar:dl_pdf"
CB_ANOTHER = "aadhaar:another"


class Step(str, Enum):
    IDLE = "idle"
    MOBILE = "mobile"
    GENDER = "gender"
    NAME = "name"
    OTP1 = "otp1"
    OTP2 = "otp2"


def _owners() -> set[int]:
    return get_settings().owner_id_set


def _backend(context: ContextTypes.DEFAULT_TYPE) -> UidaiBackend:
    if "uidai_backend" not in context.application.bot_data:
        context.application.bot_data["uidai_backend"] = UidaiBackend()
    return context.application.bot_data["uidai_backend"]


def _reset_flow(context: ContextTypes.DEFAULT_TYPE) -> None:
    for k in (
        "aadhaar_step",
        "aadhaar_mobile",
        "aadhaar_gender",
        "aadhaar_name",
        "aadhaar_name_query",
        "aadhaar_name_manual",
        "aadhaar_session",
        "aadhaar_started_at",
        "aadhaar_last_result",
    ):
        context.user_data.pop(k, None)
    context.user_data["aadhaar_step"] = Step.IDLE.value


def _step(context: ContextTypes.DEFAULT_TYPE) -> Step:
    raw = context.user_data.get("aadhaar_step", Step.IDLE.value)
    try:
        return Step(raw)
    except ValueError:
        return Step.IDLE


def _set_step(context: ContextTypes.DEFAULT_TYPE, step: Step) -> None:
    context.user_data["aadhaar_step"] = step.value


def _welcome_text(active_plan_line: str) -> str:
    return (
        "╭──────────────────────╮\n"
        "│ **Dynamo DocumentBot**\n"
        "╰──────────────────────╯\n\n"
        f"{active_plan_line}\n\n"
        "👇 Choose an option:\n\n"
        f"{DEV_LINE}"
    )


def _welcome_keyboard() -> InlineKeyboardMarkup:
    return InlineKeyboardMarkup(
        [
            [InlineKeyboardButton("📄 Get Aadhaar", callback_data=CB_GET)],
            [
                InlineKeyboardButton("💳 Plans", callback_data=CB_PLANS),
                InlineKeyboardButton("💬 Payment & help ↗️", callback_data=CB_HELP),
            ],
        ]
    )


def _cancel_footer() -> str:
    return "\n\n⭐ Cancel Anytime :- /cancel"


def _telegram_user(update: Update):
    return update.effective_user


async def _access_denied(update: Update, row) -> None:
    owners = _owners()
    if not row.approved and not is_owner(row.telegram_id, owners):
        text = (
            "🔒 **Access denied**\n\nSirf owner approve ke baad bot use ho sakta hai.\n"
            "Owner ko apna Telegram ID bhejo."
        )
    else:
        text = (
            f"🔒 **Credits khatam** ({row.credits} bache).\n\nOwner se `/addcredits` karwao."
        )
    q = update.callback_query
    if q and q.message:
        await q.message.reply_text(text, parse_mode="Markdown")
        return
    msg = update.effective_message
    if msg:
        await msg.reply_text(text, parse_mode="Markdown")


async def _reply_welcome(message, user_id: int, username: str | None) -> None:
    db = db_session()
    try:
        row = get_or_create_user(db, user_id, username)
        plan = plan_line(row, _owners())
    finally:
        db.close()
    await message.reply_text(
        _welcome_text(plan),
        parse_mode="Markdown",
        reply_markup=_welcome_keyboard(),
    )


async def _run_uidai_lookup(
    msg,
    context: ContextTypes.DEFAULT_TYPE,
    update: Update,
    mobile: str,
    gender: str,
    manual_name: bool,
    name_display: str,
    name_query: str,
) -> None:
    settings = get_settings()
    wait = await msg.reply_text(
        f"{step_header(3, 4, 'Find Record')}\n\n"
        "⌛ Initializing secure lookup…"
        + _cancel_footer(),
        parse_mode="Markdown",
    )
    backend = _backend(context)
    user = _telegram_user(update)
    ok_bridge, bridge_msg = await backend.ping_bridge()
    if not ok_bridge:
        await safe_edit(wait, bridge_down_text(bridge_msg), parse_mode="Markdown")
        _reset_flow(context)
        return
    try:
        search_ok, verified = await run_search_with_verify(
            wait,
            mobile,
            backend.verify_record(
                mobile,
                gender,
                name_display,
                name_query,
                manual_name=manual_name,
            ),
            name=name_display,
            timeout_sec=settings.aadhaar_verify_timeout,
        )
        if not search_ok:
            if verified is None:
                await safe_edit(
                    wait,
                    verify_timeout_text(int(settings.aadhaar_verify_timeout)),
                    parse_mode="Markdown",
                )
            elif isinstance(verified, Exception):
                await safe_edit(
                    wait,
                    f"❌ **Fail:** {verified}\n\n{DEV_LINE}",
                    parse_mode="Markdown",
                )
            _reset_flow(context)
            if user and not (verified is None):
                await _reply_welcome(msg, user.id, user.username)
            return
        if not verified.ok:
            await safe_edit(wait, record_not_found_text(), parse_mode="Markdown")
            _reset_flow(context)
            if user:
                await _reply_welcome(msg, user.id, user.username)
            return
        await safe_edit(
            wait,
            find_record_otp_pending(mobile, name_display),
            parse_mode="Markdown",
        )
        res = await backend.start_lookup(
            mobile,
            gender,
            name_display,
            name_query,
            manual_name=manual_name,
            preverified_session=verified.session_id,
        )
        if not res.ok:
            await safe_edit(wait, record_not_found_text(), parse_mode="Markdown")
            _reset_flow(context)
            if user:
                await _reply_welcome(msg, user.id, user.username)
            return
    except Exception as e:
        await safe_edit(wait, f"❌ **Fail:** {e}\n\n{DEV_LINE}", parse_mode="Markdown")
        _reset_flow(context)
        if user:
            await _reply_welcome(msg, user.id, user.username)
        return
    context.user_data["aadhaar_session"] = res.session_id
    _set_step(context, Step.OTP1)
    await safe_edit(
        wait,
        f"{step_header(3, 4, 'OTP 1')}\n\n"
        "🚀 **OTP 1 sent** — registered mobile par check karo.\n\n"
        "👇 6-digit OTP yahi chat me bhejo:\n\n"
        f"📱 `{mobile}`\n"
        f"👤 **{name_display}**"
        + _cancel_footer(),
        parse_mode="Markdown",
    )


async def _require_access(update: Update) -> bool:
    user = _telegram_user(update)
    if not user:
        return False
    db = db_session()
    try:
        row = get_or_create_user(db, user.id, user.username)
        if can_use_bot(row, _owners()):
            return True
        await _access_denied(update, row)
        return False
    finally:
        db.close()


async def cmd_start(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    msg = update.effective_message
    user = _telegram_user(update)
    if not msg or not user:
        return
    _reset_flow(context)
    db = db_session()
    try:
        row = get_or_create_user(db, user.id, user.username)
        plan = plan_line(row, _owners())
    finally:
        db.close()
    await msg.reply_text(
        _welcome_text(plan),
        parse_mode="Markdown",
        reply_markup=_welcome_keyboard(),
    )


async def cmd_credits(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    msg = update.effective_message
    user = _telegram_user(update)
    if not msg or not user:
        return
    db = db_session()
    try:
        row = get_or_create_user(db, user.id, user.username)
        await msg.reply_text(plan_line(row, _owners()), parse_mode="Markdown")
    finally:
        db.close()


async def cmd_approve(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = _telegram_user(update)
    msg = update.effective_message
    if not user or not msg:
        return
    if not is_owner(user.id, _owners()):
        await msg.reply_text("❌ Owner only.")
        return
    if not context.args or not context.args[0].isdigit():
        await msg.reply_text("Usage: /approve <telegram_id> [credits]")
        return
    tid = int(context.args[0])
    bonus = int(context.args[1]) if len(context.args) > 1 and context.args[1].isdigit() else 0
    db = db_session()
    try:
        row = approve_user(db, tid, credits=bonus)
        await msg.reply_text(
            f"✅ Approved `{tid}` — credits: **{row.credits}**",
            parse_mode="Markdown",
        )
    finally:
        db.close()


async def cmd_addcredits(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = _telegram_user(update)
    msg = update.effective_message
    if not user or not msg:
        return
    if not is_owner(user.id, _owners()):
        await msg.reply_text("❌ Owner only.")
        return
    if len(context.args) < 2 or not context.args[0].isdigit() or not context.args[1].isdigit():
        await msg.reply_text("Usage: /addcredits <telegram_id> <amount>")
        return
    tid = int(context.args[0])
    amount = int(context.args[1])
    db = db_session()
    try:
        row = add_credits(db, tid, amount)
        await msg.reply_text(
            f"✅ `{tid}` ab credits: **{row.credits}** (1 Aadhaar = 1 credit)",
            parse_mode="Markdown",
        )
    finally:
        db.close()


async def cmd_revoke(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    user = _telegram_user(update)
    msg = update.effective_message
    if not user or not msg:
        return
    if not is_owner(user.id, _owners()):
        await msg.reply_text("❌ Owner only.")
        return
    if not context.args or not context.args[0].isdigit():
        await msg.reply_text("Usage: /revoke <telegram_id>")
        return
    tid = int(context.args[0])
    db = db_session()
    try:
        revoke_user(db, tid)
        await msg.reply_text(f"🚫 Revoked `{tid}`", parse_mode="Markdown")
    finally:
        db.close()


async def cmd_cancel(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    msg = update.effective_message
    if not msg:
        return
    _reset_flow(context)
    await msg.reply_text("❌ Cancelled.\n/start se dubara shuru karo.")


async def on_plans_or_help(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    q = update.callback_query
    if not q:
        return
    await q.answer()
    if q.data == CB_PLANS:
        await q.edit_message_text(
            "💳 **Plans**\n\nOwner se contact karo — `@ifeelrichhh`",
            parse_mode="Markdown",
            reply_markup=InlineKeyboardMarkup(
                [[InlineKeyboardButton("« Back", callback_data="aadhaar:back_home")]]
            ),
        )
    elif q.data == CB_HELP:
        await q.edit_message_text(
            "💬 **Payment & help**\n\nSupport: `@ifeelrichhh` | Dynamo",
            parse_mode="Markdown",
            reply_markup=InlineKeyboardMarkup(
                [[InlineKeyboardButton("« Back", callback_data="aadhaar:back_home")]]
            ),
        )


async def on_back_home(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    q = update.callback_query
    if not q:
        return
    await q.answer()
    _reset_flow(context)
    user = _telegram_user(update)
    plan = "Your plan: **Unlimited** ✅"
    if user:
        db = db_session()
        try:
            row = get_or_create_user(db, user.id, user.username)
            plan = plan_line(row, _owners())
        finally:
            db.close()
    await q.edit_message_text(
        _welcome_text(plan),
        parse_mode="Markdown",
        reply_markup=_welcome_keyboard(),
    )


async def on_get_aadhaar(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    q = update.callback_query
    if not q:
        return
    await q.answer()
    if not await _require_access(update):
        return
    _reset_flow(context)
    _set_step(context, Step.MOBILE)
    await q.edit_message_text(
        f"{step_header(1, 4, 'Mobile')}\n\n"
        "👇 Apna **10 digit** mobile number type karke bhejo:"
        + _cancel_footer(),
        parse_mode="Markdown",
    )


async def on_gender(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    q = update.callback_query
    if not q or not q.data:
        return
    await q.answer()
    mobile = context.user_data.get("aadhaar_mobile", "")
    if q.data == CB_NAME_MANUAL:
        context.user_data["aadhaar_gender"] = "unspecified"
        context.user_data["aadhaar_name_manual"] = True
        _set_step(context, Step.NAME)
        await q.edit_message_text(
            holder_name_prompt(mobile, manual=True),
            parse_mode="Markdown",
        )
        return
    gender = "male" if q.data == CB_GENDER_M else "female"
    context.user_data["aadhaar_gender"] = gender
    context.user_data["aadhaar_name_manual"] = False
    _set_step(context, Step.NAME)
    emoji = "👦" if gender == "male" else "👧"
    await q.edit_message_text(
        f"{step_header(2, 4, 'Holder Name')}\n\n"
        f"{emoji} Gender · **{gender.title()}**\n\n"
        "👇 Type the **full name** exactly as printed on the card."
        f"\n\n📱 Mobile · `{mobile}`"
        + _cancel_footer(),
        parse_mode="Markdown",
    )


async def on_text(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    msg = update.effective_message
    if not msg or not msg.text:
        return
    text = msg.text.strip()
    step = _step(context)

    if step == Step.MOBILE:
        if not await _require_access(update):
            return
        if not MOBILE_RE.match(text):
            await msg.reply_text("❌ Sahi 10 digit mobile number bhejo.")
            return
        context.user_data["aadhaar_mobile"] = text
        _set_step(context, Step.GENDER)
        kb = InlineKeyboardMarkup(
            [
                [
                    InlineKeyboardButton("👦 Male", callback_data=CB_GENDER_M),
                    InlineKeyboardButton("👧 Female", callback_data=CB_GENDER_F),
                ],
                [InlineKeyboardButton("✏️ Enter Name Manually", callback_data=CB_NAME_MANUAL)],
            ]
        )
        await msg.reply_text(
            f"{step_header(2, 4, 'Gender')}\n\n"
            "👇 Select gender:\n\n"
            f"📱 Mobile · `{text}`"
            + _cancel_footer(),
            parse_mode="Markdown",
            reply_markup=kb,
        )
        return

    if step == Step.NAME:
        if not await _require_access(update):
            return
        if len(text) < 2:
            await msg.reply_text("❌ Name kam se kam 2 characters hona chahiye.")
            return
        mobile = context.user_data.get("aadhaar_mobile", "")
        gender = context.user_data.get("aadhaar_gender", "unspecified")
        manual_name = bool(context.user_data.get("aadhaar_name_manual"))
        name_display, name_query = prepare_holder_name(text)
        context.user_data["aadhaar_name"] = name_display
        context.user_data["aadhaar_name_query"] = name_query
        context.user_data["aadhaar_started_at"] = time.time()
        await _run_uidai_lookup(msg, context, update, mobile, gender, manual_name, name_display, name_query)
        return

    if step == Step.OTP1:
        if not OTP_RE.match(text):
            await msg.reply_text("❌ 6 digit OTP bhejo.")
            return
        session = context.user_data.get("aadhaar_session", "")
        mobile = context.user_data.get("aadhaar_mobile", "")
        backend = _backend(context)
        try:
            res = await backend.submit_otp1(session, text)
        except Exception as e:
            await msg.reply_text(f"❌ Backend error: {e}")
            return
        if not res.ok:
            await msg.reply_text(f"❌ {res.message}")
            return
        _set_step(context, Step.OTP2)
        await msg.reply_text(
            f"{step_header(4, 4, 'OTP 2')}\n\n"
            "✅ **OTP 2 sent** — dubara SMS check karo.\n\n"
            "👇 6-digit OTP yahi chat me bhejo:\n\n"
            f"📱 `{mobile}`\n"
            f"👤 **{context.user_data.get('aadhaar_name', '')}**"
            + _cancel_footer(),
            parse_mode="Markdown",
        )
        return

    if step == Step.OTP2:
        if not OTP_RE.match(text):
            await msg.reply_text("❌ 6 digit OTP bhejo.")
            return
        session = context.user_data.get("aadhaar_session", "")
        mobile = context.user_data.get("aadhaar_mobile", "")
        started = context.user_data.get("aadhaar_started_at", time.time())
        wait = await msg.reply_text("⌛ Verifying OTP 2 & fetching document...")
        backend = _backend(context)
        try:
            res = await backend.submit_otp2(session, text)
        except Exception as e:
            await wait.edit_text(f"❌ Backend error: {e}")
            return
        if not res.ok:
            await wait.edit_text(f"❌ {res.message}")
            return
        await safe_edit(wait, "🔓 PDF password auto (DOB/year scan)...", parse_mode="Markdown")
        uidai_raw = res.raw if isinstance(res.raw, dict) else {}
        holder = context.user_data.get("aadhaar_name") or res.name
        pdf_bytes = res.pdf_bytes or b""
        pdf_unlocked = bool(pdf_bytes)
        if pdf_bytes:
            unlocked = await asyncio.to_thread(unlock_pdf, pdf_bytes, holder, uidai_raw)
            pdf_bytes = unlocked.pdf_bytes
            pdf_unlocked = unlocked.unlocked
            cracked_pwd = unlocked.password if unlocked.unlocked else res.pdf_password_hint
            if not unlocked.unlocked:
                cracked_pwd = cracked_pwd or "— (auto-crack fail, manual try)"
        else:
            cracked_pwd = res.pdf_password_hint
            pdf_unlocked = False
        tg_user = _telegram_user(update)
        db = db_session()
        try:
            if tg_user:
                row = get_or_create_user(db, tg_user.id, tg_user.username)
                if not consume_credit(db, row, _owners()):
                    await wait.edit_text("❌ Credits khatam — owner se add karwao.")
                    return
        finally:
            db.close()
        elapsed = int(time.time() - started)
        context.user_data["aadhaar_last_result"] = {
            "aadhaar_masked": res.aadhaar_masked,
            "name": res.name,
            "numeric_id": res.numeric_id,
            "pdf_password_hint": cracked_pwd,
            "phone": res.phone or mobile,
            "pdf_bytes": pdf_bytes,
            "pdf_unlocked": pdf_unlocked,
            "uidai_raw": uidai_raw,
            "elapsed": elapsed,
        }
        _reset_flow(context)
        await wait.delete()
        await _send_extraction_complete(msg, context)
        return


async def _send_extraction_complete(update_message, context: ContextTypes.DEFAULT_TYPE) -> None:
    data = context.user_data.get("aadhaar_last_result") or {}
    aadhaar = data.get("aadhaar_masked", "—")
    aadhaar_compact = aadhaar.replace(" ", "")
    name = data.get("name", "—")
    numeric_id = data.get("numeric_id", "—")
    pwd = data.get("pdf_password_hint", "—")
    phone = data.get("phone", "—")
    elapsed = data.get("elapsed", 0)

    await update_message.reply_text(
        "✅ **Process Completed!** Document details have been sent above.\n\n"
        "DEV: @ifeelrichhh | Dynamo",
        parse_mode="Markdown",
    )
    body = (
        "━━━━━━━━━━━━━━━━\n"
        "✅ **EXTRACTION COMPLETE**\n"
        "━━━━━━━━━━━━━━━━\n"
        "**Document Aadhar**\n\n"
        f"🪪 `{aadhaar}`\n"
        f"🔢 `{aadhaar_compact}`\n\n"
        f"👤 **Name:** {name}\n"
        f"🆔 `{numeric_id}`\n\n"
        f"🔑 `{pwd}`\n"
        f"📱 `{phone}`\n\n"
        f"⏱ `{elapsed} sec`"
    )
    kb = InlineKeyboardMarkup(
        [
            [InlineKeyboardButton("📎 Download PDF", callback_data=CB_DL_PDF)],
            [InlineKeyboardButton("🔄 Get Another Document", callback_data=CB_GET)],
        ]
    )
    foot = (
        "_Unsealed copy — use the button below._"
        if data.get("pdf_unlocked", True)
        else "_PDF abhi locked ho sakta hai — password upar try karo ya owner se range badhwao._"
    )
    await update_message.reply_text(
        body + f"\n\n{foot}",
        parse_mode="Markdown",
        reply_markup=kb,
    )


async def on_download_pdf(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    q = update.callback_query
    if not q:
        return
    await q.answer()
    data = context.user_data.get("aadhaar_last_result") or {}
    pdf = data.get("pdf_bytes")
    if not pdf:
        await q.message.reply_text("❌ PDF abhi available nahi hai (backend se pdf_base64 bhejo).")
        return
    name = (data.get("name") or "aadhaar").replace(" ", "_")
    await q.message.reply_document(
        document=io.BytesIO(pdf),
        filename=f"{name}_eAadhaar_full.pdf",
        caption=(
            "📎 **e-Aadhaar PDF** (front + back"
            + (", auto-unlocked)" if data.get("pdf_unlocked", True) else ", encrypted)")
            + f"\n🔑 Password: `{data.get('pdf_password_hint', '—')}`"
        ),
        parse_mode="Markdown",
    )


def build_app() -> Application:
    settings = get_settings()
    if not settings.aadhaar_bot_token:
        raise SystemExit("AADHAAR_BOT_TOKEN missing — .env.aadhaar set karo")

    app = (
        Application.builder()
        .token(settings.aadhaar_bot_token)
        .connect_timeout(30.0)
        .read_timeout(30.0)
        .write_timeout(30.0)
        .pool_timeout(30.0)
        .build()
    )
    init_db()
    app.add_handler(CommandHandler("start", cmd_start))
    app.add_handler(CommandHandler("cancel", cmd_cancel))
    app.add_handler(CommandHandler("credits", cmd_credits))
    app.add_handler(CommandHandler("approve", cmd_approve))
    app.add_handler(CommandHandler("addcredits", cmd_addcredits))
    app.add_handler(CommandHandler("revoke", cmd_revoke))
    app.add_handler(CallbackQueryHandler(on_back_home, pattern=r"^aadhaar:back_home$"))
    app.add_handler(CallbackQueryHandler(on_get_aadhaar, pattern=f"^{CB_GET}$"))
    app.add_handler(CallbackQueryHandler(on_get_aadhaar, pattern=f"^{CB_ANOTHER}$"))
    app.add_handler(
        CallbackQueryHandler(on_plans_or_help, pattern=f"^({CB_PLANS}|{CB_HELP})$")
    )
    app.add_handler(
        CallbackQueryHandler(
            on_gender,
            pattern=f"^({CB_GENDER_M}|{CB_GENDER_F}|{CB_NAME_MANUAL})$",
        )
    )
    app.add_handler(CallbackQueryHandler(on_download_pdf, pattern=f"^{CB_DL_PDF}$"))
    app.add_handler(MessageHandler(filters.TEXT & ~filters.COMMAND, on_text))
    return app


def main() -> None:
    build_app().run_polling(allowed_updates=Update.ALL_TYPES)
