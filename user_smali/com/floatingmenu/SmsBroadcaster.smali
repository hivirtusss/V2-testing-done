.class public Lcom/floatingmenu/SmsBroadcaster;
.super Ljava/lang/Object;
.source "SourceFile"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
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

    invoke-static {p0}, Lcom/floatingmenu/SmsBroadcaster;->pack7bit(Ljava/lang/String;)[B

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

    invoke-static {p1}, Lcom/floatingmenu/SmsBroadcaster;->stringToGsm7BitSeptets(Ljava/lang/String;)[B

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

    invoke-static {p0}, Lcom/floatingmenu/SmsBroadcaster;->packSeptets([B)[B

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

.method public static main([Ljava/lang/String;)V
    .registers 21

    move-object/from16 v0, p0

    const-string v1, "android.telephony.extra.SUBSCRIPTION_INDEX"

    const-string v2, "subscription"

    const-string v3, "3gpp"

    const-string v4, "format"

    const-string v5, "pdus"

    array-length v6, v0

    const/4 v7, 0x1

    const/4 v8, 0x2

    if-ge v6, v8, :cond_1b

    sget-object v6, Ljava/lang/System;->err:Ljava/io/PrintStream;

    const-string v9, "Usage: SmsBroadcaster <sender> <body>"

    invoke-virtual {v6, v9}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    invoke-static {v7}, Ljava/lang/System;->exit(I)V

    :cond_1b
    const/4 v6, 0x0

    aget-object v9, v0, v6

    aget-object v0, v0, v7

    :try_start_20
    invoke-static {v9, v0}, Lcom/floatingmenu/SmsBroadcaster;->createSmsPdu(Ljava/lang/String;Ljava/lang/String;)[B

    move-result-object v0

    if-eqz v0, :cond_2d

    array-length v9, v0

    if-nez v9, :cond_37

    goto :goto_2d

    :catchall_2a
    move-exception v0

    goto/16 :goto_1bb

    :cond_2d
    :goto_2d
    sget-object v9, Ljava/lang/System;->err:Ljava/io/PrintStream;

    const-string v10, "Failed to generate PDU"

    invoke-virtual {v9, v10}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    invoke-static {v7}, Ljava/lang/System;->exit(I)V

    :cond_37
    new-instance v9, Landroid/content/Intent;

    const-string v10, "android.provider.Telephony.SMS_DELIVER"

    invoke-direct {v9, v10}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    new-array v10, v7, [Ljava/lang/Object;

    aput-object v0, v10, v6

    invoke-virtual {v9, v5, v10}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/io/Serializable;)Landroid/content/Intent;

    invoke-virtual {v9, v4, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    invoke-virtual {v9, v2, v7}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    invoke-virtual {v9, v1, v7}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    const/high16 v10, 0x8000000

    invoke-virtual {v9, v10}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    const-string v11, "com.google.android.apps.messaging"

    invoke-virtual {v9, v11}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    new-instance v11, Landroid/content/Intent;

    const-string v12, "android.provider.Telephony.SMS_RECEIVED"

    invoke-direct {v11, v12}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    new-array v12, v7, [Ljava/lang/Object;

    aput-object v0, v12, v6

    invoke-virtual {v11, v5, v12}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/io/Serializable;)Landroid/content/Intent;

    invoke-virtual {v11, v4, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    invoke-virtual {v11, v2, v7}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    invoke-virtual {v11, v1, v7}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    invoke-virtual {v11, v10}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    const-string v0, "android.app.ActivityManager"

    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    const-string v1, "getService"

    new-array v2, v6, [Ljava/lang/Class;

    invoke-virtual {v0, v1, v2}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    invoke-virtual {v0, v7}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v1, v6, [Ljava/lang/Object;

    const/4 v2, 0x0

    invoke-virtual {v0, v2, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    const-string v1, "android.app.IActivityManager"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object v1

    array-length v3, v1

    const/4 v4, 0x0

    :goto_96
    if-ge v4, v3, :cond_b6

    aget-object v5, v1, v4

    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v10

    const-string v12, "broadcastIntent"

    invoke-virtual {v10, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-nez v10, :cond_b7

    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v10

    const-string v12, "broadcastIntentWithFeature"

    invoke-virtual {v10, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v10

    if-eqz v10, :cond_b3

    goto :goto_b7

    :cond_b3
    add-int/lit8 v4, v4, 0x1

    goto :goto_96

    :cond_b6
    move-object v5, v2

    :cond_b7
    :goto_b7
    if-nez v5, :cond_c3

    sget-object v1, Ljava/lang/System;->err:Ljava/io/PrintStream;

    const-string v3, "Could not find broadcastIntent method in IActivityManager"

    invoke-virtual {v1, v3}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    invoke-static {v7}, Ljava/lang/System;->exit(I)V

    :cond_c3
    invoke-virtual {v5, v7}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v1

    array-length v3, v1

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v4, 0x0

    const/4 v10, 0x0

    const/4 v12, 0x0

    :goto_d0
    array-length v13, v1
    :try_end_d1
    .catchall {:try_start_20 .. :try_end_d1} :catchall_2a

    const-string v14, "android.permission.RECEIVE_SMS"

    const-class v15, [Ljava/lang/String;

    const-class v2, Ljava/lang/String;

    const/16 v16, -0x2

    const/16 v18, -0x1

    const-class v8, Landroid/content/Intent;

    if-ge v4, v13, :cond_139

    :try_start_df
    aget-object v13, v1, v4

    if-ne v13, v8, :cond_e6

    aput-object v9, v3, v4

    goto :goto_134

    :cond_e6
    sget-object v8, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    if-ne v13, v8, :cond_ef

    sget-object v2, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    aput-object v2, v3, v4

    goto :goto_134

    :cond_ef
    sget-object v8, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-ne v13, v8, :cond_119

    add-int/lit8 v10, v10, 0x1

    if-ne v10, v7, :cond_fe

    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v3, v4

    goto :goto_134

    :cond_fe
    const/4 v2, 0x2

    if-ne v10, v2, :cond_108

    invoke-static/range {v18 .. v18}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v3, v4

    goto :goto_134

    :cond_108
    const/4 v2, 0x3

    if-ne v10, v2, :cond_112

    invoke-static/range {v16 .. v16}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v3, v4

    goto :goto_134

    :cond_112
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v3, v4

    goto :goto_134

    :cond_119
    if-ne v13, v2, :cond_11f

    const/4 v2, 0x0

    aput-object v2, v3, v4

    goto :goto_134

    :cond_11f
    if-ne v13, v15, :cond_131

    add-int/lit8 v12, v12, 0x1

    if-ne v12, v7, :cond_12d

    new-array v2, v7, [Ljava/lang/String;

    aput-object v14, v2, v6

    aput-object v2, v3, v4

    const/4 v2, 0x0

    goto :goto_134

    :cond_12d
    const/4 v2, 0x0

    aput-object v2, v3, v4

    goto :goto_134

    :cond_131
    const/4 v2, 0x0

    aput-object v2, v3, v4

    :goto_134
    add-int/lit8 v4, v4, 0x1

    const/4 v2, 0x0

    const/4 v8, 0x2

    goto :goto_d0

    :cond_139
    invoke-virtual {v5, v0, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    sget-object v3, Ljava/lang/System;->out:Ljava/io/PrintStream;

    const-string v4, "SUCCESS: SMS_DELIVER Broadcast sent via app_process!"

    invoke-virtual {v3, v4}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    array-length v3, v1

    new-array v3, v3, [Ljava/lang/Object;

    const/4 v4, 0x0

    const/4 v9, 0x0

    const/4 v10, 0x0

    :goto_149
    array-length v12, v1

    if-ge v4, v12, :cond_1b0

    aget-object v12, v1, v4

    if-ne v12, v8, :cond_155

    aput-object v11, v3, v4

    :goto_152
    const/4 v12, 0x0

    const/4 v13, 0x2

    goto :goto_18b

    :cond_155
    sget-object v13, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    if-ne v12, v13, :cond_15e

    sget-object v12, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    aput-object v12, v3, v4

    goto :goto_152

    :cond_15e
    sget-object v13, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-ne v12, v13, :cond_18e

    add-int/lit8 v9, v9, 0x1

    if-ne v9, v7, :cond_16f

    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v12

    aput-object v12, v3, v4

    const/4 v12, 0x3

    const/4 v13, 0x2

    goto :goto_18a

    :cond_16f
    const/4 v13, 0x2

    if-ne v9, v13, :cond_17a

    invoke-static/range {v18 .. v18}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v12

    aput-object v12, v3, v4

    const/4 v12, 0x3

    goto :goto_18a

    :cond_17a
    const/4 v12, 0x3

    if-ne v9, v12, :cond_184

    invoke-static/range {v16 .. v16}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v17

    aput-object v17, v3, v4

    goto :goto_18a

    :cond_184
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v17

    aput-object v17, v3, v4

    :goto_18a
    const/4 v12, 0x0

    :goto_18b
    const/16 v17, 0x3

    goto :goto_1ad

    :cond_18e
    const/4 v13, 0x2

    const/16 v17, 0x3

    if-ne v12, v2, :cond_198

    const/16 v19, 0x0

    aput-object v19, v3, v4

    goto :goto_1a4

    :cond_198
    if-ne v12, v15, :cond_1aa

    add-int/lit8 v10, v10, 0x1

    if-ne v10, v7, :cond_1a6

    new-array v12, v7, [Ljava/lang/String;

    aput-object v14, v12, v6

    aput-object v12, v3, v4

    :goto_1a4
    const/4 v12, 0x0

    goto :goto_1ad

    :cond_1a6
    const/4 v12, 0x0

    aput-object v12, v3, v4

    goto :goto_1ad

    :cond_1aa
    const/4 v12, 0x0

    aput-object v12, v3, v4

    :goto_1ad
    add-int/lit8 v4, v4, 0x1

    goto :goto_149

    :cond_1b0
    invoke-virtual {v5, v0, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;

    const-string v1, "SUCCESS: SMS_RECEIVED Broadcast sent via app_process!"

    invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
    :try_end_1ba
    .catchall {:try_start_df .. :try_end_1ba} :catchall_2a

    goto :goto_1c1

    :goto_1bb
    invoke-virtual {v0}, Ljava/lang/Throwable;->printStackTrace()V

    invoke-static {v7}, Ljava/lang/System;->exit(I)V

    :goto_1c1
    return-void
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
