.class Lcom/floatingmenu/FloatingMenu$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic val$activity:Landroid/app/Activity;


# direct methods
.method public constructor <init>(Landroid/app/Activity;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 57

    move-object/from16 v15, p0

    const-string v1, "e.g. +919876543210"

    const-string v2, "jio"

    const-string v3, "sans-serif-medium"

    const-string v14, "zygisk_floating_menu"

    :try_start_a
    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-virtual {v4}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v4

    invoke-virtual {v4}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v4

    move-object v13, v4

    check-cast v13, Landroid/view/ViewGroup;

    if-nez v13, :cond_1a

    return-void

    :cond_1a
    invoke-virtual {v13, v14}, Landroid/view/View;->findViewWithTag(Ljava/lang/Object;)Landroid/view/View;

    move-result-object v4

    if-eqz v4, :cond_21

    return-void

    :cond_21
    new-instance v12, Landroid/widget/FrameLayout;

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v12, v4}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v12, v14}, Landroid/view/View;->setTag(Ljava/lang/Object;)V

    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v11, -0x1

    invoke-direct {v4, v11, v11}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v12, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v10, Landroid/widget/FrameLayout;

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v10, v4}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v5, 0x425c0000    # 55.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v5}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    new-instance v5, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v5, v4, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    const/16 v9, 0x33

    iput v9, v5, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v6, 0x41a00000    # 20.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v6}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    iput v4, v5, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v7, 0x43160000    # 150.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    iput v4, v5, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    invoke-virtual {v10, v5}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v4, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v4}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v5, 0x1

    invoke-virtual {v4, v5}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    const v7, -0x9c990f

    const v8, -0xb0b91b

    filled-new-array {v7, v8}, [I

    move-result-object v7

    invoke-static {v4, v7}, Lcom/floatingmenu/a;->b(Landroid/graphics/drawable/GradientDrawable;[I)V

    iget-object v7, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v8, 0x40000000    # 2.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v7, v8}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v7

    invoke-virtual {v4, v7, v11}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    invoke-static {v10, v4}, Lcom/floatingmenu/a;->f(Landroid/widget/FrameLayout;Landroid/graphics/drawable/GradientDrawable;)V
    :try_end_87
    .catch Ljava/lang/Exception; {:try_start_a .. :try_end_87} :catch_c37

    const/4 v4, 0x0

    const/4 v8, 0x2

    const/high16 v7, 0x41000000    # 8.0f

    :try_start_8b
    const-string v9, "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"

    invoke-static {v9, v4}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object v9

    array-length v5, v9

    invoke-static {v9, v4, v5}, Landroid/graphics/BitmapFactory;->decodeByteArray([BII)Landroid/graphics/Bitmap;

    move-result-object v5

    if-eqz v5, :cond_b9

    new-instance v9, Landroid/widget/ImageView;

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v9, v4}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v9, v5}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    sget-object v4, Landroid/widget/ImageView$ScaleType;->FIT_CENTER:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {v9, v4}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    invoke-virtual {v9, v4, v4, v4, v4}, Landroid/view/View;->setPadding(IIII)V

    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v4, v11, v11}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v10, v9, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    :try_end_b8
    .catch Ljava/lang/Exception; {:try_start_8b .. :try_end_b8} :catch_b9

    goto :goto_e0

    :catch_b9
    :cond_b9
    :try_start_b9
    new-instance v4, Landroid/widget/TextView;

    iget-object v5, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v4, v5}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v5, "M"

    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {v4, v11}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-virtual {v4, v8, v6}, Landroid/widget/TextView;->setTextSize(IF)V

    const/4 v5, 0x1

    invoke-static {v3, v5}, Landroid/graphics/Typeface;->create(Ljava/lang/String;I)Landroid/graphics/Typeface;

    move-result-object v6

    invoke-virtual {v4, v6}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const/16 v5, 0x11

    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setGravity(I)V

    new-instance v5, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v5, v11, v11}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v10, v4, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    :goto_e0
    new-instance v9, Landroid/widget/LinearLayout;

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v9, v4}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v4, 0x1

    invoke-virtual {v9, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v5, 0x438c0000    # 280.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v5}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    new-instance v5, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v6, -0x2

    invoke-direct {v5, v4, v6}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    const/16 v4, 0x11

    iput v4, v5, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    invoke-virtual {v9, v5}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const/16 v5, 0x8

    invoke-virtual {v9, v5}, Landroid/view/View;->setVisibility(I)V

    new-instance v4, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v4}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v5, 0x0

    invoke-virtual {v4, v5}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    const v5, -0x11eee7d9

    invoke-virtual {v4, v5}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    iget-object v5, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v7, 0x41800000    # 16.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v5, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v5

    int-to-float v5, v5

    invoke-virtual {v4, v5}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    iget-object v5, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v8, 0x40000000    # 2.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v5, v8}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v5

    const v8, -0xc8beaf

    invoke-virtual {v4, v5, v8}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    invoke-static {v9, v4}, Lcom/floatingmenu/a;->g(Landroid/widget/LinearLayout;Landroid/graphics/drawable/GradientDrawable;)V

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    invoke-virtual {v9, v4, v4, v4, v4}, Landroid/view/View;->setPadding(IIII)V

    new-instance v4, Landroid/widget/RelativeLayout;

    iget-object v5, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v4, v5}, Landroid/widget/RelativeLayout;-><init>(Landroid/content/Context;)V

    new-instance v5, Landroid/widget/RelativeLayout$LayoutParams;

    invoke-direct {v5, v11, v6}, Landroid/widget/RelativeLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v4, v5}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v5, Landroid/widget/TextView;

    iget-object v8, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v5, v8}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v8, "Zygisk Mod Menu By @Hivirtus"

    invoke-virtual {v5, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {v5, v11}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v8, 0x2

    invoke-virtual {v5, v8, v7}, Landroid/widget/TextView;->setTextSize(IF)V

    const/4 v8, 0x1

    invoke-static {v3, v8}, Landroid/graphics/Typeface;->create(Ljava/lang/String;I)Landroid/graphics/Typeface;

    move-result-object v3

    invoke-virtual {v5, v3}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    new-instance v3, Landroid/widget/RelativeLayout$LayoutParams;

    invoke-direct {v3, v6, v6}, Landroid/widget/RelativeLayout$LayoutParams;-><init>(II)V

    const/16 v8, 0x9

    invoke-virtual {v3, v8}, Landroid/widget/RelativeLayout$LayoutParams;->addRule(I)V

    invoke-virtual {v4, v5, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v8, Landroid/widget/TextView;

    iget-object v3, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v8, v3}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "\u2715"

    invoke-virtual {v8, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v5, -0x635c51

    invoke-virtual {v8, v5}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v3, 0x41900000    # 18.0f

    const/4 v7, 0x2

    invoke-virtual {v8, v7, v3}, Landroid/widget/TextView;->setTextSize(IF)V

    sget-object v3, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v8, v3}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    iget-object v3, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v7, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v3, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v3

    iget-object v5, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v11, 0x40800000    # 4.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v5, v11}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v5

    iget-object v6, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v6, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v6

    iget-object v7, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v7, v11}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v7

    invoke-virtual {v8, v3, v5, v6, v7}, Landroid/widget/TextView;->setPadding(IIII)V

    new-instance v3, Landroid/widget/RelativeLayout$LayoutParams;

    const/4 v5, -0x2

    invoke-direct {v3, v5, v5}, Landroid/widget/RelativeLayout$LayoutParams;-><init>(II)V

    const/16 v5, 0xb

    invoke-virtual {v3, v5}, Landroid/widget/RelativeLayout$LayoutParams;->addRule(I)V

    invoke-virtual {v4, v8, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v9, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/widget/LinearLayout;

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v3, v4}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, -0x1

    const/4 v6, -0x2

    invoke-direct {v4, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v5, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v7, 0x41400000    # 12.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v5, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v5

    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v3, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v6, Landroid/widget/Button;

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v6, v4}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "SYSTEM"

    invoke-virtual {v6, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v5, 0x41200000    # 10.0f

    const/4 v4, 0x2

    invoke-virtual {v6, v4, v5}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-static {v6}, Lcom/floatingmenu/b;->i(Landroid/widget/Button;)V

    const/4 v4, 0x0

    invoke-virtual {v6, v4, v4, v4, v4}, Landroid/view/View;->setPadding(IIII)V

    new-instance v11, Landroid/widget/LinearLayout$LayoutParams;

    iget-object v7, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v5, 0x42000000    # 32.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v7, v5}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v7

    const/high16 v5, 0x3f800000    # 1.0f

    invoke-direct {v11, v4, v7, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v7, 0x40000000    # 2.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    iput v4, v11, Landroid/widget/LinearLayout$LayoutParams;->rightMargin:I

    invoke-virtual {v6, v11}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v11, Landroid/widget/Button;

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v11, v4}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "MESSAGE"

    invoke-virtual {v11, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x2

    const/high16 v7, 0x41200000    # 10.0f

    invoke-virtual {v11, v4, v7}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-static {v11}, Lcom/floatingmenu/b;->i(Landroid/widget/Button;)V

    const/4 v4, 0x0

    invoke-virtual {v11, v4, v4, v4, v4}, Landroid/view/View;->setPadding(IIII)V

    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v5, 0x42000000    # 32.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v5}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    move-object/from16 v29, v8

    const/4 v5, 0x0

    const/high16 v8, 0x3f800000    # 1.0f

    invoke-direct {v7, v5, v4, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v5, 0x40000000    # 2.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v5}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    iput v4, v7, Landroid/widget/LinearLayout$LayoutParams;->leftMargin:I

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v5}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    iput v4, v7, Landroid/widget/LinearLayout$LayoutParams;->rightMargin:I

    invoke-virtual {v11, v7}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v8, Landroid/widget/Button;

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v8, v4}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "TELEGRAM"

    invoke-virtual {v8, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x2

    const/high16 v5, 0x41200000    # 10.0f

    invoke-virtual {v8, v4, v5}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-static {v8}, Lcom/floatingmenu/b;->i(Landroid/widget/Button;)V

    const/4 v4, 0x0

    invoke-virtual {v8, v4, v4, v4, v4}, Landroid/view/View;->setPadding(IIII)V

    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;

    iget-object v7, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v4, 0x42000000    # 32.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v7, v4}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    move-object/from16 v28, v10

    const/4 v7, 0x0

    const/high16 v10, 0x3f800000    # 1.0f

    invoke-direct {v5, v7, v4, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v7, 0x40000000    # 2.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    iput v4, v5, Landroid/widget/LinearLayout$LayoutParams;->leftMargin:I

    invoke-virtual {v8, v5}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v3, v6}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    invoke-virtual {v3, v11}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    invoke-virtual {v3, v8}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    invoke-virtual {v9, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v10, Landroid/widget/LinearLayout;

    iget-object v3, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v10, v3}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x1

    invoke-virtual {v10, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, -0x1

    const/4 v5, -0x2

    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v10, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v7, Landroid/widget/LinearLayout;

    iget-object v3, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v7, v3}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x1

    invoke-virtual {v7, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, -0x1

    const/4 v5, -0x2

    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v7, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v5, Landroid/widget/LinearLayout;

    iget-object v3, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v5, v3}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x1

    invoke-virtual {v5, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    move-object/from16 v16, v6

    const/4 v4, -0x1

    const/4 v6, -0x2

    invoke-direct {v3, v4, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v5, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v9, v10}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    invoke-virtual {v9, v7}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    invoke-virtual {v9, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/view/View;

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v3, v4}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    iget-object v6, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    move-object/from16 v30, v5

    const/high16 v5, 0x3f800000    # 1.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v6, v5}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v6

    const/4 v5, -0x1

    invoke-direct {v4, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v5, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v6, 0x41200000    # 10.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v5, v6}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v5

    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    iget-object v5, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v5, v6}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v5

    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    invoke-virtual {v3, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const v4, -0xc8beaf

    invoke-virtual {v3, v4}, Landroid/view/View;->setBackgroundColor(I)V

    invoke-virtual {v9, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/widget/TextView;

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v3, v4}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v4, "System SIM Card Configuration"

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v4, -0x635c51

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v4, 0x2

    const/high16 v5, 0x41400000    # 12.0f

    invoke-virtual {v3, v4, v5}, Landroid/widget/TextView;->setTextSize(IF)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, -0x1

    const/4 v6, -0x2

    invoke-direct {v4, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v5, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v6, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v5, v6}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v5

    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v3, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v10, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/view/View;

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v3, v4}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    iget-object v5, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v6, 0x3f800000    # 1.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v5, v6}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v5

    const/4 v6, -0x1

    invoke-direct {v4, v6, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v5, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v6, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v5, v6}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v5

    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    iget-object v5, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v5, v6}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v5

    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    invoke-virtual {v3, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const v6, -0xc8beaf

    invoke-virtual {v3, v6}, Landroid/view/View;->setBackgroundColor(I)V

    invoke-virtual {v10, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/Switch;

    iget-object v3, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v5, v3}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V

    invoke-static {v5}, Lcom/floatingmenu/b;->k(Landroid/widget/Switch;)V

    invoke-static {v5}, Lcom/floatingmenu/b;->m(Landroid/widget/Switch;)V

    invoke-static {v5}, Lcom/floatingmenu/b;->n(Landroid/widget/Switch;)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, -0x1

    const/4 v6, -0x2

    invoke-direct {v3, v4, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v6, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v6}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    iput v4, v3, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-static {v5, v3}, Lcom/floatingmenu/b;->f(Landroid/widget/Switch;Landroid/widget/LinearLayout$LayoutParams;)V

    invoke-virtual {v10, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v6, Landroid/widget/LinearLayout;

    iget-object v3, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v6, v3}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x1

    invoke-virtual {v6, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    move-object/from16 v31, v7

    const/4 v4, -0x1

    const/4 v7, -0x2

    invoke-direct {v3, v4, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v6, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const/16 v3, 0x8

    invoke-virtual {v6, v3}, Landroid/view/View;->setVisibility(I)V

    new-instance v3, Landroid/widget/TextView;

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v3, v4}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v4, "SIM 1 Provider:"

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v4, -0x635c51

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v7, 0x41300000    # 11.0f

    const/4 v4, 0x2

    invoke-virtual {v3, v4, v7}, Landroid/widget/TextView;->setTextSize(IF)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    move-object/from16 v32, v8

    const/4 v7, -0x1

    const/4 v8, -0x2

    invoke-direct {v4, v7, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v7, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v8, 0x40c00000    # 6.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v7, v8}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v7

    iput v7, v4, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v3, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v6, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    const/4 v3, 0x1

    new-array v7, v3, [Ljava/lang/String;

    const/4 v3, 0x0

    aput-object v2, v7, v3

    iget-object v3, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->createProviderSelector(Landroid/app/Activity;[Ljava/lang/String;)Landroid/widget/LinearLayout;
    invoke-static {v3, v7}, Lcom/floatingmenu/FloatingMenu;->access$100(Landroid/app/Activity;[Ljava/lang/String;)Landroid/widget/LinearLayout;

    move-result-object v3

    invoke-virtual {v6, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v8, Landroid/widget/TextView;

    move-object/from16 v34, v3

    iget-object v3, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v8, v3}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "SIM 1 Number:"

    invoke-virtual {v8, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v3, -0x635c51

    invoke-virtual {v8, v3}, Landroid/widget/TextView;->setTextColor(I)V

    move-object/from16 v35, v9

    const/4 v3, 0x2

    const/high16 v9, 0x41300000    # 11.0f

    invoke-virtual {v8, v3, v9}, Landroid/widget/TextView;->setTextSize(IF)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    move-object/from16 v36, v11

    const/4 v9, -0x1

    const/4 v11, -0x2

    invoke-direct {v3, v9, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v9, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v11, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v9, v11}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v9

    iput v9, v3, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v8, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v6, v8}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v11, Landroid/widget/EditText;

    iget-object v8, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v11, v8}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    const/4 v8, -0x1

    invoke-virtual {v11, v8}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v9, 0x41500000    # 13.0f

    const/4 v8, 0x2

    invoke-virtual {v11, v8, v9}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-virtual {v11, v1}, Landroid/widget/TextView;->setHint(Ljava/lang/CharSequence;)V

    const v8, -0xb4aa9d

    invoke-virtual {v11, v8}, Landroid/widget/TextView;->setHintTextColor(I)V

    new-instance v8, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v8}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v9, 0x0

    invoke-virtual {v8, v9}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    const v9, -0xe0d6c9

    invoke-virtual {v8, v9}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    iget-object v9, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    move-object/from16 v39, v12

    const/high16 v12, 0x40c00000    # 6.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v9, v12}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v9

    int-to-float v9, v9

    invoke-virtual {v8, v9}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    invoke-static {v11, v8}, Lcom/floatingmenu/a;->e(Landroid/widget/EditText;Landroid/graphics/drawable/GradientDrawable;)V

    iget-object v9, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v12, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v9, v12}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v9

    iget-object v12, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    move-object/from16 v40, v13

    const/high16 v13, 0x40c00000    # 6.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v12, v13}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v12

    iget-object v13, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;
    :try_end_47d
    .catch Ljava/lang/Exception; {:try_start_b9 .. :try_end_47d} :catch_c37

    move-object/from16 v41, v14

    const/high16 v14, 0x41000000    # 8.0f

    :try_start_481
    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v13, v14}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v13

    iget-object v14, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    move-object/from16 v42, v7

    const/high16 v7, 0x40c00000    # 6.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v14, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v14

    invoke-virtual {v11, v9, v12, v13, v14}, Landroid/view/View;->setPadding(IIII)V

    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v9, -0x1

    const/4 v12, -0x2

    invoke-direct {v7, v9, v12}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v9, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v12, 0x40800000    # 4.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v9, v12}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v9

    iput v9, v7, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v11, v7}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v6, v11}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    invoke-virtual {v10, v6}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v12, Landroid/widget/Switch;

    iget-object v9, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v12, v9}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V

    invoke-static {v12}, Lcom/floatingmenu/b;->l(Landroid/widget/Switch;)V

    invoke-static {v12}, Lcom/floatingmenu/b;->m(Landroid/widget/Switch;)V

    invoke-static {v12}, Lcom/floatingmenu/b;->n(Landroid/widget/Switch;)V

    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v13, -0x1

    const/4 v14, -0x2

    invoke-direct {v9, v13, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v13, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v14, 0x41600000    # 14.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v13, v14}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v13

    iput v13, v9, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I
    :try_end_4cd
    .catch Ljava/lang/Exception; {:try_start_481 .. :try_end_4cd} :catch_c31

    :try_start_4cd
    invoke-static {v12, v9}, Lcom/floatingmenu/b;->f(Landroid/widget/Switch;Landroid/widget/LinearLayout$LayoutParams;)V
    :try_end_4d0
    .catch Ljava/lang/Exception; {:try_start_4cd .. :try_end_4d0} :catch_c34

    :try_start_4d0
    invoke-virtual {v10, v12}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v13, Landroid/widget/LinearLayout;

    iget-object v9, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v13, v9}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v9, 0x1

    invoke-virtual {v13, v9}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    move-object/from16 v43, v11

    const/4 v11, -0x2

    const/4 v14, -0x1

    invoke-direct {v9, v14, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v13, v9}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const/16 v9, 0x8

    invoke-virtual {v13, v9}, Landroid/view/View;->setVisibility(I)V

    new-instance v11, Landroid/widget/TextView;

    iget-object v14, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v11, v14}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v14, "SIM 2 Provider:"

    invoke-virtual {v11, v14}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v14, -0x635c51

    invoke-virtual {v11, v14}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v9, 0x41300000    # 11.0f

    const/4 v14, 0x2

    invoke-virtual {v11, v14, v9}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-virtual {v11, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v13, v11}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    const/4 v4, 0x1

    new-array v14, v4, [Ljava/lang/String;

    const/4 v4, 0x0

    aput-object v2, v14, v4

    iget-object v2, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->createProviderSelector(Landroid/app/Activity;[Ljava/lang/String;)Landroid/widget/LinearLayout;
    invoke-static {v2, v14}, Lcom/floatingmenu/FloatingMenu;->access$100(Landroid/app/Activity;[Ljava/lang/String;)Landroid/widget/LinearLayout;

    move-result-object v11

    invoke-virtual {v13, v11}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/TextView;

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v2, v4}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v4, "SIM 2 Number:"

    invoke-virtual {v2, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v4, -0x635c51

    invoke-virtual {v2, v4}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v4, 0x2

    const/high16 v9, 0x41300000    # 11.0f

    invoke-virtual {v2, v4, v9}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-virtual {v2, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v13, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v9, Landroid/widget/EditText;

    iget-object v2, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v9, v2}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    const/4 v2, -0x1

    invoke-virtual {v9, v2}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v2, 0x2

    const/high16 v3, 0x41500000    # 13.0f

    invoke-virtual {v9, v2, v3}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-virtual {v9, v1}, Landroid/widget/TextView;->setHint(Ljava/lang/CharSequence;)V

    const v1, -0xb4aa9d

    invoke-virtual {v9, v1}, Landroid/widget/TextView;->setHintTextColor(I)V
    :try_end_554
    .catch Ljava/lang/Exception; {:try_start_4d0 .. :try_end_554} :catch_c31

    :try_start_554
    invoke-static {v9, v8}, Lcom/floatingmenu/a;->e(Landroid/widget/EditText;Landroid/graphics/drawable/GradientDrawable;)V
    :try_end_557
    .catch Ljava/lang/Exception; {:try_start_554 .. :try_end_557} :catch_c34

    :try_start_557
    iget-object v1, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v2, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v1, v2}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v1

    iget-object v3, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v4, 0x40c00000    # 6.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v3, v4}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v3

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v2}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    iget-object v2, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    move-object/from16 v19, v11

    const/high16 v11, 0x40c00000    # 6.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v2, v11}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v2

    invoke-virtual {v9, v1, v3, v4, v2}, Landroid/view/View;->setPadding(IIII)V

    invoke-virtual {v9, v7}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v13, v9}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    invoke-virtual {v10, v13}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v1, Landroid/widget/TextView;

    iget-object v2, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v1, v2}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v2, "Mock Country ISO (2-letter):"

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v7, -0x635c51

    invoke-virtual {v1, v7}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v2, 0x2

    const/high16 v11, 0x41300000    # 11.0f

    invoke-virtual {v1, v2, v11}, Landroid/widget/TextView;->setTextSize(IF)V

    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v3, -0x1

    const/4 v4, -0x2

    invoke-direct {v2, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v3, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v4, 0x41200000    # 10.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v3, v4}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v3

    iput v3, v2, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v1, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v10, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v4, Landroid/widget/EditText;

    iget-object v1, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v4, v1}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    const/4 v1, -0x1

    invoke-virtual {v4, v1}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v1, 0x2

    const/high16 v3, 0x41500000    # 13.0f

    invoke-virtual {v4, v1, v3}, Landroid/widget/TextView;->setTextSize(IF)V

    const-string v1, "e.g. in, us, ae"

    invoke-virtual {v4, v1}, Landroid/widget/TextView;->setHint(Ljava/lang/CharSequence;)V

    const v2, -0xb4aa9d

    invoke-virtual {v4, v2}, Landroid/widget/TextView;->setHintTextColor(I)V
    :try_end_5ce
    .catch Ljava/lang/Exception; {:try_start_557 .. :try_end_5ce} :catch_c31

    :try_start_5ce
    invoke-static {v4, v8}, Lcom/floatingmenu/a;->e(Landroid/widget/EditText;Landroid/graphics/drawable/GradientDrawable;)V
    :try_end_5d1
    .catch Ljava/lang/Exception; {:try_start_5ce .. :try_end_5d1} :catch_c34

    :try_start_5d1
    iget-object v1, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v8, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v1, v8}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v1

    iget-object v2, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v11, 0x40c00000    # 6.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v2, v11}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v2

    iget-object v3, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v3, v8}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v3

    iget-object v8, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v8, v11}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v8

    invoke-virtual {v4, v1, v2, v3, v8}, Landroid/view/View;->setPadding(IIII)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v2, -0x1

    const/4 v3, -0x2

    invoke-direct {v1, v2, v3}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v2, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v8, 0x40800000    # 4.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v2, v8}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v2

    iput v2, v1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v4, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v10, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/widget/Switch;

    iget-object v1, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v3, v1}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V

    invoke-static {v3}, Lcom/floatingmenu/b;->o(Landroid/widget/Switch;)V

    invoke-static {v3}, Lcom/floatingmenu/b;->m(Landroid/widget/Switch;)V

    invoke-static {v3}, Lcom/floatingmenu/b;->n(Landroid/widget/Switch;)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v2, -0x1

    const/4 v7, -0x2

    invoke-direct {v1, v2, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v2, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v7, 0x41600000    # 14.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v2, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v2

    iput v2, v1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I
    :try_end_628
    .catch Ljava/lang/Exception; {:try_start_5d1 .. :try_end_628} :catch_c31

    :try_start_628
    invoke-static {v3, v1}, Lcom/floatingmenu/b;->f(Landroid/widget/Switch;Landroid/widget/LinearLayout$LayoutParams;)V
    :try_end_62b
    .catch Ljava/lang/Exception; {:try_start_628 .. :try_end_62b} :catch_c34

    :try_start_62b
    invoke-virtual {v10, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/Switch;

    iget-object v1, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v2, v1}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V

    invoke-static {v2}, Lcom/floatingmenu/b;->p(Landroid/widget/Switch;)V

    invoke-static {v2}, Lcom/floatingmenu/b;->m(Landroid/widget/Switch;)V

    invoke-static {v2}, Lcom/floatingmenu/b;->n(Landroid/widget/Switch;)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v7, -0x1

    const/4 v8, -0x2

    invoke-direct {v1, v7, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v7, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v8, 0x41200000    # 10.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v7, v8}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v7

    iput v7, v1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I
    :try_end_64f
    .catch Ljava/lang/Exception; {:try_start_62b .. :try_end_64f} :catch_c31

    :try_start_64f
    invoke-static {v2, v1}, Lcom/floatingmenu/b;->f(Landroid/widget/Switch;Landroid/widget/LinearLayout$LayoutParams;)V
    :try_end_652
    .catch Ljava/lang/Exception; {:try_start_64f .. :try_end_652} :catch_c34

    :try_start_652
    invoke-virtual {v10, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v1, Lcom/floatingmenu/FloatingMenu$1$1;

    invoke-direct {v1, v15, v6}, Lcom/floatingmenu/FloatingMenu$1$1;-><init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/LinearLayout;)V

    invoke-static {v5, v1}, Lcom/floatingmenu/b;->e(Landroid/widget/Switch;Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    new-instance v1, Lcom/floatingmenu/FloatingMenu$1$2;

    invoke-direct {v1, v15, v13}, Lcom/floatingmenu/FloatingMenu$1$2;-><init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/LinearLayout;)V

    invoke-static {v12, v1}, Lcom/floatingmenu/b;->e(Landroid/widget/Switch;Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    new-instance v7, Landroid/widget/Button;

    iget-object v1, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v7, v1}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v1, "Save SIM Settings"

    invoke-virtual {v7, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 v1, -0x1

    invoke-virtual {v7, v1}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v1, 0x2

    const/high16 v8, 0x41400000    # 12.0f

    invoke-virtual {v7, v1, v8}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-static {v7}, Lcom/floatingmenu/b;->c(Landroid/widget/Button;)V

    new-instance v1, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v1}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v8, 0x0

    invoke-virtual {v1, v8}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    move-object/from16 v20, v13

    const v13, -0xda9c15

    invoke-virtual {v1, v13}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    iget-object v8, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v11, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v8, v11}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v8

    int-to-float v8, v8

    invoke-virtual {v1, v8}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    :try_end_69b
    .catch Ljava/lang/Exception; {:try_start_652 .. :try_end_69b} :catch_c31

    :try_start_69b
    invoke-static {v7, v1}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V
    :try_end_69e
    .catch Ljava/lang/Exception; {:try_start_69b .. :try_end_69e} :catch_c34

    :try_start_69e
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    iget-object v8, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v13, 0x42180000    # 38.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v8, v13}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v8

    const/4 v11, -0x1

    invoke-direct {v1, v11, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v8, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v11, 0x41800000    # 16.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v8, v11}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v8

    iput v8, v1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v7, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v8, Lcom/floatingmenu/FloatingMenu$1$3;
    :try_end_6bb
    .catch Ljava/lang/Exception; {:try_start_69e .. :try_end_6bb} :catch_c31

    const/16 v22, 0x2

    move-object v1, v8

    move-object/from16 v37, v2

    const v24, -0xb4aa9d

    move-object/from16 v2, p0

    move-object/from16 v44, v3

    const/high16 v38, 0x41500000    # 13.0f

    move-object v3, v5

    move-object/from16 v33, v4

    const/16 v17, 0x11

    move-object/from16 v4, v42

    move-object/from16 v25, v5

    move-object/from16 v45, v30

    const/16 v21, 0x8

    move-object/from16 v5, v43

    move-object/from16 v26, v6

    move-object/from16 v23, v16

    const v16, -0xc8beaf

    move-object v6, v12

    move-object v13, v7

    move-object/from16 v46, v31

    move-object/from16 v17, v42

    const/16 v11, 0x11

    const/high16 v27, 0x41600000    # 14.0f

    move-object v7, v14

    move-object v15, v8

    move-object/from16 v47, v29

    const/high16 v16, 0x40800000    # 4.0f

    move-object v8, v9

    move-object/from16 v18, v9

    move-object/from16 v48, v35

    move-object/from16 v9, v33

    move-object/from16 v22, v14

    move-object/from16 v49, v28

    move-object v14, v10

    move-object/from16 v10, v44

    move-object/from16 v16, v43

    move-object/from16 v11, v37

    :try_start_701
    invoke-direct/range {v1 .. v11}, Lcom/floatingmenu/FloatingMenu$1$3;-><init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/Switch;[Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/Switch;[Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/Switch;Landroid/widget/Switch;)V

    invoke-virtual {v13, v15}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v14, v13}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v15, Ljava/lang/Thread;

    new-instance v13, Lcom/floatingmenu/FloatingMenu$1$4;
    :try_end_70e
    .catch Ljava/lang/Exception; {:try_start_701 .. :try_end_70e} :catch_c2b

    move-object v1, v13

    move-object/from16 v2, p0

    move-object/from16 v3, v25

    move-object/from16 v4, v26

    move-object/from16 v5, v17

    move-object/from16 v6, v34

    move-object/from16 v7, v16

    move-object v8, v12

    move-object/from16 v9, v20

    move-object/from16 v10, v22

    move-object/from16 v11, v19

    move-object/from16 v50, v39

    move-object/from16 v12, v18

    move-object/from16 v52, v13

    move-object/from16 v51, v40

    move-object/from16 v13, v33

    move-object/from16 v16, v14

    move-object/from16 v53, v41

    move-object/from16 v14, v44

    move-object/from16 v54, v15

    move-object/from16 v15, v37

    :try_start_736
    invoke-direct/range {v1 .. v15}, Lcom/floatingmenu/FloatingMenu$1$4;-><init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/Switch;Landroid/widget/LinearLayout;[Ljava/lang/String;Landroid/widget/LinearLayout;Landroid/widget/EditText;Landroid/widget/Switch;Landroid/widget/LinearLayout;[Ljava/lang/String;Landroid/widget/LinearLayout;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/Switch;Landroid/widget/Switch;)V

    move-object/from16 v2, v52

    move-object/from16 v1, v54

    invoke-direct {v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v1}, Ljava/lang/Thread;->start()V

    new-instance v9, Landroid/widget/Switch;
    :try_end_745
    .catch Ljava/lang/Exception; {:try_start_736 .. :try_end_745} :catch_c27

    move-object/from16 v11, p0

    :try_start_747
    iget-object v1, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v9, v1}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V

    invoke-static {v9}, Lcom/floatingmenu/b;->d(Landroid/widget/Switch;)V

    invoke-static {v9}, Lcom/floatingmenu/b;->m(Landroid/widget/Switch;)V

    invoke-static {v9}, Lcom/floatingmenu/b;->n(Landroid/widget/Switch;)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v12, -0x1

    const/4 v13, -0x2

    invoke-direct {v1, v12, v13}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v2, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v10, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v2, v10}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v2

    iput v2, v1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-static {v9, v1}, Lcom/floatingmenu/b;->f(Landroid/widget/Switch;Landroid/widget/LinearLayout$LayoutParams;)V

    sget-boolean v1, Lcom/floatingmenu/FloatingMenu;->sHookIncoming:Z

    invoke-static {v9, v1}, Lcom/floatingmenu/b;->g(Landroid/widget/Switch;Z)V

    move-object/from16 v14, v46

    invoke-virtual {v14, v9}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v15, Landroid/widget/Switch;

    iget-object v1, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v15, v1}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V

    invoke-static {v15}, Lcom/floatingmenu/b;->j(Landroid/widget/Switch;)V

    invoke-static {v15}, Lcom/floatingmenu/b;->m(Landroid/widget/Switch;)V

    invoke-static {v15}, Lcom/floatingmenu/b;->n(Landroid/widget/Switch;)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v1, v12, v13}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v2, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v2, v10}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v2

    iput v2, v1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-static {v15, v1}, Lcom/floatingmenu/b;->f(Landroid/widget/Switch;Landroid/widget/LinearLayout$LayoutParams;)V

    sget-boolean v1, Lcom/floatingmenu/FloatingMenu;->sHookOutgoing:Z

    invoke-static {v15, v1}, Lcom/floatingmenu/b;->g(Landroid/widget/Switch;Z)V

    invoke-virtual {v14, v15}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/view/View;

    iget-object v1, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v3, v1}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    iget-object v2, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v4, 0x3f800000    # 1.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v2, v4}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v2

    invoke-direct {v1, v12, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v2, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v8, 0x41200000    # 10.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v2, v8}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v2

    iput v2, v1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    iget-object v2, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v7, 0x40c00000    # 6.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v2, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v2

    iput v2, v1, Landroid/widget/LinearLayout$LayoutParams;->bottomMargin:I

    invoke-virtual {v3, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const v6, -0xc8beaf

    invoke-virtual {v3, v6}, Landroid/view/View;->setBackgroundColor(I)V

    invoke-virtual {v14, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v4, Landroid/widget/TextView;

    iget-object v1, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v4, v1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v1, "Sender ID:"

    invoke-virtual {v4, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v5, -0x635c51

    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v1, 0x41300000    # 11.0f

    const/4 v2, 0x2

    invoke-virtual {v4, v2, v1}, Landroid/widget/TextView;->setTextSize(IF)V

    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v6, v12, v13}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v8, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v8, v10}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v8

    iput v8, v6, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v4, v6}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v14, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v6, Landroid/widget/EditText;

    iget-object v8, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v6, v8}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    # getter for: Lcom/floatingmenu/FloatingMenu;->sSenderText:Ljava/lang/String;
    invoke-static {}, Lcom/floatingmenu/FloatingMenu;->access$400()Ljava/lang/String;

    move-result-object v8

    invoke-virtual {v6, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {v6, v12}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v8, 0x41500000    # 13.0f

    invoke-virtual {v6, v2, v8}, Landroid/widget/TextView;->setTextSize(IF)V

    const-string v8, "e.g. AD-TEST-S"

    invoke-virtual {v6, v8}, Landroid/widget/TextView;->setHint(Ljava/lang/CharSequence;)V

    const v8, -0xb4aa9d

    invoke-virtual {v6, v8}, Landroid/widget/TextView;->setHintTextColor(I)V

    new-instance v8, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v8}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v1, 0x0

    invoke-virtual {v8, v1}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    const v1, -0xe0d6c9

    invoke-virtual {v8, v1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    iget-object v1, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v1, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v1

    int-to-float v1, v1

    invoke-virtual {v8, v1}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    invoke-static {v6, v8}, Lcom/floatingmenu/a;->e(Landroid/widget/EditText;Landroid/graphics/drawable/GradientDrawable;)V

    iget-object v1, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v1, v10}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v1

    iget-object v2, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v2, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v2

    iget-object v5, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v5, v10}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v5

    iget-object v10, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v10, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v10

    invoke-virtual {v6, v1, v2, v5, v10}, Landroid/view/View;->setPadding(IIII)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v1, v12, v13}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v2, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v10, 0x40800000    # 4.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v2, v10}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v2

    iput v2, v1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v6, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v1, Lcom/floatingmenu/FloatingMenu$1$5;

    invoke-direct {v1, v11}, Lcom/floatingmenu/FloatingMenu$1$5;-><init>(Lcom/floatingmenu/FloatingMenu$1;)V

    invoke-virtual {v6, v1}, Landroid/widget/TextView;->addTextChangedListener(Landroid/text/TextWatcher;)V

    invoke-virtual {v14, v6}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/TextView;

    iget-object v1, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v5, v1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v1, "Message Body:"

    invoke-virtual {v5, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v2, -0x635c51

    invoke-virtual {v5, v2}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v1, 0x2

    const/high16 v2, 0x41300000    # 11.0f

    invoke-virtual {v5, v1, v2}, Landroid/widget/TextView;->setTextSize(IF)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v1, v12, v13}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v2, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v10, 0x41200000    # 10.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v2, v10}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v2

    iput v2, v1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v5, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v14, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/EditText;

    iget-object v1, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v2, v1}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    const-string v1, "Type your message body (e.g. Your verification OTP code is 918204)"

    invoke-virtual {v2, v1}, Landroid/widget/TextView;->setHint(Ljava/lang/CharSequence;)V

    # getter for: Lcom/floatingmenu/FloatingMenu;->sBodyText:Ljava/lang/String;
    invoke-static {}, Lcom/floatingmenu/FloatingMenu;->access$500()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {v2, v12}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v1, 0x2

    const/high16 v10, 0x41400000    # 12.0f

    invoke-virtual {v2, v1, v10}, Landroid/widget/TextView;->setTextSize(IF)V

    const v1, -0xb4aa9d

    invoke-virtual {v2, v1}, Landroid/widget/TextView;->setHintTextColor(I)V

    invoke-static {v2, v8}, Lcom/floatingmenu/a;->e(Landroid/widget/EditText;Landroid/graphics/drawable/GradientDrawable;)V

    const/4 v1, 0x0

    invoke-virtual {v2, v1}, Landroid/widget/TextView;->setSingleLine(Z)V

    const/4 v1, 0x3

    invoke-virtual {v2, v1}, Landroid/widget/TextView;->setLines(I)V

    const/16 v1, 0x33

    invoke-virtual {v2, v1}, Landroid/widget/TextView;->setGravity(I)V

    iget-object v1, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v7, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v1, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v1

    iget-object v10, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v10, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v10

    iget-object v12, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v12, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v12

    iget-object v13, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v13, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v13

    invoke-virtual {v2, v1, v10, v12, v13}, Landroid/view/View;->setPadding(IIII)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v7, -0x1

    const/4 v10, -0x2

    invoke-direct {v1, v7, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v7, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v10, 0x40800000    # 4.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v7, v10}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v7

    iput v7, v1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v2, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v1, Lcom/floatingmenu/FloatingMenu$1$6;

    invoke-direct {v1, v11}, Lcom/floatingmenu/FloatingMenu$1$6;-><init>(Lcom/floatingmenu/FloatingMenu$1;)V

    invoke-virtual {v2, v1}, Landroid/widget/TextView;->addTextChangedListener(Landroid/text/TextWatcher;)V

    invoke-virtual {v14, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v10, Landroid/widget/Button;

    iget-object v1, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v10, v1}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v1, "Inject Local SMS"

    invoke-virtual {v10, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 v1, -0x1

    invoke-virtual {v10, v1}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v1, 0x41400000    # 12.0f

    const/4 v7, 0x2

    invoke-virtual {v10, v7, v1}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-static {v10}, Lcom/floatingmenu/b;->c(Landroid/widget/Button;)V

    new-instance v1, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v1}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v12, 0x0

    invoke-virtual {v1, v12}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    const v13, -0xda9c15

    invoke-virtual {v1, v13}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    iget-object v13, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v7, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v13, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v13

    int-to-float v7, v13

    invoke-virtual {v1, v7}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    invoke-static {v10, v1}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    iget-object v7, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v13, 0x42180000    # 38.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v7, v13}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v7

    const/4 v12, -0x1

    invoke-direct {v1, v12, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v7, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v12, 0x41600000    # 14.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v7, v12}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v7

    iput v7, v1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v10, v1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v1, Lcom/floatingmenu/FloatingMenu$1$7;

    invoke-direct {v1, v11, v6, v2}, Lcom/floatingmenu/FloatingMenu$1$7;-><init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/EditText;Landroid/widget/EditText;)V

    invoke-virtual {v10, v1}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v14, v10}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    sget-boolean v1, Lcom/floatingmenu/FloatingMenu;->sHookIncoming:Z

    if-eqz v1, :cond_96d

    const/4 v1, 0x0

    goto :goto_96f

    :cond_96d
    const/16 v1, 0x8

    :goto_96f
    invoke-virtual {v3, v1}, Landroid/view/View;->setVisibility(I)V

    invoke-virtual {v4, v1}, Landroid/view/View;->setVisibility(I)V

    invoke-virtual {v6, v1}, Landroid/view/View;->setVisibility(I)V

    invoke-virtual {v5, v1}, Landroid/view/View;->setVisibility(I)V

    invoke-virtual {v2, v1}, Landroid/view/View;->setVisibility(I)V

    invoke-virtual {v10, v1}, Landroid/view/View;->setVisibility(I)V

    new-instance v7, Lcom/floatingmenu/FloatingMenu$1$8;

    const/4 v12, 0x0

    const/high16 v13, 0x41300000    # 11.0f

    const v17, -0xb4aa9d

    move-object v1, v7

    move-object/from16 v19, v2

    const/4 v12, 0x2

    const v18, -0x635c51

    move-object/from16 v2, p0

    move-object/from16 v18, v5

    const v13, -0x635c51

    move-object v5, v6

    move-object/from16 v6, v18

    move-object v12, v7

    move-object/from16 v7, v19

    move-object/from16 v55, v8

    move-object v8, v10

    invoke-direct/range {v1 .. v8}, Lcom/floatingmenu/FloatingMenu$1$8;-><init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/view/View;Landroid/widget/TextView;Landroid/widget/EditText;Landroid/widget/TextView;Landroid/widget/EditText;Landroid/widget/Button;)V

    invoke-static {v9, v12}, Lcom/floatingmenu/b;->e(Landroid/widget/Switch;Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    new-instance v1, Lcom/floatingmenu/FloatingMenu$1$9;

    invoke-direct {v1, v11}, Lcom/floatingmenu/FloatingMenu$1$9;-><init>(Lcom/floatingmenu/FloatingMenu$1;)V

    invoke-static {v15, v1}, Lcom/floatingmenu/b;->e(Landroid/widget/Switch;Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    new-instance v1, Landroid/widget/TextView;

    iget-object v2, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v1, v2}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v2, "Configure Telegram bot credentials to forward blocked outgoing SMS automatically."

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {v1, v13}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v2, 0x2

    const/high16 v3, 0x41400000    # 12.0f

    invoke-virtual {v1, v2, v3}, Landroid/widget/TextView;->setTextSize(IF)V

    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v3, -0x1

    const/4 v4, -0x2

    invoke-direct {v2, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v3, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v4, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v3, v4}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v3

    iput v3, v2, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v1, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    move-object/from16 v12, v45

    invoke-virtual {v12, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v1, Landroid/widget/TextView;

    iget-object v2, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v1, v2}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v2, "Telegram Bot Token:"

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {v1, v13}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v2, 0x2

    const/high16 v3, 0x41300000    # 11.0f

    invoke-virtual {v1, v2, v3}, Landroid/widget/TextView;->setTextSize(IF)V

    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v3, -0x1

    const/4 v4, -0x2

    invoke-direct {v2, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v3, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v15, 0x41200000    # 10.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v3, v15}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v3

    iput v3, v2, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v1, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v12, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v1, Landroid/widget/EditText;

    iget-object v2, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v1, v2}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    const-string v2, "e.g. 123456789:ABCdefGhI..."

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setHint(Ljava/lang/CharSequence;)V

    const/4 v2, -0x1

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v2, 0x2

    const/high16 v3, 0x41400000    # 12.0f

    invoke-virtual {v1, v2, v3}, Landroid/widget/TextView;->setTextSize(IF)V

    const v2, -0xb4aa9d

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setHintTextColor(I)V

    move-object/from16 v3, v55

    invoke-static {v1, v3}, Lcom/floatingmenu/a;->e(Landroid/widget/EditText;Landroid/graphics/drawable/GradientDrawable;)V

    iget-object v4, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v5, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v5}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    iget-object v6, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v6, v5}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v6

    iget-object v7, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v7, v5}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v7

    iget-object v8, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v8, v5}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v8

    invoke-virtual {v1, v4, v6, v7, v8}, Landroid/view/View;->setPadding(IIII)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, -0x1

    const/4 v6, -0x2

    invoke-direct {v4, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v5, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v6, 0x40800000    # 4.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v5, v6}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v5

    iput v5, v4, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v1, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v12, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/TextView;

    iget-object v6, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v5, v6}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v6, "Telegram Chat ID:"

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-virtual {v5, v13}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v6, 0x2

    const/high16 v7, 0x41300000    # 11.0f

    invoke-virtual {v5, v6, v7}, Landroid/widget/TextView;->setTextSize(IF)V

    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v7, -0x1

    const/4 v8, -0x2

    invoke-direct {v6, v7, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v7, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v7, v15}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v7

    iput v7, v6, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v5, v6}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v12, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v5, Landroid/widget/EditText;

    iget-object v6, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v5, v6}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    const-string v6, "e.g. 987654321 or -100123456"

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setHint(Ljava/lang/CharSequence;)V

    const/4 v6, -0x1

    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v6, 0x2

    const/high16 v7, 0x41400000    # 12.0f

    invoke-virtual {v5, v6, v7}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-virtual {v5, v2}, Landroid/widget/TextView;->setHintTextColor(I)V

    invoke-static {v5, v3}, Lcom/floatingmenu/a;->e(Landroid/widget/EditText;Landroid/graphics/drawable/GradientDrawable;)V

    iget-object v2, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v3, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v2, v3}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v2

    iget-object v6, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v6, v3}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v6

    iget-object v7, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v7, v3}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v7

    iget-object v8, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v8, v3}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v8

    invoke-virtual {v5, v2, v6, v7, v8}, Landroid/view/View;->setPadding(IIII)V

    invoke-virtual {v5, v4}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v12, v5}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v2, Ljava/lang/Thread;

    new-instance v3, Lcom/floatingmenu/FloatingMenu$1$10;

    invoke-direct {v3, v11, v1, v5}, Lcom/floatingmenu/FloatingMenu$1$10;-><init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/EditText;Landroid/widget/EditText;)V

    invoke-direct {v2, v3}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v2}, Ljava/lang/Thread;->start()V

    new-instance v2, Landroid/widget/Button;

    iget-object v3, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v2, v3}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v3, "Verify & Submit"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 v3, -0x1

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v3, 0x2

    const/high16 v4, 0x41400000    # 12.0f

    invoke-virtual {v2, v3, v4}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-static {v2}, Lcom/floatingmenu/b;->c(Landroid/widget/Button;)V

    new-instance v3, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v3}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    const v4, -0xef467f

    invoke-virtual {v3, v4}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    iget-object v4, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v6, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v6}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    int-to-float v4, v4

    invoke-virtual {v3, v4}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    invoke-static {v2, v3}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    iget-object v4, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v6, 0x42180000    # 38.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v6}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    const/4 v6, -0x1

    invoke-direct {v3, v6, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v4, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v6, 0x41600000    # 14.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v6}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    iput v4, v3, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v2, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v3, Lcom/floatingmenu/FloatingMenu$1$11;

    invoke-direct {v3, v11, v1, v5}, Lcom/floatingmenu/FloatingMenu$1$11;-><init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/EditText;Landroid/widget/EditText;)V

    invoke-virtual {v2, v3}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v12, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v13, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v13}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v1, 0x0

    invoke-virtual {v13, v1}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    const v1, -0xc8beaf

    invoke-virtual {v13, v1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    iget-object v1, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v2, 0x40c00000    # 6.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v1, v2}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v1

    int-to-float v1, v1

    invoke-virtual {v13, v1}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    new-instance v10, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v10}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v1, 0x0

    invoke-virtual {v10, v1}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    const v1, -0xe0d6c9

    invoke-virtual {v10, v1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    iget-object v1, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v1, v2}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v1

    int-to-float v1, v1

    invoke-virtual {v10, v1}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    new-instance v9, Lcom/floatingmenu/FloatingMenu$1$12;

    move-object v1, v9

    move-object/from16 v2, p0

    move-object/from16 v3, v23

    move-object v4, v10

    move-object/from16 v5, v36

    move-object v6, v13

    move-object/from16 v7, v32

    move-object/from16 v8, v16

    move-object v15, v9

    move-object v9, v14

    move-object/from16 v17, v10

    move-object v10, v12

    invoke-direct/range {v1 .. v10}, Lcom/floatingmenu/FloatingMenu$1$12;-><init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;Landroid/widget/Button;Landroid/widget/LinearLayout;Landroid/widget/LinearLayout;Landroid/widget/LinearLayout;)V

    new-instance v10, Lcom/floatingmenu/FloatingMenu$1$13;

    move-object v1, v10

    move-object/from16 v2, p0

    move-object/from16 v3, v23

    move-object v4, v13

    move-object/from16 v5, v36

    move-object/from16 v6, v17

    move-object/from16 v7, v32

    move-object/from16 v8, v16

    move-object v9, v14

    move-object/from16 v18, v15

    move-object v15, v10

    move-object v10, v12

    invoke-direct/range {v1 .. v10}, Lcom/floatingmenu/FloatingMenu$1$13;-><init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;Landroid/widget/Button;Landroid/widget/LinearLayout;Landroid/widget/LinearLayout;Landroid/widget/LinearLayout;)V

    new-instance v10, Lcom/floatingmenu/FloatingMenu$1$14;

    move-object v1, v10

    move-object/from16 v2, p0

    move-object/from16 v3, v23

    move-object/from16 v4, v17

    move-object/from16 v5, v36

    move-object/from16 v6, v32

    move-object v7, v13

    move-object/from16 v8, v16

    move-object v9, v14

    move-object v13, v10

    move-object v10, v12

    invoke-direct/range {v1 .. v10}, Lcom/floatingmenu/FloatingMenu$1$14;-><init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;Landroid/widget/Button;Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;Landroid/widget/LinearLayout;Landroid/widget/LinearLayout;Landroid/widget/LinearLayout;)V

    new-instance v1, Lcom/floatingmenu/FloatingMenu$1$15;

    invoke-direct {v1, v11, v15}, Lcom/floatingmenu/FloatingMenu$1$15;-><init>(Lcom/floatingmenu/FloatingMenu$1;Ljava/lang/Runnable;)V

    move-object/from16 v2, v23

    invoke-virtual {v2, v1}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v1, Lcom/floatingmenu/FloatingMenu$1$16;

    move-object/from16 v2, v18

    invoke-direct {v1, v11, v2}, Lcom/floatingmenu/FloatingMenu$1$16;-><init>(Lcom/floatingmenu/FloatingMenu$1;Ljava/lang/Runnable;)V

    move-object/from16 v3, v36

    invoke-virtual {v3, v1}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v1, Lcom/floatingmenu/FloatingMenu$1$17;

    invoke-direct {v1, v11, v13}, Lcom/floatingmenu/FloatingMenu$1$17;-><init>(Lcom/floatingmenu/FloatingMenu$1;Ljava/lang/Runnable;)V

    move-object/from16 v3, v32

    invoke-virtual {v3, v1}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-interface {v2}, Ljava/lang/Runnable;->run()V

    new-instance v1, Landroid/widget/TextView;

    iget-object v2, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v1, v2}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v2, "Zygisk Injected. Developed for Android."

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v2, -0x948d80

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v2, 0x2

    const/high16 v3, 0x41200000    # 10.0f

    invoke-virtual {v1, v2, v3}, Landroid/widget/TextView;->setTextSize(IF)V

    const/16 v2, 0x11

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setGravity(I)V

    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v3, -0x1

    const/4 v4, -0x2

    invoke-direct {v2, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v3, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v4, 0x41800000    # 16.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v3, v4}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v3

    iput v3, v2, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v1, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    move-object/from16 v2, v48

    invoke-virtual {v2, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    move-object/from16 v3, v49

    move-object/from16 v1, v50

    invoke-virtual {v1, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    invoke-virtual {v1, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    move-object/from16 v4, v51

    invoke-virtual {v4, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v1, Lcom/floatingmenu/FloatingMenu$1$18;

    invoke-direct {v1, v11, v3, v2}, Lcom/floatingmenu/FloatingMenu$1$18;-><init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/FrameLayout;Landroid/widget/LinearLayout;)V

    invoke-virtual {v3, v1}, Landroid/view/View;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    new-instance v1, Lcom/floatingmenu/FloatingMenu$1$19;

    invoke-direct {v1, v11, v2, v3}, Lcom/floatingmenu/FloatingMenu$1$19;-><init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/LinearLayout;Landroid/widget/FrameLayout;)V

    move-object/from16 v2, v47

    invoke-virtual {v2, v1}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V
    :try_end_c23
    .catch Ljava/lang/Exception; {:try_start_747 .. :try_end_c23} :catch_c24

    goto :goto_c43

    :catch_c24
    move-exception v0

    :goto_c25
    move-object v1, v0

    goto :goto_c3c

    :catch_c27
    move-exception v0

    move-object/from16 v11, p0

    goto :goto_c25

    :catch_c2b
    move-exception v0

    move-object/from16 v11, p0

    :goto_c2e
    move-object/from16 v53, v41

    goto :goto_c25

    :catch_c31
    move-exception v0

    move-object v11, v15

    goto :goto_c2e

    :catch_c34
    move-exception v0

    move-object v11, v15

    goto :goto_c2e

    :catch_c37
    move-exception v0

    move-object/from16 v53, v14

    move-object v11, v15

    goto :goto_c25

    :goto_c3c
    const-string v2, "Error in FloatingMenu.show"

    move-object/from16 v3, v53

    invoke-static {v3, v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_c43
    return-void
.end method
