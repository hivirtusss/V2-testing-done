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

    const/high16 v5, 0x42780000    # 62.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v5}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    new-instance v5, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v5, v4, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    const/16 v9, 0x11

    iput v9, v5, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v6, 0x0

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v6}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    iput v4, v5, Landroid/widget/FrameLayout$LayoutParams;->leftMargin:I

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v7, 0x0

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v7}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v4

    iput v4, v5, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    invoke-virtual {v10, v5}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v4, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v4}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v5, 0x1

    invoke-virtual {v4, v5}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    const v7, -0x1000000

    const v8, -0x760000

    filled-new-array {v7, v8}, [I

    move-result-object v7

    invoke-static {v4, v7}, Lcom/floatingmenu/a;->b(Landroid/graphics/drawable/GradientDrawable;[I)V

    iget-object v7, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v8, 0x40000000    # 2.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v7, v8}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v7

    const v11, -0xff0033

    invoke-virtual {v4, v7, v11}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    invoke-static {v10, v4}, Lcom/floatingmenu/a;->f(Landroid/widget/FrameLayout;Landroid/graphics/drawable/GradientDrawable;)V
    :try_end_8a
    .catch Ljava/lang/Exception; {:try_start_a .. :try_end_8a} :catch_c3d

    const/4 v4, 0x0

    const/4 v8, 0x2

    const/4 v7, 0x0

    :try_start_8d
    const-string v9, "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"

    invoke-static {v9, v4}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object v9

    array-length v5, v9

    invoke-static {v9, v4, v5}, Landroid/graphics/BitmapFactory;->decodeByteArray([BII)Landroid/graphics/Bitmap;

    move-result-object v5

    if-eqz v5, :cond_bf

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

    const/16 v5, 0x11

    iput v5, v4, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    invoke-virtual {v10, v9, v4}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
    :try_end_be
    .catch Ljava/lang/Exception; {:try_start_8d .. :try_end_be} :catch_bf

    goto :goto_e6

    :catch_bf
    :cond_bf
    :try_start_bf
    new-instance v4, Landroid/widget/TextView;

    iget-object v5, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v4, v5}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v5, "V"

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

    :goto_e6
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

    const v5, -0x19ededee

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

    const v8, -0x3be1c6

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

    const-string v8, "Zygisk Mode Menu Virtus V3"

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

    const v5, -0x50306

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

    const v4, -0x3be1c6

    invoke-virtual {v3, v4}, Landroid/view/View;->setBackgroundColor(I)V

    invoke-virtual {v9, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v3, Landroid/widget/TextView;

    iget-object v4, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v3, v4}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v4, "System SIM Configuration"

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v4, -0x50306

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

    const v6, -0x3be1c6

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

    const v4, -0x50306

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

    const v3, -0x50306

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

    const v8, -0x888888

    invoke-virtual {v11, v8}, Landroid/widget/TextView;->setHintTextColor(I)V

    new-instance v8, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v8}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v9, 0x0

    invoke-virtual {v8, v9}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    const v9, -0x660000

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
    :try_end_483
    .catch Ljava/lang/Exception; {:try_start_bf .. :try_end_483} :catch_c3d

    move-object/from16 v41, v14

    const/high16 v14, 0x41000000    # 8.0f

    :try_start_487
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
    :try_end_4d3
    .catch Ljava/lang/Exception; {:try_start_487 .. :try_end_4d3} :catch_c37

    :try_start_4d3
    invoke-static {v12, v9}, Lcom/floatingmenu/b;->f(Landroid/widget/Switch;Landroid/widget/LinearLayout$LayoutParams;)V
    :try_end_4d6
    .catch Ljava/lang/Exception; {:try_start_4d3 .. :try_end_4d6} :catch_c3a

    :try_start_4d6
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

    const v14, -0x50306

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

    const v4, -0x50306

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

    const v1, -0x888888

    invoke-virtual {v9, v1}, Landroid/widget/TextView;->setHintTextColor(I)V
    :try_end_55a
    .catch Ljava/lang/Exception; {:try_start_4d6 .. :try_end_55a} :catch_c37

    :try_start_55a
    invoke-static {v9, v8}, Lcom/floatingmenu/a;->e(Landroid/widget/EditText;Landroid/graphics/drawable/GradientDrawable;)V
    :try_end_55d
    .catch Ljava/lang/Exception; {:try_start_55a .. :try_end_55d} :catch_c3a

    :try_start_55d
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

    const v7, -0x50306

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

    const v2, -0x888888

    invoke-virtual {v4, v2}, Landroid/widget/TextView;->setHintTextColor(I)V
    :try_end_5d4
    .catch Ljava/lang/Exception; {:try_start_55d .. :try_end_5d4} :catch_c37

    :try_start_5d4
    invoke-static {v4, v8}, Lcom/floatingmenu/a;->e(Landroid/widget/EditText;Landroid/graphics/drawable/GradientDrawable;)V
    :try_end_5d7
    .catch Ljava/lang/Exception; {:try_start_5d4 .. :try_end_5d7} :catch_c3a

    :try_start_5d7
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
    :try_end_62e
    .catch Ljava/lang/Exception; {:try_start_5d7 .. :try_end_62e} :catch_c37

    :try_start_62e
    invoke-static {v3, v1}, Lcom/floatingmenu/b;->f(Landroid/widget/Switch;Landroid/widget/LinearLayout$LayoutParams;)V
    :try_end_631
    .catch Ljava/lang/Exception; {:try_start_62e .. :try_end_631} :catch_c3a

    :try_start_631
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
    :try_end_655
    .catch Ljava/lang/Exception; {:try_start_631 .. :try_end_655} :catch_c37

    :try_start_655
    invoke-static {v2, v1}, Lcom/floatingmenu/b;->f(Landroid/widget/Switch;Landroid/widget/LinearLayout$LayoutParams;)V
    :try_end_658
    .catch Ljava/lang/Exception; {:try_start_655 .. :try_end_658} :catch_c3a

    :try_start_658
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

    const v13, -0x2cd0d1

    invoke-virtual {v1, v13}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    iget-object v8, v15, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const/high16 v11, 0x41000000    # 8.0f

    # invokes: Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v8, v11}, Lcom/floatingmenu/FloatingMenu;->access$000(Landroid/content/Context;F)I

    move-result v8

    int-to-float v8, v8

    invoke-virtual {v1, v8}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V
    :try_end_6a1
    .catch Ljava/lang/Exception; {:try_start_658 .. :try_end_6a1} :catch_c37

    :try_start_6a1
    invoke-static {v7, v1}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V
    :try_end_6a4
    .catch Ljava/lang/Exception; {:try_start_6a1 .. :try_end_6a4} :catch_c3a

    :try_start_6a4
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
    :try_end_6c1
    .catch Ljava/lang/Exception; {:try_start_6a4 .. :try_end_6c1} :catch_c37

    const/16 v22, 0x2

    move-object v1, v8

    move-object/from16 v37, v2

    const v24, -0x888888

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

    const v16, -0x3be1c6

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

    :try_start_707
    invoke-direct/range {v1 .. v11}, Lcom/floatingmenu/FloatingMenu$1$3;-><init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/Switch;[Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/Switch;[Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/Switch;Landroid/widget/Switch;)V

    invoke-virtual {v13, v15}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    invoke-virtual {v14, v13}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v15, Ljava/lang/Thread;

    new-instance v13, Lcom/floatingmenu/FloatingMenu$1$4;
    :try_end_714
    .catch Ljava/lang/Exception; {:try_start_707 .. :try_end_714} :catch_c31

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

    :try_start_73c
    invoke-direct/range {v1 .. v15}, Lcom/floatingmenu/FloatingMenu$1$4;-><init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/Switch;Landroid/widget/LinearLayout;[Ljava/lang/String;Landroid/widget/LinearLayout;Landroid/widget/EditText;Landroid/widget/Switch;Landroid/widget/LinearLayout;[Ljava/lang/String;Landroid/widget/LinearLayout;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/Switch;Landroid/widget/Switch;)V

    move-object/from16 v2, v52

    move-object/from16 v1, v54

    invoke-direct {v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v1}, Ljava/lang/Thread;->start()V

    new-instance v9, Landroid/widget/Switch;
    :try_end_74b
    .catch Ljava/lang/Exception; {:try_start_73c .. :try_end_74b} :catch_c2d

    move-object/from16 v11, p0

    :try_start_74d
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

    const v6, -0x3be1c6

    invoke-virtual {v3, v6}, Landroid/view/View;->setBackgroundColor(I)V

    invoke-virtual {v14, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    new-instance v4, Landroid/widget/TextView;

    iget-object v1, v11, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    invoke-direct {v4, v1}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v1, "Sender ID:"

    invoke-virtual {v4, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v5, -0x50306

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

    const v8, -0x888888

    invoke-virtual {v6, v8}, Landroid/widget/TextView;->setHintTextColor(I)V

    new-instance v8, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v8}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v1, 0x0

    invoke-virtual {v8, v1}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    const v1, -0x660000

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

    const v2, -0x50306

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

    const v1, -0x888888

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

    const v13, -0x2cd0d1

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

    if-eqz v1, :cond_973

    const/4 v1, 0x0

    goto :goto_975

    :cond_973
    const/16 v1, 0x8

    :goto_975
    invoke-virtual {v3, v1}, Landroid/view/View;->setVisibility(I)V

    invoke-virtual {v4, v1}, Landroid/view/View;->setVisibility(I)V

    invoke-virtual {v6, v1}, Landroid/view/View;->setVisibility(I)V

    invoke-virtual {v5, v1}, Landroid/view/View;->setVisibility(I)V

    invoke-virtual {v2, v1}, Landroid/view/View;->setVisibility(I)V

    invoke-virtual {v10, v1}, Landroid/view/View;->setVisibility(I)V

    new-instance v7, Lcom/floatingmenu/FloatingMenu$1$8;

    const/4 v12, 0x0

    const/high16 v13, 0x41300000    # 11.0f

    const v17, -0x888888

    move-object v1, v7

    move-object/from16 v19, v2

    const/4 v12, 0x2

    const v18, -0x50306

    move-object/from16 v2, p0

    move-object/from16 v18, v5

    const v13, -0x50306

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

    const v2, -0x888888

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

    const v4, -0x2cd0d1

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

    const v1, -0x3be1c6

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

    const v1, -0x660000

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

    const-string v2, "Virtus V3 Security Tester"

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const v2, -0x66999a

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
    :try_end_c29
    .catch Ljava/lang/Exception; {:try_start_74d .. :try_end_c29} :catch_c2a

    goto :goto_c49

    :catch_c2a
    move-exception v0

    :goto_c2b
    move-object v1, v0

    goto :goto_c42

    :catch_c2d
    move-exception v0

    move-object/from16 v11, p0

    goto :goto_c2b

    :catch_c31
    move-exception v0

    move-object/from16 v11, p0

    :goto_c34
    move-object/from16 v53, v41

    goto :goto_c2b

    :catch_c37
    move-exception v0

    move-object v11, v15

    goto :goto_c34

    :catch_c3a
    move-exception v0

    move-object v11, v15

    goto :goto_c34

    :catch_c3d
    move-exception v0

    move-object/from16 v53, v14

    move-object v11, v15

    goto :goto_c2b

    :goto_c42
    const-string v2, "Error in FloatingMenu.show"

    move-object/from16 v3, v53

    invoke-static {v3, v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_c49
    return-void
.end method
