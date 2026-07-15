.class Lcom/floatingmenu/FloatingMenu$ActionTabHelper;
.super Ljava/lang/Object;
.source "SourceFile"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static hideActionPanel()V
    .registers 3

    sget-object v0, Lcom/floatingmenu/FloatingMenu;->sLayoutAction:Landroid/widget/LinearLayout;

    if-eqz v0, :cond_end

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    :cond_end
    sget-object v0, Lcom/floatingmenu/FloatingMenu;->sTabAction:Landroid/widget/Button;

    if-eqz v0, :cond_ret

    sget-object v1, Lcom/floatingmenu/FloatingMenu;->sTabUnselectedBg:Landroid/graphics/drawable/GradientDrawable;

    if-eqz v1, :cond_ret

    invoke-static {v0, v1}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    :cond_ret
    return-void
.end method

.method public static buildActionPanel(Landroid/app/Activity;)Landroid/widget/LinearLayout;
    .registers 9

    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v2, -0x1

    const/4 v3, -0x2

    invoke-direct {v1, v2, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v1, Landroid/widget/TextView;

    invoke-direct {v1, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v2, "@Hivirtus Quick Actions"

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v2, -0x50306

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v2, 0x2

    const/high16 v3, 0x41400000    # 12.0f

    invoke-virtual {v1, v2, v3}, Landroid/widget/TextView;->setTextSize(IF)V

    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v3, -0x1

    const/4 v4, -0x2

    invoke-direct {v2, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/high16 v3, 0x41000000    # 8.0f

    invoke-static {p0, v3}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v3

    iput v3, v2, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v0, v1, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v1, Landroid/widget/Button;

    invoke-direct {v1, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v2, "Open License Key @Hivirtus"

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 v2, -0x1

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v2, 0x2

    const/high16 v3, 0x41400000    # 12.0f

    invoke-virtual {v1, v2, v3}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-static {v1}, Lcom/floatingmenu/b;->c(Landroid/widget/Button;)V

    new-instance v2, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v2}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    const v3, -0x2cd0d1

    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/high16 v3, 0x41000000    # 8.0f

    invoke-static {p0, v3}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v3

    int-to-float v3, v3

    invoke-virtual {v2, v3}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    invoke-static {v1, v2}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    new-instance v2, Lcom/floatingmenu/FloatingMenu$ActionLicenseClick;

    invoke-direct {v2, p0}, Lcom/floatingmenu/FloatingMenu$ActionLicenseClick;-><init>(Landroid/app/Activity;)V

    invoke-virtual {v1, v2}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v3, 0x42180000    # 38.0f

    invoke-static {p0, v3}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v3

    const/4 v4, -0x1

    invoke-direct {v2, v4, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/high16 v3, 0x41600000    # 14.0f

    invoke-static {p0, v3}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v3

    iput v3, v2, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v0, v1, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-static {p0}, Lcom/floatingmenu/AppSelectionHelper;->buildSelectionSection(Landroid/content/Context;)Landroid/widget/LinearLayout;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    return-object v0
.end method

.method public static showActionPanel()V
    .registers 3

    sget-object v0, Lcom/floatingmenu/FloatingMenu;->sTabSystem:Landroid/widget/Button;

    if-eqz v0, :cond_tabs

    sget-object v1, Lcom/floatingmenu/FloatingMenu;->sTabUnselectedBg:Landroid/graphics/drawable/GradientDrawable;

    invoke-static {v0, v1}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    sget-object v0, Lcom/floatingmenu/FloatingMenu;->sTabMessage:Landroid/widget/Button;

    invoke-static {v0, v1}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    sget-object v0, Lcom/floatingmenu/FloatingMenu;->sTabTelegram:Landroid/widget/Button;

    invoke-static {v0, v1}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    sget-object v0, Lcom/floatingmenu/FloatingMenu;->sTabAction:Landroid/widget/Button;

    sget-object v1, Lcom/floatingmenu/FloatingMenu;->sTabSelectedBg:Landroid/graphics/drawable/GradientDrawable;

    invoke-static {v0, v1}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    :cond_tabs
    sget-object v0, Lcom/floatingmenu/FloatingMenu;->sLayoutSystem:Landroid/widget/LinearLayout;

    if-eqz v0, :cond_layouts

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    sget-object v0, Lcom/floatingmenu/FloatingMenu;->sLayoutMessage:Landroid/widget/LinearLayout;

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    sget-object v0, Lcom/floatingmenu/FloatingMenu;->sLayoutTelegram:Landroid/widget/LinearLayout;

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    :cond_layouts
    sget-object v0, Lcom/floatingmenu/FloatingMenu;->sLayoutAction:Landroid/widget/LinearLayout;

    if-eqz v0, :cond_ret

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    :cond_ret
    return-void
.end method
