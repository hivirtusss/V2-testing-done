#!/usr/bin/env python3
"""Generate Android mipmap launcher icons from Virtus logo."""

from pathlib import Path

from PIL import Image

SOURCE = Path(__file__).resolve().parent / "assets" / "virtus_logo.jpg"
OUT_ROOT = Path(__file__).resolve().parent / "virtus_decompiled" / "res"

SIZES = {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}


def _make_fallback_icon(size: int) -> Image.Image:
    """Yellow V on blue — no external logo required."""
    from PIL import ImageDraw, ImageFont

    canvas = Image.new("RGBA", (size, size), (13, 40, 71, 255))
    draw = ImageDraw.Draw(canvas)
    margin = int(size * 0.14)
    draw.rounded_rectangle(
        (margin, margin, size - margin, size - margin),
        radius=int(size * 0.18),
        fill=(21, 101, 192, 255),
        outline=(255, 193, 7, 255),
        width=max(2, size // 24),
    )
    try:
        font = ImageFont.truetype("DejaVuSans-Bold.ttf", int(size * 0.46))
    except OSError:
        font = ImageFont.load_default()
    draw.text(
        (size * 0.32, size * 0.22),
        "V",
        fill=(255, 213, 79, 255),
        font=font,
    )
    return canvas.convert("RGB")


def make_icon(size: int) -> Image.Image:
    if not SOURCE.exists():
        return _make_fallback_icon(size)
    img = Image.open(SOURCE).convert("RGBA")
    w, h = img.size
    side = min(w, h)
    left = (w - side) // 2
    top = (h - side) // 2
    img = img.crop((left, top, left + side, top + side))
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 255))
    inner = int(size * 0.88)
    resized = img.resize((inner, inner), Image.Resampling.LANCZOS)
    offset = (size - inner) // 2
    canvas.paste(resized, (offset, offset), resized)
    return canvas.convert("RGB")


def main() -> None:
    if not SOURCE.exists():
        print(f"Logo not found ({SOURCE}) — using Virtus yellow/blue fallback icon")

    for folder, px in SIZES.items():
        target_dir = OUT_ROOT / folder
        target_dir.mkdir(parents=True, exist_ok=True)
        icon = make_icon(px)
        out = target_dir / "ic_launcher.png"
        icon.save(out, format="PNG", optimize=True)
        print(f"Wrote {out} ({px}x{px})")


if __name__ == "__main__":
    main()
