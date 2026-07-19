#!/usr/bin/env python3
"""Allow floating bubble free drag anywhere on screen."""
import sys

path = sys.argv[1]
text = open(path).read()

gravity_old = (
    "    const/16 v9, 0x33\n\n"
    "    iput v9, v5, Landroid/widget/FrameLayout$LayoutParams;->gravity:I"
)
gravity_new = (
    "    const/16 v9, 0x0\n\n"
    "    iput v9, v5, Landroid/widget/FrameLayout$LayoutParams;->gravity:I"
)
if gravity_old in text:
    text = text.replace(gravity_old, gravity_new, 1)
elif "    const/16 v9, 0x11" in text:
    text = text.replace(
        "    const/16 v9, 0x11\n\n"
        "    iput v9, v5, Landroid/widget/FrameLayout$LayoutParams;->gravity:I",
        gravity_new,
        1,
    )
else:
    sys.exit("bubble gravity block not found")

touchable = (
    "    invoke-virtual {v10, v5}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V\n\n"
    "    new-instance v4, Landroid/graphics/drawable/GradientDrawable;"
)
touchable_new = (
    "    invoke-virtual {v10, v5}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V\n\n"
    "    const/4 v4, 0x1\n\n"
    "    invoke-virtual {v10, v4}, Landroid/view/View;->setClickable(Z)V\n\n"
    "    invoke-virtual {v10, v4}, Landroid/view/View;->setFocusable(Z)V\n\n"
    "    new-instance v4, Landroid/graphics/drawable/GradientDrawable;"
)
if touchable not in text:
    sys.exit("bubble touchable anchor not found")
text = text.replace(touchable, touchable_new, 1)

open(path, "w").write(text)
print("bubble free-drag patch applied")
