.class Lcom/floatingmenu/ModuleActionPicker$ShowPickerRunnable;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final val$context:Landroid/content/Context;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/ModuleActionPicker$ShowPickerRunnable;->val$context:Landroid/content/Context;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 16

    iget-object v0, p0, Lcom/floatingmenu/ModuleActionPicker$ShowPickerRunnable;->val$context:Landroid/content/Context;

    const-string v1, "window"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/WindowManager;

    if-nez v1, :cond_wm

    const/4 v0, 0x1

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    :cond_wm
    sput-object v1, Lcom/floatingmenu/ModuleActionPicker;->sWindowManager:Landroid/view/WindowManager;

    new-instance v2, Landroid/widget/FrameLayout;

    invoke-direct {v2, v0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    const/high16 v3, -0x67000000

    invoke-virtual {v2, v3}, Landroid/view/View;->setBackgroundColor(I)V

    const/4 v3, 0x1

    invoke-virtual {v2, v3}, Landroid/view/View;->setClickable(Z)V

    new-instance v4, Landroid/widget/ScrollView;

    invoke-direct {v4, v0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    new-instance v5, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v6, -0x1

    invoke-direct {v5, v6, v6}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    const/high16 v7, 0x42200000    # 40.0f

    invoke-static {v0, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v7

    const/high16 v8, 0x41a00000    # 20.0f

    invoke-static {v0, v8}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v8

    invoke-virtual {v5, v7, v8, v7, v8}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v4, v5}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v5, Landroid/widget/LinearLayout;

    invoke-direct {v5, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v5, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v7, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v7}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v8, 0x0

    invoke-virtual {v7, v8}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    const v9, -0x55e6e6e6

    invoke-virtual {v7, v9}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/high16 v9, 0x41400000    # 12.0f

    invoke-static {v0, v9}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v9

    int-to-float v9, v9

    invoke-virtual {v7, v9}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    invoke-static {v5, v7}, Lcom/floatingmenu/a;->g(Landroid/widget/LinearLayout;Landroid/graphics/drawable/GradientDrawable;)V

    const/high16 v7, 0x41800000    # 16.0f

    invoke-static {v0, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v7

    invoke-virtual {v5, v7, v7, v7, v7}, Landroid/view/View;->setPadding(IIII)V

    new-instance v7, Landroid/widget/TextView;

    invoke-direct {v7, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v9, "Virtus v3 @Hivirtus - Select Hook Apps"

    invoke-virtual {v7, v9}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v9, -0x50306

    invoke-virtual {v7, v9}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v9, 0x2

    const/high16 v10, 0x41600000    # 14.0f

    invoke-virtual {v7, v9, v10}, Landroid/widget/TextView;->setTextSize(IF)V

    sget-object v9, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v7, v9}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    invoke-virtual {v5, v7}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    invoke-static {v0}, Lcom/floatingmenu/AppSelectionHelper;->buildSelectionSection(Landroid/content/Context;)Landroid/widget/LinearLayout;

    move-result-object v7

    invoke-virtual {v5, v7}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v7, Landroid/widget/Button;

    invoke-direct {v7, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v9, "Close @Hivirtus"

    invoke-virtual {v7, v9}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {v7, v6}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-static {v7}, Lcom/floatingmenu/b;->c(Landroid/widget/Button;)V

    invoke-static {v0, v7}, Lcom/floatingmenu/AppSelectionHelper;->styleRedButton(Landroid/content/Context;Landroid/widget/Button;)V

    new-instance v9, Lcom/floatingmenu/ModuleActionPicker$CloseClick;

    invoke-direct {v9}, Lcom/floatingmenu/ModuleActionPicker$CloseClick;-><init>()V

    invoke-virtual {v7, v9}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v10, 0x42180000    # 38.0f

    invoke-static {v0, v10}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v10

    invoke-direct {v9, v6, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/high16 v10, 0x41000000    # 8.0f

    invoke-static {v0, v10}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v10

    iput v10, v9, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v5, v7, v9}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v4, v5}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V

    invoke-virtual {v2, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    sput-object v2, Lcom/floatingmenu/ModuleActionPicker;->sOverlay:Landroid/view/View;

    sget v3, Landroid/os/Build$VERSION;->SDK_INT:I

    new-instance v9, Landroid/view/WindowManager$LayoutParams;

    const/16 v4, 0x1a

    if-lt v3, v4, :cond_type_old

    const/16 v12, 0x7d3

    goto :goto_type

    :cond_type_old
    const/16 v12, 0x7d3

    :goto_type
    const/4 v10, -0x1

    const/4 v11, -0x1

    const/16 v13, 0x100

    const/4 v14, -0x3

    invoke-direct/range {v9 .. v14}, Landroid/view/WindowManager$LayoutParams;-><init>(IIIII)V

    :try_start_add
    invoke-interface {v1, v2, v9}, Landroid/view/ViewManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    :try_end_add
    .catch Ljava/lang/Exception; {:try_start_add .. :try_end_add} :catch_add

    return-void

    :catch_add
    const/4 v0, 0x1

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    return-void
.end method
