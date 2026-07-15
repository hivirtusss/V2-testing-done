#!/usr/bin/env python3
"""Ensure FloatingMenu.show has no inverted target gate (lifecycle handles selection)."""
import sys

path = sys.argv[1]
text = open(path).read()

# Remove broken gate if present from older builds.
broken = """.method public static show(Landroid/app/Activity;)V
    .registers 2

    if-nez p0, :cond_0

    return-void

    :cond_0
    sget-boolean v0, Lcom/floatingmenu/MenuLoader;->sIsTargetPackage:Z

    if-eqz v0, :cond_1

    return-void

    :cond_1
    new-instance v0, Lcom/floatingmenu/FloatingMenu$1;

    invoke-direct {v0, p0}, Lcom/floatingmenu/FloatingMenu$1;-><init>(Landroid/app/Activity;)V

    invoke-virtual {p0, v0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method"""

clean = """.method public static show(Landroid/app/Activity;)V
    .registers 2

    if-nez p0, :cond_3

    return-void

    :cond_3
    new-instance v0, Lcom/floatingmenu/FloatingMenu$1;

    invoke-direct {v0, p0}, Lcom/floatingmenu/FloatingMenu$1;-><init>(Landroid/app/Activity;)V

    invoke-virtual {p0, v0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method"""

if broken in text:
    text = text.replace(broken, clean, 1)
    open(path, "w").write(text)
    print("FloatingMenu.show inverted gate removed")
elif clean in text:
    print("FloatingMenu.show already clean")
else:
    sys.exit("FloatingMenu.show block not found")
