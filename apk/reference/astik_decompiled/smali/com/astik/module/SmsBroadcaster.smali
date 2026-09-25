.class public Lcom/astik/module/SmsBroadcaster;
.super Ljava/lang/Object;
.source "SmsBroadcaster.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    .line 17
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static broadcast([B)V
    .locals 10
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 89
    new-instance v0, Landroid/content/Intent;

    const-string v1, "android.provider.Telephony.SMS_DELIVER"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 90
    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object v1

    const-string v2, "pdus"

    invoke-virtual {v0, v2, v1}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/io/Serializable;)Landroid/content/Intent;

    .line 91
    const-string v1, "format"

    const-string v3, "3gpp"

    invoke-virtual {v0, v1, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 92
    const-string v4, "subscription"

    const/4 v5, 0x1

    invoke-virtual {v0, v4, v5}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 93
    const-string v6, "android.telephony.extra.SUBSCRIPTION_INDEX"

    invoke-virtual {v0, v6, v5}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 94
    const/high16 v7, 0x8000000

    invoke-virtual {v0, v7}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 95
    const-string v8, "com.google.android.apps.messaging"

    invoke-virtual {v0, v8}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    .line 97
    new-instance v8, Landroid/content/Intent;

    const-string v9, "android.provider.Telephony.SMS_RECEIVED"

    invoke-direct {v8, v9}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 98
    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {v8, v2, p0}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/io/Serializable;)Landroid/content/Intent;

    .line 99
    invoke-virtual {v8, v1, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    .line 100
    invoke-virtual {v8, v4, v5}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 101
    invoke-virtual {v8, v6, v5}, Landroid/content/Intent;->putExtra(Ljava/lang/String;I)Landroid/content/Intent;

    .line 102
    invoke-virtual {v8, v7}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 104
    const-string p0, "android.app.ActivityManager"

    invoke-static {p0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    .line 105
    const/4 v1, 0x0

    new-array v2, v1, [Ljava/lang/Class;

    const-string v3, "getService"

    invoke-virtual {p0, v3, v2}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object p0

    .line 106
    invoke-virtual {p0, v5}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 107
    new-array v2, v1, [Ljava/lang/Object;

    const/4 v3, 0x0

    invoke-virtual {p0, v3, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    .line 109
    const-string v2, "android.app.IActivityManager"

    invoke-static {v2}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v2

    .line 110
    nop

    .line 111
    invoke-virtual {v2}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object v2

    array-length v4, v2

    :goto_0
    if-ge v1, v4, :cond_2

    aget-object v6, v2, v1

    .line 112
    invoke-virtual {v6}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v7

    .line 113
    const-string v9, "broadcastIntent"

    invoke-virtual {v9, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-nez v9, :cond_1

    const-string v9, "broadcastIntentWithFeature"

    invoke-virtual {v9, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_0

    goto :goto_1

    .line 111
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 114
    :cond_1
    :goto_1
    nop

    .line 115
    move-object v3, v6

    .line 118
    :cond_2
    invoke-virtual {v3, v5}, Ljava/lang/reflect/Method;->setAccessible(Z)V

    .line 119
    invoke-virtual {v3}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v1

    .line 121
    invoke-static {v1, v0}, Lcom/astik/module/SmsBroadcaster;->buildArgs([Ljava/lang/Class;Landroid/content/Intent;)[Ljava/lang/Object;

    move-result-object v0

    .line 122
    invoke-virtual {v3, p0, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 123
    sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;

    const-string v2, "OK:DELIVER"

    invoke-virtual {v0, v2}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 125
    invoke-static {v1, v8}, Lcom/astik/module/SmsBroadcaster;->buildArgs([Ljava/lang/Class;Landroid/content/Intent;)[Ljava/lang/Object;

    move-result-object v0

    .line 126
    invoke-virtual {v3, p0, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 127
    sget-object p0, Ljava/lang/System;->out:Ljava/io/PrintStream;

    const-string v0, "OK:RECEIVED"

    invoke-virtual {p0, v0}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 128
    return-void
.end method

.method private static buildArgs([Ljava/lang/Class;Landroid/content/Intent;)[Ljava/lang/Object;
    .locals 10
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "([",
            "Ljava/lang/Class<",
            "*>;",
            "Landroid/content/Intent;",
            ")[",
            "Ljava/lang/Object;"
        }
    .end annotation

    .line 236
    array-length v0, p0

    new-array v0, v0, [Ljava/lang/Object;

    .line 237
    nop

    .line 238
    nop

    .line 239
    const/4 v1, 0x0

    .line 247
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    .line 239
    move v3, v1

    move v4, v3

    move v5, v4

    :goto_0
    array-length v6, p0

    if-ge v3, v6, :cond_b

    .line 240
    aget-object v6, p0, v3

    .line 241
    const-class v7, Landroid/content/Intent;

    if-ne v6, v7, :cond_0

    .line 242
    aput-object p1, v0, v3

    goto :goto_3

    .line 243
    :cond_0
    sget-object v7, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    if-eq v6, v7, :cond_a

    const-class v7, Ljava/lang/Boolean;

    if-ne v6, v7, :cond_1

    goto :goto_2

    .line 245
    :cond_1
    sget-object v7, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    const/4 v8, 0x1

    if-eq v6, v7, :cond_6

    const-class v7, Ljava/lang/Integer;

    if-ne v6, v7, :cond_2

    goto :goto_1

    .line 251
    :cond_2
    const-class v7, Ljava/lang/String;

    const/4 v9, 0x0

    if-ne v6, v7, :cond_3

    .line 252
    aput-object v9, v0, v3

    goto :goto_3

    .line 253
    :cond_3
    const-class v7, [Ljava/lang/String;

    if-ne v6, v7, :cond_5

    .line 254
    add-int/lit8 v5, v5, 0x1

    .line 255
    if-ne v5, v8, :cond_4

    new-array v6, v8, [Ljava/lang/String;

    const-string v7, "android.permission.RECEIVE_SMS"

    aput-object v7, v6, v1

    aput-object v6, v0, v3

    goto :goto_3

    .line 256
    :cond_4
    aput-object v9, v0, v3

    goto :goto_3

    .line 258
    :cond_5
    aput-object v9, v0, v3

    goto :goto_3

    .line 246
    :cond_6
    :goto_1
    add-int/lit8 v4, v4, 0x1

    .line 247
    if-ne v4, v8, :cond_7

    aput-object v2, v0, v3

    goto :goto_3

    .line 248
    :cond_7
    const/4 v6, 0x2

    if-ne v4, v6, :cond_8

    const/4 v6, -0x1

    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    aput-object v6, v0, v3

    goto :goto_3

    .line 249
    :cond_8
    const/4 v6, 0x3

    if-ne v4, v6, :cond_9

    const/4 v6, -0x2

    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    aput-object v6, v0, v3

    goto :goto_3

    .line 250
    :cond_9
    aput-object v2, v0, v3

    goto :goto_3

    .line 244
    :cond_a
    :goto_2
    sget-object v6, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    aput-object v6, v0, v3

    .line 239
    :goto_3
    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    .line 261
    :cond_b
    return-object v0
.end method

.method private static createPdu(Ljava/lang/String;Ljava/lang/String;)[B
    .locals 10

    .line 266
    :try_start_0
    new-instance v0, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v0}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 267
    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 268
    const/4 v2, 0x4

    invoke-virtual {v0, v2}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 269
    const-string v3, "[0-9]+"

    invoke-virtual {p0, v3}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_2

    .line 270
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v3

    invoke-virtual {v0, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 271
    const-string v3, "+"

    invoke-virtual {p0, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_0

    const/16 v3, 0x91

    goto :goto_0

    :cond_0
    const/16 v3, 0x81

    :goto_0
    invoke-virtual {v0, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 272
    move v3, v1

    :goto_1
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v4

    if-ge v3, v4, :cond_3

    .line 273
    invoke-virtual {p0, v3}, Ljava/lang/String;->charAt(I)C

    move-result v4

    add-int/lit8 v4, v4, -0x30

    .line 274
    add-int/lit8 v5, v3, 0x1

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v6

    if-ge v5, v6, :cond_1

    invoke-virtual {p0, v5}, Ljava/lang/String;->charAt(I)C

    move-result v5

    add-int/lit8 v5, v5, -0x30

    goto :goto_2

    :cond_1
    const/16 v5, 0xf

    .line 275
    :goto_2
    shl-int/2addr v5, v2

    or-int/2addr v4, v5

    invoke-virtual {v0, v4}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 272
    add-int/lit8 v3, v3, 0x2

    goto :goto_1

    .line 278
    :cond_2
    invoke-static {p0}, Lcom/astik/module/SmsBroadcaster;->pack7Bit(Ljava/lang/String;)[B

    move-result-object v3

    .line 279
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result p0

    mul-int/lit8 p0, p0, 0x7

    add-int/lit8 p0, p0, 0x3

    div-int/2addr p0, v2

    invoke-virtual {v0, p0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 280
    const/16 p0, 0xd0

    invoke-virtual {v0, p0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 281
    invoke-virtual {v0, v3}, Ljava/io/ByteArrayOutputStream;->write([B)V

    .line 283
    :cond_3
    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 284
    const-string p0, "UTC"

    invoke-static {p0}, Ljava/util/TimeZone;->getTimeZone(Ljava/lang/String;)Ljava/util/TimeZone;

    move-result-object p0

    invoke-static {p0}, Ljava/util/Calendar;->getInstance(Ljava/util/TimeZone;)Ljava/util/Calendar;

    move-result-object p0

    .line 285
    const/4 v3, 0x1

    invoke-virtual {p0, v3}, Ljava/util/Calendar;->get(I)I

    move-result v4

    rem-int/lit8 v4, v4, 0x64

    .line 286
    const/4 v5, 0x2

    invoke-virtual {p0, v5}, Ljava/util/Calendar;->get(I)I

    move-result v5

    add-int/2addr v5, v3

    .line 287
    const/4 v3, 0x5

    invoke-virtual {p0, v3}, Ljava/util/Calendar;->get(I)I

    move-result v3

    .line 288
    const/16 v6, 0xb

    invoke-virtual {p0, v6}, Ljava/util/Calendar;->get(I)I

    move-result v6

    .line 289
    const/16 v7, 0xc

    invoke-virtual {p0, v7}, Ljava/util/Calendar;->get(I)I

    move-result v7

    .line 290
    const/16 v8, 0xd

    invoke-virtual {p0, v8}, Ljava/util/Calendar;->get(I)I

    move-result p0

    .line 292
    invoke-static {p1}, Lcom/astik/module/SmsBroadcaster;->isAscii(Ljava/lang/String;)Z

    move-result v8

    const/16 v9, 0x8

    if-eqz v8, :cond_5

    .line 293
    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 294
    rem-int/lit8 v8, v4, 0xa

    shl-int/2addr v8, v2

    div-int/lit8 v4, v4, 0xa

    or-int/2addr v4, v8

    invoke-virtual {v0, v4}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 295
    rem-int/lit8 v4, v5, 0xa

    shl-int/2addr v4, v2

    div-int/lit8 v5, v5, 0xa

    or-int/2addr v4, v5

    invoke-virtual {v0, v4}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 296
    rem-int/lit8 v4, v3, 0xa

    shl-int/2addr v4, v2

    div-int/lit8 v3, v3, 0xa

    or-int/2addr v3, v4

    invoke-virtual {v0, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 297
    rem-int/lit8 v3, v6, 0xa

    shl-int/2addr v3, v2

    div-int/lit8 v6, v6, 0xa

    or-int/2addr v3, v6

    invoke-virtual {v0, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 298
    rem-int/lit8 v3, v7, 0xa

    shl-int/2addr v3, v2

    div-int/lit8 v7, v7, 0xa

    or-int/2addr v3, v7

    invoke-virtual {v0, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 299
    rem-int/lit8 v3, p0, 0xa

    shl-int/lit8 v2, v3, 0x4

    div-int/lit8 p0, p0, 0xa

    or-int/2addr p0, v2

    invoke-virtual {v0, p0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 300
    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 301
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p0

    const/16 v2, 0xfa

    if-le p0, v2, :cond_4

    invoke-virtual {p1, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p1

    .line 302
    :cond_4
    invoke-static {p1}, Lcom/astik/module/SmsBroadcaster;->pack7Bit(Ljava/lang/String;)[B

    move-result-object p0

    .line 303
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v2

    mul-int/lit8 v2, v2, 0x7

    add-int/lit8 v2, v2, 0x7

    div-int/2addr v2, v9

    .line 304
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    invoke-virtual {v0, p1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 305
    invoke-virtual {v0, p0, v1, v2}, Ljava/io/ByteArrayOutputStream;->write([BII)V

    .line 306
    goto :goto_3

    .line 307
    :cond_5
    invoke-virtual {v0, v9}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 308
    rem-int/lit8 v8, v4, 0xa

    shl-int/2addr v8, v2

    div-int/lit8 v4, v4, 0xa

    or-int/2addr v4, v8

    invoke-virtual {v0, v4}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 309
    rem-int/lit8 v4, v5, 0xa

    shl-int/2addr v4, v2

    div-int/lit8 v5, v5, 0xa

    or-int/2addr v4, v5

    invoke-virtual {v0, v4}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 310
    rem-int/lit8 v4, v3, 0xa

    shl-int/2addr v4, v2

    div-int/lit8 v3, v3, 0xa

    or-int/2addr v3, v4

    invoke-virtual {v0, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 311
    rem-int/lit8 v3, v6, 0xa

    shl-int/2addr v3, v2

    div-int/lit8 v6, v6, 0xa

    or-int/2addr v3, v6

    invoke-virtual {v0, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 312
    rem-int/lit8 v3, v7, 0xa

    shl-int/2addr v3, v2

    div-int/lit8 v7, v7, 0xa

    or-int/2addr v3, v7

    invoke-virtual {v0, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 313
    rem-int/lit8 v3, p0, 0xa

    shl-int/lit8 v2, v3, 0x4

    div-int/lit8 p0, p0, 0xa

    or-int/2addr p0, v2

    invoke-virtual {v0, p0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 314
    invoke-virtual {v0, v1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 315
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p0

    const/16 v2, 0x46

    if-le p0, v2, :cond_6

    invoke-virtual {p1, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p1

    .line 316
    :cond_6
    const-string p0, "UTF-16BE"

    invoke-virtual {p1, p0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object p0

    .line 317
    array-length p1, p0

    invoke-virtual {v0, p1}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 318
    invoke-virtual {v0, p0}, Ljava/io/ByteArrayOutputStream;->write([B)V

    .line 320
    :goto_3
    invoke-virtual {v0}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object p0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object p0

    .line 321
    :catch_0
    move-exception p0

    .line 322
    invoke-virtual {p0}, Ljava/lang/Exception;->printStackTrace()V

    .line 323
    const/4 p0, 0x0

    return-object p0
.end method

.method private static createPduConcat(Ljava/lang/String;Ljava/lang/String;BII)[B
    .locals 14

    .line 132
    move-object v0, p0

    :try_start_0
    new-instance v1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 133
    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 134
    const/16 v3, 0x40

    move/from16 v10, p4

    move/from16 v11, p3

    if-ge v10, v11, :cond_0

    const/16 v3, 0x44

    :cond_0
    invoke-virtual {v1, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 135
    const-string v3, "[0-9]+"

    invoke-virtual {p0, v3}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v3

    const/4 v4, 0x3

    const/4 v5, 0x4

    if-eqz v3, :cond_3

    .line 136
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v3

    invoke-virtual {v1, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 137
    const-string v3, "+"

    invoke-virtual {p0, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    const/16 v3, 0x91

    goto :goto_0

    :cond_1
    const/16 v3, 0x81

    :goto_0
    invoke-virtual {v1, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 138
    move v3, v2

    :goto_1
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v6

    if-ge v3, v6, :cond_4

    .line 139
    invoke-virtual {p0, v3}, Ljava/lang/String;->charAt(I)C

    move-result v6

    add-int/lit8 v6, v6, -0x30

    .line 140
    add-int/lit8 v7, v3, 0x1

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v8

    if-ge v7, v8, :cond_2

    invoke-virtual {p0, v7}, Ljava/lang/String;->charAt(I)C

    move-result v7

    add-int/lit8 v7, v7, -0x30

    goto :goto_2

    :cond_2
    const/16 v7, 0xf

    .line 141
    :goto_2
    shl-int/2addr v7, v5

    or-int/2addr v6, v7

    invoke-virtual {v1, v6}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 138
    add-int/lit8 v3, v3, 0x2

    goto :goto_1

    .line 144
    :cond_3
    invoke-static {p0, v2}, Lcom/astik/module/SmsBroadcaster;->pack7Bit(Ljava/lang/String;I)[B

    move-result-object v3

    .line 145
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    mul-int/lit8 v0, v0, 0x7

    add-int/2addr v0, v4

    div-int/2addr v0, v5

    invoke-virtual {v1, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 146
    const/16 v0, 0xd0

    invoke-virtual {v1, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 147
    invoke-virtual {v1, v3}, Ljava/io/ByteArrayOutputStream;->write([B)V

    .line 149
    :cond_4
    invoke-virtual {v1, v2}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 150
    const-string v0, "UTC"

    invoke-static {v0}, Ljava/util/TimeZone;->getTimeZone(Ljava/lang/String;)Ljava/util/TimeZone;

    move-result-object v0

    invoke-static {v0}, Ljava/util/Calendar;->getInstance(Ljava/util/TimeZone;)Ljava/util/Calendar;

    move-result-object v0

    .line 151
    const/4 v3, 0x1

    invoke-virtual {v0, v3}, Ljava/util/Calendar;->get(I)I

    move-result v6

    rem-int/lit8 v6, v6, 0x64

    .line 152
    const/4 v7, 0x2

    invoke-virtual {v0, v7}, Ljava/util/Calendar;->get(I)I

    move-result v8

    add-int/2addr v8, v3

    .line 153
    const/4 v9, 0x5

    invoke-virtual {v0, v9}, Ljava/util/Calendar;->get(I)I

    move-result v10

    .line 154
    const/16 v11, 0xb

    invoke-virtual {v0, v11}, Ljava/util/Calendar;->get(I)I

    move-result v11

    .line 155
    const/16 v12, 0xc

    invoke-virtual {v0, v12}, Ljava/util/Calendar;->get(I)I

    move-result v12

    .line 156
    const/16 v13, 0xd

    invoke-virtual {v0, v13}, Ljava/util/Calendar;->get(I)I

    move-result v0

    .line 158
    invoke-virtual {v1, v2}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 159
    rem-int/lit8 v13, v6, 0xa

    shl-int/2addr v13, v5

    div-int/lit8 v6, v6, 0xa

    or-int/2addr v6, v13

    invoke-virtual {v1, v6}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 160
    rem-int/lit8 v6, v8, 0xa

    shl-int/2addr v6, v5

    div-int/lit8 v8, v8, 0xa

    or-int/2addr v6, v8

    invoke-virtual {v1, v6}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 161
    rem-int/lit8 v6, v10, 0xa

    shl-int/2addr v6, v5

    div-int/lit8 v10, v10, 0xa

    or-int/2addr v6, v10

    invoke-virtual {v1, v6}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 162
    rem-int/lit8 v6, v11, 0xa

    shl-int/2addr v6, v5

    div-int/lit8 v11, v11, 0xa

    or-int/2addr v6, v11

    invoke-virtual {v1, v6}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 163
    rem-int/lit8 v6, v12, 0xa

    shl-int/2addr v6, v5

    div-int/lit8 v12, v12, 0xa

    or-int/2addr v6, v12

    invoke-virtual {v1, v6}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 164
    rem-int/lit8 v6, v0, 0xa

    shl-int/2addr v6, v5

    div-int/lit8 v0, v0, 0xa

    or-int/2addr v0, v6

    invoke-virtual {v1, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 165
    invoke-virtual {v1, v2}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 168
    move/from16 v0, p3

    int-to-byte v0, v0

    move/from16 v6, p4

    int-to-byte v6, v6

    const/4 v8, 0x6

    new-array v8, v8, [B

    aput-byte v9, v8, v2

    aput-byte v2, v8, v3

    aput-byte v4, v8, v7

    aput-byte p2, v8, v4

    aput-byte v0, v8, v5

    aput-byte v6, v8, v9

    .line 171
    move-object v0, p1

    invoke-static {p1, v2}, Lcom/astik/module/SmsBroadcaster;->pack7Bit(Ljava/lang/String;I)[B

    move-result-object v2

    .line 172
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v0

    add-int/lit8 v0, v0, 0x7

    .line 173
    invoke-virtual {v1, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 174
    invoke-virtual {v1, v8}, Ljava/io/ByteArrayOutputStream;->write([B)V

    .line 175
    invoke-virtual {v1, v2}, Ljava/io/ByteArrayOutputStream;->write([B)V

    .line 176
    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    .line 177
    :catch_0
    move-exception v0

    .line 178
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 179
    const/4 v0, 0x0

    return-object v0
.end method

.method private static createPduConcatUcs2(Ljava/lang/String;Ljava/lang/String;BII)[B
    .locals 14

    .line 185
    move-object v0, p0

    :try_start_0
    new-instance v1, Ljava/io/ByteArrayOutputStream;

    invoke-direct {v1}, Ljava/io/ByteArrayOutputStream;-><init>()V

    .line 186
    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 187
    const/16 v3, 0x40

    move/from16 v10, p4

    move/from16 v11, p3

    if-ge v10, v11, :cond_0

    const/16 v3, 0x44

    :cond_0
    invoke-virtual {v1, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 188
    const-string v3, "[0-9]+"

    invoke-virtual {p0, v3}, Ljava/lang/String;->matches(Ljava/lang/String;)Z

    move-result v3

    const/4 v4, 0x3

    const/4 v5, 0x4

    if-eqz v3, :cond_3

    .line 189
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v3

    invoke-virtual {v1, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 190
    const-string v3, "+"

    invoke-virtual {p0, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_1

    const/16 v3, 0x91

    goto :goto_0

    :cond_1
    const/16 v3, 0x81

    :goto_0
    invoke-virtual {v1, v3}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 191
    move v3, v2

    :goto_1
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v6

    if-ge v3, v6, :cond_4

    .line 192
    invoke-virtual {p0, v3}, Ljava/lang/String;->charAt(I)C

    move-result v6

    add-int/lit8 v6, v6, -0x30

    .line 193
    add-int/lit8 v7, v3, 0x1

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v8

    if-ge v7, v8, :cond_2

    invoke-virtual {p0, v7}, Ljava/lang/String;->charAt(I)C

    move-result v7

    add-int/lit8 v7, v7, -0x30

    goto :goto_2

    :cond_2
    const/16 v7, 0xf

    .line 194
    :goto_2
    shl-int/2addr v7, v5

    or-int/2addr v6, v7

    invoke-virtual {v1, v6}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 191
    add-int/lit8 v3, v3, 0x2

    goto :goto_1

    .line 197
    :cond_3
    invoke-static {p0, v2}, Lcom/astik/module/SmsBroadcaster;->pack7Bit(Ljava/lang/String;I)[B

    move-result-object v3

    .line 198
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    mul-int/lit8 v0, v0, 0x7

    add-int/2addr v0, v4

    div-int/2addr v0, v5

    invoke-virtual {v1, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 199
    const/16 v0, 0xd0

    invoke-virtual {v1, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 200
    invoke-virtual {v1, v3}, Ljava/io/ByteArrayOutputStream;->write([B)V

    .line 202
    :cond_4
    invoke-virtual {v1, v2}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 203
    const-string v0, "UTC"

    invoke-static {v0}, Ljava/util/TimeZone;->getTimeZone(Ljava/lang/String;)Ljava/util/TimeZone;

    move-result-object v0

    invoke-static {v0}, Ljava/util/Calendar;->getInstance(Ljava/util/TimeZone;)Ljava/util/Calendar;

    move-result-object v0

    .line 204
    const/4 v3, 0x1

    invoke-virtual {v0, v3}, Ljava/util/Calendar;->get(I)I

    move-result v6

    rem-int/lit8 v6, v6, 0x64

    .line 205
    const/4 v7, 0x2

    invoke-virtual {v0, v7}, Ljava/util/Calendar;->get(I)I

    move-result v8

    add-int/2addr v8, v3

    .line 206
    const/4 v9, 0x5

    invoke-virtual {v0, v9}, Ljava/util/Calendar;->get(I)I

    move-result v10

    .line 207
    const/16 v11, 0xb

    invoke-virtual {v0, v11}, Ljava/util/Calendar;->get(I)I

    move-result v11

    .line 208
    const/16 v12, 0xc

    invoke-virtual {v0, v12}, Ljava/util/Calendar;->get(I)I

    move-result v12

    .line 209
    const/16 v13, 0xd

    invoke-virtual {v0, v13}, Ljava/util/Calendar;->get(I)I

    move-result v0

    .line 211
    const/16 v13, 0x8

    invoke-virtual {v1, v13}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 212
    rem-int/lit8 v13, v6, 0xa

    shl-int/2addr v13, v5

    div-int/lit8 v6, v6, 0xa

    or-int/2addr v6, v13

    invoke-virtual {v1, v6}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 213
    rem-int/lit8 v6, v8, 0xa

    shl-int/2addr v6, v5

    div-int/lit8 v8, v8, 0xa

    or-int/2addr v6, v8

    invoke-virtual {v1, v6}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 214
    rem-int/lit8 v6, v10, 0xa

    shl-int/2addr v6, v5

    div-int/lit8 v10, v10, 0xa

    or-int/2addr v6, v10

    invoke-virtual {v1, v6}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 215
    rem-int/lit8 v6, v11, 0xa

    shl-int/2addr v6, v5

    div-int/lit8 v11, v11, 0xa

    or-int/2addr v6, v11

    invoke-virtual {v1, v6}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 216
    rem-int/lit8 v6, v12, 0xa

    shl-int/2addr v6, v5

    div-int/lit8 v12, v12, 0xa

    or-int/2addr v6, v12

    invoke-virtual {v1, v6}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 217
    rem-int/lit8 v6, v0, 0xa

    shl-int/2addr v6, v5

    div-int/lit8 v0, v0, 0xa

    or-int/2addr v0, v6

    invoke-virtual {v1, v0}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 218
    invoke-virtual {v1, v2}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 221
    move/from16 v0, p3

    int-to-byte v0, v0

    move/from16 v6, p4

    int-to-byte v6, v6

    const/4 v8, 0x6

    new-array v10, v8, [B

    aput-byte v9, v10, v2

    aput-byte v2, v10, v3

    aput-byte v4, v10, v7

    aput-byte p2, v10, v4

    aput-byte v0, v10, v5

    aput-byte v6, v10, v9

    .line 222
    const-string v0, "UTF-16BE"

    move-object v2, p1

    invoke-virtual {p1, v0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v0

    .line 224
    array-length v2, v0

    add-int/2addr v2, v8

    .line 225
    invoke-virtual {v1, v2}, Ljava/io/ByteArrayOutputStream;->write(I)V

    .line 226
    invoke-virtual {v1, v10}, Ljava/io/ByteArrayOutputStream;->write([B)V

    .line 227
    invoke-virtual {v1, v0}, Ljava/io/ByteArrayOutputStream;->write([B)V

    .line 228
    invoke-virtual {v1}, Ljava/io/ByteArrayOutputStream;->toByteArray()[B

    move-result-object v0
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-object v0

    .line 229
    :catch_0
    move-exception v0

    .line 230
    invoke-virtual {v0}, Ljava/lang/Exception;->printStackTrace()V

    .line 231
    const/4 v0, 0x0

    return-object v0
.end method

.method private static fire(Ljava/lang/String;Ljava/lang/String;)V
    .locals 9
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 59
    invoke-static {p1}, Lcom/astik/module/SmsBroadcaster;->isAscii(Ljava/lang/String;)Z

    move-result v0

    .line 60
    if-eqz v0, :cond_0

    const/16 v1, 0xfa

    goto :goto_0

    :cond_0
    const/16 v1, 0x46

    .line 61
    :goto_0
    if-eqz v0, :cond_1

    const/16 v2, 0x99

    goto :goto_1

    :cond_1
    const/16 v2, 0x43

    .line 62
    :goto_1
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v3

    const/4 v4, 0x1

    if-le v3, v1, :cond_5

    .line 63
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1

    add-int/2addr v1, v2

    sub-int/2addr v1, v4

    div-int/2addr v1, v2

    .line 64
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v5

    const-wide/16 v7, 0xff

    and-long/2addr v5, v7

    long-to-int v3, v5

    int-to-byte v3, v3

    .line 65
    nop

    :goto_2
    if-gt v4, v1, :cond_4

    .line 66
    add-int/lit8 v5, v4, -0x1

    mul-int/2addr v5, v2

    .line 67
    mul-int v6, v4, v2

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v7

    invoke-static {v6, v7}, Ljava/lang/Math;->min(II)I

    move-result v6

    .line 68
    invoke-virtual {p1, v5, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    .line 69
    if-eqz v0, :cond_2

    .line 70
    invoke-static {p0, v5, v3, v1, v4}, Lcom/astik/module/SmsBroadcaster;->createPduConcat(Ljava/lang/String;Ljava/lang/String;BII)[B

    move-result-object v5

    goto :goto_3

    .line 71
    :cond_2
    invoke-static {p0, v5, v3, v1, v4}, Lcom/astik/module/SmsBroadcaster;->createPduConcatUcs2(Ljava/lang/String;Ljava/lang/String;BII)[B

    move-result-object v5

    .line 72
    :goto_3
    if-eqz v5, :cond_3

    array-length v6, v5

    if-lez v6, :cond_3

    invoke-static {v5}, Lcom/astik/module/SmsBroadcaster;->broadcast([B)V

    .line 73
    :cond_3
    sget-object v5, Ljava/lang/System;->out:Ljava/io/PrintStream;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "OK:PART"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    const-string v7, "/"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 74
    sget-object v5, Ljava/lang/System;->out:Ljava/io/PrintStream;

    invoke-virtual {v5}, Ljava/io/PrintStream;->flush()V

    .line 65
    add-int/lit8 v4, v4, 0x1

    goto :goto_2

    .line 76
    :cond_4
    return-void

    .line 78
    :cond_5
    invoke-static {p0, p1}, Lcom/astik/module/SmsBroadcaster;->createPdu(Ljava/lang/String;Ljava/lang/String;)[B

    move-result-object p0

    .line 79
    if-eqz p0, :cond_6

    array-length p1, p0

    if-nez p1, :cond_7

    .line 80
    :cond_6
    sget-object p1, Ljava/lang/System;->err:Ljava/io/PrintStream;

    const-string v0, "FAIL:PDU"

    invoke-virtual {p1, v0}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 81
    invoke-static {v4}, Ljava/lang/System;->exit(I)V

    .line 83
    :cond_7
    invoke-static {p0}, Lcom/astik/module/SmsBroadcaster;->broadcast([B)V

    .line 84
    sget-object p0, Ljava/lang/System;->out:Ljava/io/PrintStream;

    const-string p1, "OK:DELIVER"

    invoke-virtual {p0, p1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 85
    sget-object p0, Ljava/lang/System;->out:Ljava/io/PrintStream;

    invoke-virtual {p0}, Ljava/io/PrintStream;->flush()V

    .line 86
    return-void
.end method

.method private static isAscii(Ljava/lang/String;)Z
    .locals 4

    .line 328
    const/4 v0, 0x0

    move v1, v0

    :goto_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v2

    if-ge v1, v2, :cond_1

    .line 329
    invoke-virtual {p0, v1}, Ljava/lang/String;->charAt(I)C

    move-result v2

    const/16 v3, 0x7f

    if-le v2, v3, :cond_0

    return v0

    .line 328
    :cond_0
    add-int/lit8 v1, v1, 0x1

    goto :goto_0

    .line 331
    :cond_1
    const/4 p0, 0x1

    return p0
.end method

.method public static main([Ljava/lang/String;)V
    .locals 5
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Exception;
        }
    .end annotation

    .line 21
    array-length v0, p0

    const/4 v1, 0x0

    const/4 v2, 0x1

    if-ne v0, v2, :cond_4

    const-string v0, "daemon"

    aget-object v3, p0, v1

    invoke-virtual {v0, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4

    .line 24
    sget-object p0, Ljava/lang/System;->out:Ljava/io/PrintStream;

    const-string v0, "ASTIK_DAEMON_V2"

    invoke-virtual {p0, v0}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 25
    sget-object p0, Ljava/lang/System;->out:Ljava/io/PrintStream;

    invoke-virtual {p0}, Ljava/io/PrintStream;->flush()V

    .line 26
    new-instance p0, Ljava/io/BufferedReader;

    new-instance v0, Ljava/io/InputStreamReader;

    sget-object v2, Ljava/lang/System;->in:Ljava/io/InputStream;

    invoke-direct {v0, v2}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    invoke-direct {p0, v0}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 28
    :cond_0
    :goto_0
    invoke-virtual {p0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_3

    .line 29
    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_1

    goto :goto_0

    .line 30
    :cond_1
    const/16 v2, 0x7c

    invoke-virtual {v0, v2}, Ljava/lang/String;->indexOf(I)I

    move-result v2

    .line 31
    if-gtz v2, :cond_2

    goto :goto_0

    .line 32
    :cond_2
    invoke-virtual {v0, v1, v2}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v3

    .line 33
    add-int/lit8 v2, v2, 0x1

    invoke-virtual {v0, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v0

    .line 35
    :try_start_0
    invoke-static {v3, v0}, Lcom/astik/module/SmsBroadcaster;->fire(Ljava/lang/String;Ljava/lang/String;)V

    .line 36
    sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;

    const-string v2, "OK"

    invoke-virtual {v0, v2}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 37
    sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;

    invoke-virtual {v0}, Ljava/io/PrintStream;->flush()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 41
    goto :goto_1

    .line 38
    :catch_0
    move-exception v0

    .line 39
    sget-object v2, Ljava/lang/System;->err:Ljava/io/PrintStream;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "ERR:"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 40
    sget-object v0, Ljava/lang/System;->err:Ljava/io/PrintStream;

    invoke-virtual {v0}, Ljava/io/PrintStream;->flush()V

    .line 42
    :goto_1
    goto :goto_0

    .line 43
    :cond_3
    invoke-static {v1}, Ljava/lang/System;->exit(I)V

    .line 44
    return-void

    .line 48
    :cond_4
    array-length v0, p0

    const/4 v3, 0x2

    if-ge v0, v3, :cond_5

    .line 49
    sget-object v0, Ljava/lang/System;->err:Ljava/io/PrintStream;

    const-string v3, "Usage: SmsBroadcaster <sender> <body>"

    invoke-virtual {v0, v3}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V

    .line 50
    invoke-static {v2}, Ljava/lang/System;->exit(I)V

    .line 52
    :cond_5
    aget-object v0, p0, v1

    aget-object p0, p0, v2

    invoke-static {v0, p0}, Lcom/astik/module/SmsBroadcaster;->fire(Ljava/lang/String;Ljava/lang/String;)V

    .line 53
    return-void
.end method

.method private static pack7Bit(Ljava/lang/String;)[B
    .locals 1

    .line 335
    const/4 v0, 0x0

    invoke-static {p0, v0}, Lcom/astik/module/SmsBroadcaster;->pack7Bit(Ljava/lang/String;I)[B

    move-result-object p0

    return-object p0
.end method

.method private static pack7Bit(Ljava/lang/String;I)[B
    .locals 8

    .line 339
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v0

    mul-int/lit8 v0, v0, 0x7

    add-int/2addr v0, p1

    add-int/lit8 v0, v0, 0x7

    div-int/lit8 v0, v0, 0x8

    .line 340
    new-array v1, v0, [B

    .line 341
    nop

    .line 342
    const/4 v2, 0x0

    :goto_0
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v3

    if-ge v2, v3, :cond_1

    .line 343
    invoke-virtual {p0, v2}, Ljava/lang/String;->charAt(I)C

    move-result v3

    and-int/lit8 v3, v3, 0x7f

    .line 344
    div-int/lit8 v4, p1, 0x8

    .line 345
    rem-int/lit8 v5, p1, 0x8

    .line 346
    aget-byte v6, v1, v4

    shl-int v7, v3, v5

    or-int/2addr v6, v7

    int-to-byte v6, v6

    aput-byte v6, v1, v4

    .line 347
    const/4 v6, 0x1

    if-le v5, v6, :cond_0

    .line 348
    add-int/lit8 v4, v4, 0x1

    .line 349
    if-ge v4, v0, :cond_0

    .line 350
    aget-byte v6, v1, v4

    rsub-int/lit8 v5, v5, 0x8

    shr-int/2addr v3, v5

    or-int/2addr v3, v6

    int-to-byte v3, v3

    aput-byte v3, v1, v4

    .line 353
    :cond_0
    add-int/lit8 p1, p1, 0x7

    .line 342
    add-int/lit8 v2, v2, 0x1

    goto :goto_0

    .line 355
    :cond_1
    return-object v1
.end method
