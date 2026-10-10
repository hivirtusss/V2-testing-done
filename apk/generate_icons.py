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


def make_icon(size: int) -> Image.Image:
    img = Image.open(SOURCE).convert("RGBA")
    # Square crop from center
    w, h = img.size
    side = min(w, h)
    left = (w - side) // 2
    top = (h - side) // 2
    img = img.crop((left, top, left + side, top + side))
    # Slight inset so round launchers don't clip edges
    canvas = Image.new("RGBA", (size, size), (0, 0, 0, 255))
    inner = int(size * 0.88)
    resized = img.resize((inner, inner), Image.Resampling.LANCZOS)
    offset = (size - inner) // 2
    canvas.paste(resized, (offset, offset), resized)
    return canvas.convert("RGB")


def main() -> None:
    if not SOURCE.exists():
        raise SystemExit(f"Logo not found: {SOURCE}")

    for folder, px in SIZES.items():
        target_dir = OUT_ROOT / folder
        target_dir.mkdir(parents=True, exist_ok=True)
        icon = make_icon(px)
        out = target_dir / "ic_launcher.png"
        icon.save(out, format="PNG", optimize=True)
        print(f"Wrote {out} ({px}x{px})")


if __name__ == "__main__":
    main()
