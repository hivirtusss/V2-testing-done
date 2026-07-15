#!/usr/bin/env python3
"""Trim and center the Virtus V logo for the floating bubble."""
from PIL import Image
import base64
import io
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SRC = ROOT / "tools" / "virtus_v_logo_source.png"
if not SRC.exists():
    SRC = Path("/opt/cursor/artifacts/assets/virtus_v_logo_new.png")
OUT_PNG = ROOT / "tools" / "virtus_v_logo.png"
OUT_B64 = ROOT / "tools" / "virtus_v_logo.b64"
WEB_PNG = ROOT / "extracted" / "webroot" / "virtus_v_logo.png"

img = Image.open(SRC).convert("RGBA")
bbox = img.getbbox()
if bbox:
    img = img.crop(bbox)

w, h = img.size
side = max(w, h)
pad = int(side * 0.06)
sq = Image.new("RGBA", (side + pad * 2, side + pad * 2), (0, 0, 0, 0))
sq.paste(img, ((side + pad * 2 - w) // 2, (side + pad * 2 - h) // 2), img)
sq = sq.resize((96, 96), Image.Resampling.LANCZOS)

bg = Image.new("RGB", (96, 96), (0, 0, 0))
bg.paste(sq, mask=sq.split()[3])
bg.save(OUT_PNG, format="PNG", optimize=True)
bg.save(WEB_PNG, format="PNG", optimize=True)

buf = io.BytesIO()
bg.save(buf, format="JPEG", quality=92, optimize=True)
b64 = base64.b64encode(buf.getvalue()).decode()
OUT_B64.write_text(b64)
print(f"logo ready png={OUT_PNG.stat().st_size} b64={len(b64)}")
