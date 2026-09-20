from datetime import datetime, timezone

from sqlalchemy.orm import Session

from app.config import get_settings
from app.database import ApprovedUser, SessionLocal

settings = get_settings()


def is_admin(user_id: int | None) -> bool:
    if user_id is None:
        return False
    admins = settings.allowed_user_ids
    return bool(admins) and user_id in admins


def is_allowed(user_id: int | None) -> bool:
    if user_id is None:
        return False
    env_allowed = settings.allowed_user_ids
    if not env_allowed:
        return True
    if user_id in env_allowed:
        return True
    db: Session = SessionLocal()
    try:
        return db.query(ApprovedUser).filter(ApprovedUser.telegram_user_id == user_id).first() is not None
    finally:
        db.close()


def approve_user(
    admin_id: int,
    target_user_id: int,
    username: str | None = None,
) -> tuple[bool, str]:
    if not is_admin(admin_id):
        return False, "Sirf admin /approve chala sakta hai."

    if target_user_id in settings.allowed_user_ids:
        return True, "User pehle se admin (.env) mein allowed hai."

    db: Session = SessionLocal()
    try:
        existing = db.query(ApprovedUser).filter(ApprovedUser.telegram_user_id == target_user_id).first()
        if existing:
            if username:
                existing.username = username
            existing.approved_by = admin_id
            db.commit()
            return True, "User pehle se approved tha — updated."

        db.add(
            ApprovedUser(
                telegram_user_id=target_user_id,
                approved_by=admin_id,
                username=username,
            )
        )
        db.commit()
        return True, "User approved!"
    finally:
        db.close()


def revoke_user(admin_id: int, target_user_id: int) -> tuple[bool, str]:
    if not is_admin(admin_id):
        return False, "Sirf admin /revoke chala sakta hai."

    if target_user_id in settings.allowed_user_ids:
        return False, "Admin (.env) user ko bot se revoke nahi kar sakte."

    db: Session = SessionLocal()
    try:
        row = db.query(ApprovedUser).filter(ApprovedUser.telegram_user_id == target_user_id).first()
        if not row:
            return False, "User approved list mein nahi hai."
        db.delete(row)
        db.commit()
        return True, "User access revoke ho gaya."
    finally:
        db.close()


def list_approved_users() -> list[ApprovedUser]:
    db: Session = SessionLocal()
    try:
        return db.query(ApprovedUser).order_by(ApprovedUser.created_at.desc()).all()
    finally:
        db.close()
