from __future__ import annotations


def format_user_error(err: BaseException | str | None) -> str:
    if err is None:
        return "Unknown error"
    if isinstance(err, str):
        text = err.strip()
        return text or "Unknown error"
    text = str(err).strip()
    if text:
        return text
    return f"{type(err).__name__} (no detail)"
