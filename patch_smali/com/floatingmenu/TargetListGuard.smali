.class Lcom/floatingmenu/TargetListGuard;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field private static final LIST_PATH:Ljava/lang/String; = "/data/adb/modules/zygisk_floating_menu/target_packages.txt"


# direct methods
.method public constructor <init>()V
    .registers 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V
    return-void
.end method

.method public static isSelectedPackage(Ljava/lang/String;)Z
    .registers 6

    const/4 v0, 0x0

    if-eqz p0, :ret

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :go

    :ret
    return v0

    :go
    :try_start_0
    new-instance v1, Ljava/io/BufferedReader;

    new-instance v2, Ljava/io/FileReader;

    const-string v3, "/data/adb/modules/zygisk_floating_menu/target_packages.txt"

    invoke-direct {v2, v3}, Ljava/io/FileReader;-><init>(Ljava/lang/String;)V

    invoke-direct {v1, v2}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_all

    :try_start_read
    :loop
    invoke-virtual {v1}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :done

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :loop

    const-string v3, "*"

    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :loop

    invoke-virtual {v2, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :found

    goto :loop

    :found
    invoke-virtual {v1}, Ljava/io/BufferedReader;->close()V

    const/4 v0, 0x1

    return v0

    :done
    invoke-virtual {v1}, Ljava/io/BufferedReader;->close()V
    :try_end_read
    .catch Ljava/lang/Exception; {:try_start_read .. :try_end_read} :catch_all

    :catch_all
    return v0
.end method
