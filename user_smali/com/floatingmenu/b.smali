.class public abstract synthetic Lcom/floatingmenu/b;
.super Ljava/lang/Object;
.source "SourceFile"


# direct methods
.method public static bridge synthetic a(Landroid/app/Application;Landroid/app/Application$ActivityLifecycleCallbacks;)V
    .registers 2

    invoke-virtual {p0, p1}, Landroid/app/Application;->registerActivityLifecycleCallbacks(Landroid/app/Application$ActivityLifecycleCallbacks;)V

    return-void
.end method

.method public static bridge synthetic b(Landroid/view/ViewPropertyAnimator;)V
    .registers 1

    invoke-virtual {p0}, Landroid/view/ViewPropertyAnimator;->start()V

    return-void
.end method

.method public static bridge synthetic c(Landroid/widget/Button;)V
    .registers 2

    const/4 v0, 0x0

    invoke-virtual {p0, v0}, Landroid/widget/Button;->setAllCaps(Z)V

    return-void
.end method

.method public static bridge synthetic d(Landroid/widget/Switch;)V
    .registers 2

    const-string v0, "Hook Incoming SMS"

    invoke-virtual {p0, v0}, Landroid/widget/Switch;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method public static bridge synthetic e(Landroid/widget/Switch;Landroid/widget/CompoundButton$OnCheckedChangeListener;)V
    .registers 2

    invoke-virtual {p0, p1}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    return-void
.end method

.method public static bridge synthetic f(Landroid/widget/Switch;Landroid/widget/LinearLayout$LayoutParams;)V
    .registers 2

    invoke-virtual {p0, p1}, Landroid/widget/Switch;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    return-void
.end method

.method public static bridge synthetic g(Landroid/widget/Switch;Z)V
    .registers 2

    invoke-virtual {p0, p1}, Landroid/widget/Switch;->setChecked(Z)V

    return-void
.end method

.method public static bridge synthetic h(Landroid/widget/Switch;)Z
    .registers 1

    invoke-virtual {p0}, Landroid/widget/Switch;->isChecked()Z

    move-result p0

    return p0
.end method

.method public static bridge synthetic i(Landroid/widget/Button;)V
    .registers 2

    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Landroid/widget/Button;->setAllCaps(Z)V

    return-void
.end method

.method public static bridge synthetic j(Landroid/widget/Switch;)V
    .registers 2

    const-string v0, "Hook Outgoing SMS"

    invoke-virtual {p0, v0}, Landroid/widget/Switch;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method public static bridge synthetic k(Landroid/widget/Switch;)V
    .registers 2

    const-string v0, "Enable SIM 1 Mocking"

    invoke-virtual {p0, v0}, Landroid/widget/Switch;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method public static bridge synthetic l(Landroid/widget/Switch;)V
    .registers 2

    const-string v0, "Enable SIM 2 Mocking"

    invoke-virtual {p0, v0}, Landroid/widget/Switch;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method public static bridge synthetic m(Landroid/widget/Switch;)V
    .registers 2

    const/4 v0, -0x1

    invoke-virtual {p0, v0}, Landroid/widget/Switch;->setTextColor(I)V

    return-void
.end method

.method public static bridge synthetic n(Landroid/widget/Switch;)V
    .registers 3

    const/4 v0, 0x2

    const/high16 v1, 0x41500000    # 13.0f

    invoke-virtual {p0, v0, v1}, Landroid/widget/Switch;->setTextSize(IF)V

    return-void
.end method

.method public static bridge synthetic o(Landroid/widget/Switch;)V
    .registers 2

    const-string v0, "I am not Developer"

    invoke-virtual {p0, v0}, Landroid/widget/Switch;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method

.method public static bridge synthetic p(Landroid/widget/Switch;)V
    .registers 2

    const-string v0, "I am no root"

    invoke-virtual {p0, v0}, Landroid/widget/Switch;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method
