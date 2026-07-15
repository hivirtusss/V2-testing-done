#!/usr/bin/env python3
"""Replace bubble logo and center-fit it on the floating bubble."""
import re
import sys

path = sys.argv[1]
logo = open(sys.argv[2]).read().strip()
text = open(path).read()

text, n = re.subn(
    r'const-string v9, "(?:iVBORw0KGgo|/9j/)[^"]+"',
    f'const-string v9, "{logo}"',
    text,
    count=1,
)
if n != 1:
    sys.exit(f"logo replace failed ({n})")

# Keep FIT_CENTER so the full logo stays visible and centered like the menu icon.
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

text = text.replace(
    "    move-result v7\n\n    invoke-virtual {v4, v7, v11}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V",
    "    move-result v7\n\n    const v11, -0xff0033\n\n    invoke-virtual {v4, v7, v11}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V",
    1,
)

text = text.replace(
    "    invoke-virtual {v9, v4, v4, v4, v4}, Landroid/view/View;->setPadding(IIII)V\n\n"
    "    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;\n\n"
    "    invoke-direct {v4, v11, v11}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V\n\n"
    "    invoke-virtual {v10, v9, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V\n"
    "    :try_end_b8",
    "    invoke-virtual {v9, v4, v4, v4, v4}, Landroid/view/View;->setPadding(IIII)V\n\n"
    "    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;\n\n"
    "    invoke-direct {v4, v11, v11}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V\n\n"
    "    const/16 v5, 0x11\n\n"
    "    iput v5, v4, Landroid/widget/FrameLayout$LayoutParams;->gravity:I\n\n"
    "    invoke-virtual {v10, v9, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V\n"
    "    :try_end_b8",
    1,
)

open(path, "w").write(text)
print(f"logo patched ({len(logo)} chars) + centered bubble fit")
