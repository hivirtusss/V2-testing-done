#!/usr/bin/env python3
"""Scale floating bubble (and logo) from screen width like the original module."""
import sys

path = sys.argv[1]
text = open(path).read()

old = """    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v5, 0x42780000    # 62.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v5}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4"""

new = """    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-virtual {v4}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object v5

    invoke-virtual {v5}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v5

    iget v5, v5, Landroid/util/DisplayMetrics;->widthPixels:I

    const/16 v6, 0xb

    div-int v5, v5, v6

    const/high16 v6, 0x42480000    # 50.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v6}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v6

    if-ge v5, v6, :cond_bubble_min

    move v5, v6

    :cond_bubble_min
    const/high16 v6, 0x42900000    # 72.0f

    invoke-static {v4, v6}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v6

    if-le v5, v6, :cond_bubble_max

    move v5, v6

    :cond_bubble_max
    move v4, v5"""

if old not in text:
    old2 = old.replace("0x42780000    # 62.0f", "0x425c0000    # 55.0f")
    if old2 in text:
        old = old2
    else:
        sys.exit("bubble size block not found")

text = text.replace(old, new, 1)
open(path, "w").write(text)
print("bubble size scales with screen width (50–72dp clamp)")
