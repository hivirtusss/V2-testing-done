.class Lcom/floatingmenu/MenuLoader$10;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic val$app:Landroid/app/Application;

.field final synthetic val$status:Ljava/lang/String;


# direct methods
.method public constructor <init>(Landroid/app/Application;Ljava/lang/String;)V
    .registers 3

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    iput-object p2, p0, Lcom/floatingmenu/MenuLoader$10;->val$status:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 22

    move-object/from16 v1, p0

    const-string v2, "serif"

    const-string v3, "ZygiskMenu @Hivirtus"

    const-string v4, "#FF0033"

    :try_start_8
    iget-object v0, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const-string v5, "window"

    invoke-virtual {v0, v5}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    move-object v5, v0

    check-cast v5, Landroid/view/WindowManager;

    if-nez v5, :cond_1e

    const-string v0, "WindowManager is null in systemui!"

    invoke-static {v3, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :catch_1b
    move-exception v0

    goto/16 :goto_3d1

    :cond_1e
    # getter for: Lcom/floatingmenu/MenuLoader;->sSystemUiOverlay:Landroid/view/View;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$2300()Landroid/view/View;

    move-result-object v0

    if-eqz v0, :cond_2a

    iget-object v0, v1, Lcom/floatingmenu/MenuLoader$10;->val$status:Ljava/lang/String;

    # invokes: Lcom/floatingmenu/MenuLoader;->updateSystemUiOverlayError(Ljava/lang/String;)V
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$2400(Ljava/lang/String;)V

    return-void

    :cond_2a
    new-instance v6, Lcom/floatingmenu/MenuLoader$10$1;

    invoke-direct {v6, v1}, Lcom/floatingmenu/MenuLoader$10$1;-><init>(Lcom/floatingmenu/MenuLoader$10;)V

    new-instance v7, Lcom/floatingmenu/MenuLoader$10$2;

    invoke-direct {v7, v1}, Lcom/floatingmenu/MenuLoader$10$2;-><init>(Lcom/floatingmenu/MenuLoader$10;)V

    new-instance v8, Lcom/floatingmenu/MenuLoader$10$3;

    iget-object v0, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    invoke-direct {v8, v1, v0}, Lcom/floatingmenu/MenuLoader$10$3;-><init>(Lcom/floatingmenu/MenuLoader$10;Landroid/content/Context;)V

    const/4 v9, 0x1

    invoke-virtual {v8, v9}, Landroid/view/View;->setClickable(Z)V

    invoke-virtual {v8, v9}, Landroid/view/View;->setFocusable(Z)V

    invoke-virtual {v8, v9}, Landroid/view/View;->setFocusableInTouchMode(Z)V

    invoke-virtual {v8}, Landroid/view/View;->requestFocus()Z

    new-instance v10, Landroid/widget/ImageView;

    iget-object v0, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    invoke-direct {v10, v0}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    sget-object v0, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {v10, v0}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V
    :try_end_54
    .catch Ljava/lang/Exception; {:try_start_8 .. :try_end_54} :catch_1b

    const/4 v11, 0x0

    :try_start_55
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    sget-object v12, Lcom/floatingmenu/BgData;->PARTS:[Ljava/lang/String;

    array-length v13, v12

    const/4 v14, 0x0

    :goto_5e
    if-ge v14, v13, :cond_6a

    aget-object v15, v12, v14

    invoke-virtual {v0, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v14, v14, 0x1

    goto :goto_5e

    :catch_68
    move-exception v0

    goto :goto_7b

    :cond_6a
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v11}, Landroid/util/Base64;->decode(Ljava/lang/String;I)[B

    move-result-object v0

    array-length v12, v0

    invoke-static {v0, v11, v12}, Landroid/graphics/BitmapFactory;->decodeByteArray([BII)Landroid/graphics/Bitmap;

    move-result-object v0

    invoke-virtual {v10, v0}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V
    :try_end_7a
    .catch Ljava/lang/Exception; {:try_start_55 .. :try_end_7a} :catch_68

    goto :goto_85

    :goto_7b
    :try_start_7b
    const-string v12, "Error decoding background image: "

    invoke-static {v3, v12, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    const/high16 v0, -0x1000000

    invoke-virtual {v10, v0}, Landroid/view/View;->setBackgroundColor(I)V

    :goto_85
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v12, -0x1

    invoke-direct {v0, v12, v12}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v8, v10, v0}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v0, Landroid/widget/ScrollView;

    iget-object v10, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    invoke-direct {v0, v10}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, v11}, Landroid/view/View;->setVerticalScrollBarEnabled(Z)V

    invoke-virtual {v0, v9}, Landroid/widget/ScrollView;->setFillViewport(Z)V

    new-instance v10, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v10, v12, v12}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v8, v0, v10}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v10, Landroid/widget/RelativeLayout;

    iget-object v13, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    invoke-direct {v10, v13}, Landroid/widget/RelativeLayout;-><init>(Landroid/content/Context;)V

    new-instance v13, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v13, v12, v12}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v10, v13}, Landroid/widget/ScrollView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v0, Landroid/widget/LinearLayout;

    iget-object v13, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    invoke-direct {v0, v13}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v0, v9}, Landroid/widget/LinearLayout;->setOrientation(I)V

    invoke-virtual {v0, v9}, Landroid/widget/LinearLayout;->setGravity(I)V

    new-instance v13, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v13}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    invoke-virtual {v13, v11}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    const-string v14, "#E60A0000"

    invoke-static {v14}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v14

    invoke-virtual {v13, v14}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    iget-object v14, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v15, 0x41800000    # 16.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v14, v15}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v14

    int-to-float v14, v14

    invoke-virtual {v13, v14}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    iget-object v14, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v15, 0x40000000    # 2.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v14, v15}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v14

    invoke-static {v4}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v15

    invoke-virtual {v13, v14, v15}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    invoke-static {v0, v13}, Lcom/floatingmenu/a;->g(Landroid/widget/LinearLayout;Landroid/graphics/drawable/GradientDrawable;)V

    iget-object v13, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v14, 0x41c00000    # 24.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v13, v14}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v13

    invoke-virtual {v0, v13, v13, v13, v13}, Landroid/view/View;->setPadding(IIII)V

    new-instance v13, Landroid/widget/RelativeLayout$LayoutParams;

    const/4 v15, -0x2

    invoke-direct {v13, v12, v15}, Landroid/widget/RelativeLayout$LayoutParams;-><init>(II)V

    const/16 v12, 0xc

    invoke-virtual {v13, v12}, Landroid/widget/RelativeLayout$LayoutParams;->addRule(I)V

    iget-object v12, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v12, v14}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v12

    iget-object v15, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v15, v14}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v15

    iget-object v14, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v9, 0x42400000    # 48.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v14, v9}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v9

    invoke-virtual {v13, v12, v11, v15, v9}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v10, v0, v13}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # setter for: Lcom/floatingmenu/MenuLoader;->sSystemUiCard:Landroid/view/View;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$2602(Landroid/view/View;)Landroid/view/View;

    new-instance v9, Landroid/widget/TextView;

    iget-object v10, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    invoke-direct {v9, v10}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v10, "\u2726  ENTER LICENCE KEY  \u2726"

    invoke-virtual {v9, v10}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const-string v10, "#FF3B30"

    invoke-static {v10}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v10

    invoke-virtual {v9, v10}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v10, 0x41600000    # 14.0f

    const/4 v12, 0x2

    invoke-virtual {v9, v12, v10}, Landroid/widget/TextView;->setTextSize(IF)V

    const/4 v10, 0x1

    invoke-static {v2, v10}, Landroid/graphics/Typeface;->create(Ljava/lang/String;I)Landroid/graphics/Typeface;

    move-result-object v13

    invoke-virtual {v9, v13}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const/16 v10, 0x11

    invoke-virtual {v9, v10}, Landroid/widget/TextView;->setGravity(I)V

    invoke-static {v4}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v13

    const/high16 v14, 0x41000000    # 8.0f

    const/4 v15, 0x0

    invoke-virtual {v9, v14, v15, v15, v13}, Landroid/widget/TextView;->setShadowLayer(FFFI)V

    sget v13, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v10, 0x15

    if-lt v13, v10, :cond_15c

    invoke-static {v9}, Lcom/floatingmenu/e;->b(Landroid/widget/TextView;)V

    :cond_15c
    new-instance v14, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v10, -0x2

    const/4 v15, -0x1

    invoke-direct {v14, v15, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v10, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v15, 0x41a00000    # 20.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v10, v15}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v10

    invoke-virtual {v14, v11, v11, v11, v10}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v0, v9, v14}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v9, Landroid/widget/LinearLayout;

    iget-object v10, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    invoke-direct {v9, v10}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    invoke-virtual {v9, v11}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v10, 0x10

    invoke-virtual {v9, v10}, Landroid/widget/LinearLayout;->setGravity(I)V

    new-instance v10, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v10}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    invoke-virtual {v10, v11}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    const-string v14, "#4D000000"

    invoke-static {v14}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v14

    invoke-virtual {v10, v14}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    iget-object v14, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v15, 0x41200000    # 10.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v14, v15}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v14

    int-to-float v14, v14

    invoke-virtual {v10, v14}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    iget-object v14, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v11, 0x3fc00000    # 1.5f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v14, v11}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v11

    invoke-static {v4}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v14

    invoke-virtual {v10, v11, v14}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    invoke-static {v9, v10}, Lcom/floatingmenu/a;->g(Landroid/widget/LinearLayout;Landroid/graphics/drawable/GradientDrawable;)V

    iget-object v10, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v11, 0x41800000    # 16.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v10, v11}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v10

    iget-object v14, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v14, v15}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v14

    iget-object v12, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v12, v11}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v12

    iget-object v11, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v11, v15}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v11

    invoke-virtual {v9, v10, v14, v12, v11}, Landroid/view/View;->setPadding(IIII)V

    new-instance v10, Landroid/widget/ImageView;

    iget-object v11, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    invoke-direct {v10, v11}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v10, v6}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    iget-object v11, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v12, 0x41c00000    # 24.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v11, v12}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v11

    iget-object v14, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v14, v12}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v12

    invoke-direct {v6, v11, v12}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v9, v10, v6}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v6, Landroid/widget/EditText;

    iget-object v10, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    invoke-direct {v6, v10}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    const-string v10, "Licence Key"

    invoke-virtual {v6, v10}, Landroid/widget/TextView;->setHint(Ljava/lang/CharSequence;)V

    const-string v10, "#66FFFFFF"

    invoke-static {v10}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v10

    invoke-virtual {v6, v10}, Landroid/widget/TextView;->setHintTextColor(I)V

    const/4 v10, -0x1

    invoke-virtual {v6, v10}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v10, 0x41800000    # 16.0f

    const/4 v11, 0x2

    invoke-virtual {v6, v11, v10}, Landroid/widget/TextView;->setTextSize(IF)V

    const/4 v10, 0x1

    invoke-virtual {v6, v10}, Landroid/widget/TextView;->setGravity(I)V

    invoke-virtual {v6, v10}, Landroid/widget/TextView;->setSingleLine(Z)V

    invoke-static {v6}, Lcom/floatingmenu/a;->d(Landroid/widget/EditText;)V

    const/16 v10, 0x1d

    if-lt v13, v10, :cond_234

    new-instance v10, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v10}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    invoke-static {v4}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v11

    invoke-virtual {v10, v11}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    iget-object v11, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v12, 0x40000000    # 2.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v11, v12}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v11

    const/4 v12, 0x0

    invoke-virtual {v10, v11, v12}, Landroid/graphics/drawable/GradientDrawable;->setSize(II)V

    invoke-static {v6, v10}, Lcom/floatingmenu/f;->a(Landroid/widget/EditText;Landroid/graphics/drawable/GradientDrawable;)V

    :cond_234
    new-instance v10, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v11, -0x1

    const/4 v12, -0x2

    invoke-direct {v10, v11, v12}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v11, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v11, v15}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v11

    const/4 v12, 0x0

    invoke-virtual {v10, v11, v12, v12, v12}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v9, v6, v10}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # setter for: Lcom/floatingmenu/MenuLoader;->sSystemUiInput:Landroid/widget/EditText;
    invoke-static {v6}, Lcom/floatingmenu/MenuLoader;->access$2702(Landroid/widget/EditText;)Landroid/widget/EditText;

    new-instance v10, Ljava/lang/Thread;

    new-instance v11, Lcom/floatingmenu/MenuLoader$10$4;

    invoke-direct {v11, v1, v6}, Lcom/floatingmenu/MenuLoader$10$4;-><init>(Lcom/floatingmenu/MenuLoader$10;Landroid/widget/EditText;)V

    invoke-direct {v10, v11}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v10}, Ljava/lang/Thread;->start()V

    new-instance v10, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v11, -0x1

    const/4 v12, -0x2

    invoke-direct {v10, v11, v12}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v11, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v12, 0x41a00000    # 20.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v11, v12}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v11

    const/4 v12, 0x0

    invoke-virtual {v10, v12, v12, v12, v11}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v0, v9, v10}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v9, Landroid/widget/Button;

    iget-object v10, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    invoke-direct {v9, v10}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v10, "ENTER DOMAIN  \u2794"

    invoke-virtual {v9, v10}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 v10, -0x1

    invoke-virtual {v9, v10}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v10, 0x41800000    # 16.0f

    const/4 v11, 0x2

    invoke-virtual {v9, v11, v10}, Landroid/widget/TextView;->setTextSize(IF)V

    const/4 v10, 0x1

    invoke-static {v2, v10}, Landroid/graphics/Typeface;->create(Ljava/lang/String;I)Landroid/graphics/Typeface;

    move-result-object v11

    invoke-virtual {v9, v11}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const/16 v10, 0x15

    if-lt v13, v10, :cond_293

    invoke-static {v9}, Lcom/floatingmenu/e;->a(Landroid/widget/Button;)V

    :cond_293
    invoke-static {v4}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v10

    const/high16 v11, 0x41000000    # 8.0f

    const/4 v12, 0x0

    invoke-virtual {v9, v11, v12, v12, v10}, Landroid/widget/TextView;->setShadowLayer(FFFI)V

    invoke-static {v9}, Lcom/floatingmenu/b;->i(Landroid/widget/Button;)V

    new-instance v10, Landroid/graphics/drawable/GradientDrawable;

    sget-object v11, Landroid/graphics/drawable/GradientDrawable$Orientation;->LEFT_RIGHT:Landroid/graphics/drawable/GradientDrawable$Orientation;

    const/4 v12, 0x2

    new-array v14, v12, [I

    const-string v12, "#E50914"

    invoke-static {v12}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v12

    const/4 v15, 0x0

    aput v12, v14, v15

    const-string v12, "#7F0000"

    invoke-static {v12}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v12

    const/16 v20, 0x1

    aput v12, v14, v20

    invoke-direct {v10, v11, v14}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V

    invoke-virtual {v10, v15}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    iget-object v11, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v12, 0x41200000    # 10.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v11, v12}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v11

    int-to-float v11, v11

    invoke-virtual {v10, v11}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    iget-object v11, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v12, 0x40000000    # 2.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v11, v12}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v11

    invoke-static {v4}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v12

    invoke-virtual {v10, v11, v12}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    invoke-static {v9, v10}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    new-instance v10, Landroid/widget/LinearLayout$LayoutParams;

    iget-object v11, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v12, 0x42480000    # 50.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v11, v12}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v11

    const/4 v12, -0x1

    invoke-direct {v10, v12, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v11, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v12, 0x41a00000    # 20.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v11, v12}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v11

    const/4 v12, 0x0

    invoke-virtual {v10, v12, v12, v12, v11}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v0, v9, v10}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v10, Landroid/widget/TextView;

    iget-object v11, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    invoke-direct {v10, v11}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v11, "\u201c YOU ARE NOT WORTHY.\nPROVE YOURSELF. \u201d"

    invoke-virtual {v10, v11}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const-string v11, "#FF9999"

    invoke-static {v11}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v11

    invoke-virtual {v10, v11}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v11, 0x41300000    # 11.0f

    const/4 v12, 0x2

    invoke-virtual {v10, v12, v11}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-static {v2, v12}, Landroid/graphics/Typeface;->create(Ljava/lang/String;I)Landroid/graphics/Typeface;

    move-result-object v11

    invoke-virtual {v10, v11}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const/16 v11, 0x11

    invoke-virtual {v10, v11}, Landroid/widget/TextView;->setGravity(I)V

    const/16 v11, 0x15

    if-lt v13, v11, :cond_329

    invoke-static {v10}, Lcom/floatingmenu/e;->c(Landroid/widget/TextView;)V

    :cond_329
    new-instance v11, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v12, -0x1

    const/4 v14, -0x2

    invoke-direct {v11, v12, v14}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v12, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v14, 0x41400000    # 12.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v12, v14}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v12

    const/4 v14, 0x0

    invoke-virtual {v11, v14, v14, v14, v12}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v0, v10, v11}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v10, Landroid/widget/ImageView;

    iget-object v11, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    invoke-direct {v10, v11}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    invoke-virtual {v10, v7}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V

    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;

    iget-object v11, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v12, 0x42100000    # 36.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v11, v12}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v11

    iget-object v14, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v14, v12}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v12

    invoke-direct {v7, v11, v12}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v0, v10, v7}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v7, Landroid/widget/TextView;

    iget-object v10, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    invoke-direct {v7, v10}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    invoke-static {v4}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v4

    invoke-virtual {v7, v4}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v4, 0x41500000    # 13.0f

    const/4 v10, 0x2

    invoke-virtual {v7, v10, v4}, Landroid/widget/TextView;->setTextSize(IF)V

    const/4 v4, 0x1

    invoke-static {v2, v4}, Landroid/graphics/Typeface;->create(Ljava/lang/String;I)Landroid/graphics/Typeface;

    move-result-object v2

    invoke-virtual {v7, v2}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const/16 v2, 0x11

    invoke-virtual {v7, v2}, Landroid/widget/TextView;->setGravity(I)V

    const/16 v2, 0x8

    invoke-virtual {v7, v2}, Landroid/view/View;->setVisibility(I)V

    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, -0x1

    const/4 v10, -0x2

    invoke-direct {v2, v4, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    iget-object v4, v1, Lcom/floatingmenu/MenuLoader$10;->val$app:Landroid/app/Application;

    const/high16 v10, 0x41200000    # 10.0f

    # invokes: Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I
    invoke-static {v4, v10}, Lcom/floatingmenu/MenuLoader;->access$2500(Landroid/content/Context;F)I

    move-result v4

    const/4 v10, 0x0

    invoke-virtual {v2, v10, v4, v10, v10}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    invoke-virtual {v0, v7, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # setter for: Lcom/floatingmenu/MenuLoader;->sSystemUiErrorText:Landroid/widget/TextView;
    invoke-static {v7}, Lcom/floatingmenu/MenuLoader;->access$2802(Landroid/widget/TextView;)Landroid/widget/TextView;

    iget-object v0, v1, Lcom/floatingmenu/MenuLoader$10;->val$status:Ljava/lang/String;

    # invokes: Lcom/floatingmenu/MenuLoader;->updateSystemUiOverlayError(Ljava/lang/String;)V
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$2400(Ljava/lang/String;)V

    new-instance v0, Lcom/floatingmenu/MenuLoader$10$5;

    invoke-direct {v0, v1, v6, v7}, Lcom/floatingmenu/MenuLoader$10$5;-><init>(Lcom/floatingmenu/MenuLoader$10;Landroid/widget/EditText;Landroid/widget/TextView;)V

    invoke-virtual {v9, v0}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v0, Landroid/view/WindowManager$LayoutParams;

    const/4 v15, -0x1

    const/16 v16, -0x1

    const/16 v2, 0x1a

    if-lt v13, v2, :cond_3b9

    const/16 v2, 0x7f6

    const/16 v17, 0x7f6

    goto :goto_3bd

    :cond_3b9
    const/16 v2, 0x7d3

    const/16 v17, 0x7d3

    :goto_3bd
    const/16 v18, 0x500

    const/16 v19, -0x3

    move-object v14, v0

    invoke-direct/range {v14 .. v19}, Landroid/view/WindowManager$LayoutParams;-><init>(IIIII)V

    invoke-interface {v5, v8, v0}, Landroid/view/ViewManager;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    # setter for: Lcom/floatingmenu/MenuLoader;->sSystemUiOverlay:Landroid/view/View;
    invoke-static {v8}, Lcom/floatingmenu/MenuLoader;->access$2302(Landroid/view/View;)Landroid/view/View;

    const-string v0, "SystemUI Overlay successfully added to WindowManager."

    invoke-static {v3, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_3d0
    .catch Ljava/lang/Exception; {:try_start_7b .. :try_end_3d0} :catch_1b

    goto :goto_3d6

    :goto_3d1
    const-string v2, "Failed to show SystemUI overlay: "

    invoke-static {v3, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_3d6
    return-void
.end method
