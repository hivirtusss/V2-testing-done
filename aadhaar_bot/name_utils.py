from __future__ import annotations

import re

_MULTI_SPACE = re.compile(r"\s+")


def prepare_holder_name(raw: str) -> tuple[str, str]:
    """Return (display name, uppercase query name for UIDAI match)."""
    display = _MULTI_SPACE.sub(" ", raw.strip())
    return display, display.upper()
