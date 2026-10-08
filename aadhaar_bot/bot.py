from __future__ import annotations

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
        "Welcome to **Dynamo DocumentBot**\n\n"
        f"{active_plan_line}\n\n"
        "👇 Choose an option:"
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


async def cmd_start(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    msg = update.effective_message
    if not msg:
        return
    _reset_flow(context)
    plan = "Your active plan: **16 days 22 hours** ✅"
    await msg.reply_text(
        _welcome_text(plan),
        parse_mode="Markdown",
        reply_markup=_welcome_keyboard(),
    )


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
    await q.edit_message_text(
        _welcome_text("Your active plan: **16 days 22 hours** ✅"),
        parse_mode="Markdown",
        reply_markup=_welcome_keyboard(),
    )


async def on_get_aadhaar(update: Update, context: ContextTypes.DEFAULT_TYPE) -> None:
    q = update.callback_query
    if not q:
        return
    await q.answer()
    _reset_flow(context)
    _set_step(context, Step.MOBILE)
    await q.edit_message_text(
        "📌 **STEP 1/4 — Mobile**\n\n"
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
        context.user_data.setdefault("aadhaar_gender", "unspecified")
        _set_step(context, Step.NAME)
        await q.edit_message_text(
            "📌 **STEP 2/4 — Holder Name**\n\n"
            "👇 Card par jaisa **full name** likho:\n\n"
            f"📱 Mobile: `{mobile}`"
            + _cancel_footer(),
            parse_mode="Markdown",
        )
        return
    gender = "male" if q.data == CB_GENDER_M else "female"
    context.user_data["aadhaar_gender"] = gender
    _set_step(context, Step.NAME)
    emoji = "👦" if gender == "male" else "👧"
    await q.edit_message_text(
        f"📌 **STEP 2/4 — Holder Name**\n\n"
        f"{emoji} Gender: **{gender.title()}**\n\n"
        "👇 Card par jaisa **full name** type karo:"
        f"\n\n📱 Mobile: `{mobile}`"
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
            "📌 **STEP 2/4 — Gender**\n\n"
            "👇 Select gender:\n\n"
            f"📱 Mobile: `{text}`"
            + _cancel_footer(),
            parse_mode="Markdown",
            reply_markup=kb,
        )
        return

    if step == Step.NAME:
        if len(text) < 2:
            await msg.reply_text("❌ Name kam se kam 2 characters hona chahiye.")
            return
        mobile = context.user_data.get("aadhaar_mobile", "")
        gender = context.user_data.get("aadhaar_gender", "male")
        name = text.upper()
        context.user_data["aadhaar_name"] = name
        context.user_data["aadhaar_started_at"] = time.time()
        wait = await msg.reply_text(
            "📌 **STEP 3/4 — Find Record**\n\n"
            "⌛ Looking up this record... Please wait.",
            parse_mode="Markdown",
        )
        backend = _backend(context)
        try:
            res = await backend.start_lookup(mobile, gender, name)
        except Exception as e:
            await wait.edit_text(f"❌ Backend error: {e}")
            _reset_flow(context)
            return
        if not res.ok:
            await wait.edit_text(f"❌ {res.message}")
            _reset_flow(context)
            return
        context.user_data["aadhaar_session"] = res.session_id
        _set_step(context, Step.OTP1)
        await wait.edit_text(
            "📌 **STEP 3/4 — OTP 1 Verification**\n\n"
            "🚀 OTP 1 sent successfully!\n\n"
            "👇 Type the OTP in chat and send it:\n\n"
            f"📱 Mobile: `{mobile}`"
            + _cancel_footer(),
            parse_mode="Markdown",
        )
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
            "📌 **STEP 4/4 — OTP 2 Verification**\n\n"
            "✅ OTP 2 sent successfully!\n\n"
            "👇 Type the OTP in chat and send it:\n\n"
            f"📱 Mobile: `{mobile}`"
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
        elapsed = int(time.time() - started)
        context.user_data["aadhaar_last_result"] = {
            "aadhaar_masked": res.aadhaar_masked,
            "name": res.name,
            "numeric_id": res.numeric_id,
            "pdf_password_hint": res.pdf_password_hint,
            "phone": res.phone or mobile,
            "pdf_bytes": res.pdf_bytes,
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

    body = (
        "✅ **Process Completed!** Document details have been sent above.\n\n"
        "`@ifeelrichhh` | Dynamo\n\n"
        "━━━━━━━━━━━━━━━━\n"
        "✅ **EXTRACTION COMPLETE**\n"
        "━━━━━━━━━━━━━━━━\n"
        "**Document Aadhar**\n\n"
        f"🪪 Aadhaar: `{aadhaar}`\n"
        f"🔢 `{aadhaar_compact}`\n\n"
        f"👤 Name: **{name}**\n"
        f"🆔 `{numeric_id}`\n\n"
        f"🔑 Password: `{pwd}`\n"
        f"📱 Phone: `{phone}`\n\n"
        f"⏱ Processing Time: `{elapsed} sec`"
    )
    kb = InlineKeyboardMarkup(
        [
            [InlineKeyboardButton("📎 Download PDF", callback_data=CB_DL_PDF)],
            [InlineKeyboardButton("🔄 Get Another Document", callback_data=CB_GET)],
        ]
    )
    await update_message.reply_text(body, parse_mode="Markdown", reply_markup=kb)


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
        filename=f"{name}_aadhaar.pdf",
        caption="📎 Aadhaar PDF (password hint upar message me hai)",
    )


def build_app() -> Application:
    settings = get_settings()
    if not settings.aadhaar_bot_token:
        raise SystemExit("AADHAAR_BOT_TOKEN missing — .env.aadhaar set karo")

    app = Application.builder().token(settings.aadhaar_bot_token).build()
    app.add_handler(CommandHandler("start", cmd_start))
    app.add_handler(CommandHandler("cancel", cmd_cancel))
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
