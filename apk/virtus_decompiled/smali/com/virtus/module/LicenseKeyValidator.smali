.class public Lcom/virtus/module/LicenseKeyValidator;
.super Ljava/lang/Object;
.source "LicenseKeyValidator.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static isRegisteredKey(Ljava/lang/String;)Z
    .locals 2

    if-eqz p0, :invalid

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :invalid

    invoke-virtual {p0}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object p0

    const-string v0, "KEY-"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :invalid

    const/4 p0, 0x1

    return p0

    :invalid
    const/4 p0, 0x0

    return p0
.end method
