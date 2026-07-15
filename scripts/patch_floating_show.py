#!/usr/bin/env python3
"""Gate FloatingMenu.show to selected packages only."""
import sys

path = sys.argv[1]
text = open(path).read()

show_old = """.method public static show(Landroid/app/Activity;)V
    .registers 2

    if-nez p0, :cond_3

    return-void

    :cond_3
    new-instance v0, Lcom/floatingmenu/FloatingMenu$1;

    invoke-direct {v0, p0}, Lcom/floatingmenu/FloatingMenu$1;-><init>(Landroid/app/Activity;)V

    invoke-virtual {p0, v0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method"""

show_new = """.method public static show(Landroid/app/Activity;)V
    .registers 2

    if-nez p0, :cond_0

    return-void

    :cond_0
    invoke-virtual {p0}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/floatingmenu/TargetPackageGuard;->isPackageSelected(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1

    return-void

    :cond_1
    new-instance v0, Lcom/floatingmenu/FloatingMenu$1;

    invoke-direct {v0, p0}, Lcom/floatingmenu/FloatingMenu$1;-><init>(Landroid/app/Activity;)V

    invoke-virtual {p0, v0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method"""

if show_old not in text:
    sys.exit("FloatingMenu.show block not found")
text = text.replace(show_old, show_new, 1)
open(path, "w").write(text)
print("FloatingMenu.show target gate applied")
