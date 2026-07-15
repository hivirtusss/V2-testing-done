.class Lcom/floatingmenu/TargetPackageGuard;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field private static final TARGET_FILE:Ljava/lang/String; = "/data/adb/modules/zygisk_floating_menu/target_packages.txt"

.field private static sLoaded:Z

.field private static sSelected:Ljava/util/HashSet;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/HashSet<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field


# direct methods
.method static constructor <clinit>()V
    .registers 1

    const/4 v0, 0x0

    sput-boolean v0, Lcom/floatingmenu/TargetPackageGuard;->sLoaded:Z

    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    sput-object v0, Lcom/floatingmenu/TargetPackageGuard;->sSelected:Ljava/util/HashSet;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static ensureLoaded()V
    .registers 6

    sget-boolean v0, Lcom/floatingmenu/TargetPackageGuard;->sLoaded:Z

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x1

    sput-boolean v0, Lcom/floatingmenu/TargetPackageGuard;->sLoaded:Z

    sget-object v0, Lcom/floatingmenu/TargetPackageGuard;->sSelected:Ljava/util/HashSet;

    invoke-virtual {v0}, Ljava/util/HashSet;->clear()V

    :try_start_0
    new-instance v0, Ljava/io/BufferedReader;

    new-instance v1, Ljava/io/FileReader;

    sget-object v2, Lcom/floatingmenu/TargetPackageGuard;->TARGET_FILE:Ljava/lang/String;

    invoke-direct {v1, v2}, Ljava/io/FileReader;-><init>(Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_all

    :goto_read
    :try_start_read
    invoke-virtual {v0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_done

    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :goto_read

    const-string v2, "*"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :goto_read

    invoke-static {v1}, Lcom/floatingmenu/TargetPackageGuard;->isBlockedPackage(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :goto_read

    sget-object v2, Lcom/floatingmenu/TargetPackageGuard;->sSelected:Ljava/util/HashSet;

    invoke-virtual {v2, v1}, Ljava/util/HashSet;->add(Ljava/lang/Object;)Z

    goto :goto_read

    :cond_done
    invoke-virtual {v0}, Ljava/io/BufferedReader;->close()V
    :try_end_read
    .catch Ljava/lang/Exception; {:try_start_read .. :try_end_read} :catch_all

    :catch_all
    return-void
.end method

.method public static extractPackageName(Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    if-eqz p0, :cond_empty

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_ok

    :cond_empty
    const-string v0, ""

    return-object v0

    :cond_ok
    const-string v0, ":"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_split

    invoke-virtual {p0, v0}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v0

    const/4 v1, 0x0

    aget-object p0, v0, v1

    :cond_split
    return-object p0
.end method

.method public static isBlockedPackage(Ljava/lang/String;)Z
    .registers 2

    if-nez p0, :cond_0

    const/4 v0, 0x1

    return v0

    :cond_0
    const-string v0, "me.weishu.kernelsu"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1

    const/4 v0, 0x1

    return v0

    :cond_1
    const-string v0, "com.topjohnwu.magisk"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2

    const/4 v0, 0x1

    return v0

    :cond_2
    const-string v0, "bin.mt.plus"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3

    const/4 v0, 0x1

    return v0

    :cond_3
    const-string v0, "bin.mt.plus.canary"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_4

    const/4 v0, 0x1

    return v0

    :cond_4
    const-string v0, "me.bmax.apatch"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_5

    const/4 v0, 0x1

    return v0

    :cond_5
    const-string v0, "com.android.systemui"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_6

    const/4 v0, 0x1

    return v0

    :cond_6
    const-string v0, "com.android.settings"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_7

    const/4 v0, 0x1

    return v0

    :cond_7
    const-string v0, "com.android.launcher3"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_8

    const/4 v0, 0x1

    return v0

    :cond_8
    const-string v0, "com.miui.home"

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_ok

    const/4 v0, 0x1

    return v0

    :cond_ok
    const/4 v0, 0x0

    return v0
.end method

.method public static isBlockedProcess(Ljava/lang/String;)Z
    .registers 3

    if-eqz p0, :cond_blocked

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_check

    :cond_blocked
    const/4 v0, 0x1

    return v0

    :cond_check
    invoke-virtual {p0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p0

    const-string v0, "systemui"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_1

    const/4 v0, 0x1

    return v0

    :cond_1
    const-string v0, "kernelsu"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_2

    const/4 v0, 0x1

    return v0

    :cond_2
    const-string v0, "magisk"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_3

    const/4 v0, 0x1

    return v0

    :cond_3
    const-string v0, "bin.mt"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_4

    const/4 v0, 0x1

    return v0

    :cond_4
    const-string v0, "apatch"

    invoke-virtual {p0, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_ok

    const/4 v0, 0x1

    return v0

    :cond_ok
    const/4 v0, 0x0

    return v0
.end method

.method public static isPackageSelected(Ljava/lang/String;)Z
    .registers 2

    invoke-static {}, Lcom/floatingmenu/TargetPackageGuard;->ensureLoaded()V

    if-eqz p0, :cond_false

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_check

    :cond_false
    const/4 v0, 0x0

    return v0

    :cond_check
    invoke-static {p0}, Lcom/floatingmenu/TargetPackageGuard;->isBlockedPackage(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_sel

    const/4 v0, 0x0

    return v0

    :cond_sel
    sget-object v0, Lcom/floatingmenu/TargetPackageGuard;->sSelected:Ljava/util/HashSet;

    invoke-virtual {v0}, Ljava/util/HashSet;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_has

    const/4 v0, 0x0

    return v0

    :cond_has
    sget-object v0, Lcom/floatingmenu/TargetPackageGuard;->sSelected:Ljava/util/HashSet;

    invoke-virtual {v0, p0}, Ljava/util/HashSet;->contains(Ljava/lang/Object;)Z

    move-result v0

    return v0
.end method

.method public static reload()V
    .registers 1

    const/4 v0, 0x0

    sput-boolean v0, Lcom/floatingmenu/TargetPackageGuard;->sLoaded:Z

    invoke-static {}, Lcom/floatingmenu/TargetPackageGuard;->ensureLoaded()V

    return-void
.end method

.method public static shouldHookProcess(Ljava/lang/String;)Z
    .registers 2

    invoke-static {p0}, Lcom/floatingmenu/TargetPackageGuard;->isBlockedProcess(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_ok

    const/4 v0, 0x0

    return v0

    :cond_ok
    invoke-static {p0}, Lcom/floatingmenu/TargetPackageGuard;->extractPackageName(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/floatingmenu/TargetPackageGuard;->isPackageSelected(Ljava/lang/String;)Z

    move-result v0

    return v0
.end method
