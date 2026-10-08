from __future__ import annotations

import base64
import io

from aadhaar_bot.config import get_settings


def solve_captcha_image(b64_image: str) -> str:
    settings = get_settings()
    raw = base64.b64decode(b64_image)
    if settings.uidai_captcha_solver == "2captcha" and settings.uidai_2captcha_key:
        return _solve_2captcha(raw)
    return _solve_ddddocr(raw)


def _solve_ddddocr(raw: bytes) -> str:
    try:
        import ddddocr  # type: ignore
    except ImportError as e:
        raise RuntimeError(
            "Captcha auto ke liye: pip install ddddocr  (ya UIDAI_CAPTCHA_SOLVER=2captcha + key)"
        ) from e
    ocr = ddddocr.DdddOcr(show_ad=False)
    text = ocr.classification(raw)
    return text.strip().replace(" ", "")[:8]


def _solve_2captcha(raw: bytes) -> str:
    import httpx

    settings = get_settings()
    key = settings.uidai_2captcha_key
    b64 = base64.b64encode(raw).decode()
    with httpx.Client(timeout=120.0) as client:
        r = client.post(
            "https://2captcha.com/in.php",
            data={"key": key, "method": "base64", "body": b64, "json": 1},
        )
        r.raise_for_status()
        data = r.json()
        if data.get("status") != 1:
            raise RuntimeError(f"2captcha submit fail: {data}")
        req_id = data["request"]
        for _ in range(40):
            g = client.get(
                "https://2captcha.com/res.php",
                params={"key": key, "action": "get", "id": req_id, "json": 1},
            )
            g.raise_for_status()
            gd = g.json()
            if gd.get("status") == 1:
                return str(gd["request"]).strip()
            if gd.get("request") != "CAPCHA_NOT_READY":
                raise RuntimeError(f"2captcha: {gd}")
            import time

            time.sleep(3)
    raise RuntimeError("2captcha timeout")
