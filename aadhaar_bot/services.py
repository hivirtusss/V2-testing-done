from __future__ import annotations

from sqlalchemy.orm import Session

from aadhaar_bot.models import BotUser


def get_or_create_user(db: Session, telegram_id: int, username: str | None = None) -> BotUser:
    row = db.query(BotUser).filter(BotUser.telegram_id == telegram_id).first()
    if row:
        if username and row.username != username:
            row.username = username
            db.commit()
        return row
    row = BotUser(telegram_id=telegram_id, username=username, approved=False, credits=0)
    db.add(row)
    db.commit()
    db.refresh(row)
    return row


def is_owner(telegram_id: int, owner_ids: set[int]) -> bool:
    return telegram_id in owner_ids


def can_use_bot(user: BotUser, owner_ids: set[int]) -> bool:
    if is_owner(user.telegram_id, owner_ids):
        return True
    return user.approved and user.credits > 0


def plan_line(user: BotUser, owner_ids: set[int]) -> str:
    if is_owner(user.telegram_id, owner_ids):
        return "Your plan: **Unlimited** ✅"
    if not user.approved:
        return "Status: **Not approved** — owner se `/approve` karwao."
    return f"Credits: **{user.credits}** (1 credit = 1 Aadhaar PDF)"


def approve_user(db: Session, telegram_id: int, *, credits: int = 0) -> BotUser:
    user = get_or_create_user(db, telegram_id)
    user.approved = True
    if credits > 0:
        user.credits += credits
    db.commit()
    db.refresh(user)
    return user


def revoke_user(db: Session, telegram_id: int) -> BotUser:
    user = get_or_create_user(db, telegram_id)
    user.approved = False
    db.commit()
    db.refresh(user)
    return user


def add_credits(db: Session, telegram_id: int, amount: int) -> BotUser:
    user = get_or_create_user(db, telegram_id)
    user.credits = max(0, user.credits + amount)
    if amount > 0:
        user.approved = True
    db.commit()
    db.refresh(user)
    return user


def consume_credit(db: Session, user: BotUser, owner_ids: set[int]) -> bool:
    if is_owner(user.telegram_id, owner_ids):
        return True
    if user.credits <= 0:
        return False
    user.credits -= 1
    db.commit()
    return True
