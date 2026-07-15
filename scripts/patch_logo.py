#!/usr/bin/env python3
"""Replace bubble logo and fit it on the floating popup."""
import re
import sys

path = sys.argv[1]
logo = open(sys.argv[2]).read().strip()
text = open(path).read()

text, n = re.subn(
    r'const-string v9, "iVBORw0KGgo[^"]+"',
    f'const-string v9, "{logo}"',
    text,
    count=1,
)
if n != 1:
    sys.exit(f"logo replace failed ({n})")

text = text.replace(
    "invoke-virtual {v9, v5}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V\n\n"
    "    sget-object v4, Landroid/widget/ImageView$ScaleType;->FIT_CENTER:Landroid/widget/ImageView$ScaleType;",
    "invoke-virtual {v9, v5}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V\n\n"
    "    sget-object v4, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;",
    1,
)

text = re.sub(
    r"const/4 v8, 0x2\n\n    const/high16 v7, 0x41000000    # 8\.0f\n\n    :try_start_8b",
    "const/4 v8, 0x2\n\n    const/4 v7, 0x0\n\n    :try_start_8b",
    text,
    count=1,
)

text = text.replace(
    "const/high16 v5, 0x425c0000    # 55.0f",
    "const/high16 v5, 0x42780000    # 62.0f",
    1,
)

open(path, "w").write(text)
print(f"logo patched ({len(logo)} chars) + bubble fit")
