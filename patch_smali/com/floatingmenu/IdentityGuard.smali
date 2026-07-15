.class Lcom/floatingmenu/IdentityGuard;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field private static sLoaded:Z

.field private static sPackage:Ljava/lang/String;

.field private static sAndroidId:Ljava/lang/String;

.field private static sSignatureSpoof:Z

.field private static sSignatureSha256:Ljava/lang/String;

.field private static sVersionCode:I

.field private static sVersionName:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .registers 1

    const/4 v0, 0x0

    sput-boolean v0, Lcom/floatingmenu/IdentityGuard;->sLoaded:Z

    const-string v0, ""

    sput-object v0, Lcom/floatingmenu/IdentityGuard;->sPackage:Ljava/lang/String;

    sput-object v0, Lcom/floatingmenu/IdentityGuard;->sAndroidId:Ljava/lang/String;

    sput-boolean v0, Lcom/floatingmenu/IdentityGuard;->sSignatureSpoof:Z

    sput-object v0, Lcom/floatingmenu/IdentityGuard;->sSignatureSha256:Ljava/lang/String;

    const/4 v0, 0x0

    sput v0, Lcom/floatingmenu/IdentityGuard;->sVersionCode:I

    const-string v0, ""

    sput-object v0, Lcom/floatingmenu/IdentityGuard;->sVersionName:Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static ensureLoaded(Ljava/lang/String;)V
    .registers 6

    if-eqz p0, :cond_ret

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_go

    :cond_ret
    return-void

    :cond_go
    sget-object v0, Lcom/floatingmenu/IdentityGuard;->sPackage:Ljava/lang/String;

    invoke-virtual {p0, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    sput-object p0, Lcom/floatingmenu/IdentityGuard;->sPackage:Ljava/lang/String;

    const/4 v0, 0x1

    sput-boolean v0, Lcom/floatingmenu/IdentityGuard;->sLoaded:Z

    const-string v1, ""

    sput-object v1, Lcom/floatingmenu/IdentityGuard;->sAndroidId:Ljava/lang/String;

    const/4 v2, 0x0

    sput-boolean v2, Lcom/floatingmenu/IdentityGuard;->sSignatureSpoof:Z

    sput-object v1, Lcom/floatingmenu/IdentityGuard;->sSignatureSha256:Ljava/lang/String;

    sput v2, Lcom/floatingmenu/IdentityGuard;->sVersionCode:I

    sput-object v1, Lcom/floatingmenu/IdentityGuard;->sVersionName:Ljava/lang/String;

    :try_start_0
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "/data/adb/modules/zygisk_floating_menu/virtus_config/"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "."

    const-string v4, "_"

    invoke-virtual {p0, v3, v4}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, ".json"

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    new-instance v3, Ljava/io/BufferedReader;

    new-instance v4, Ljava/io/FileReader;

    invoke-direct {v4, v1}, Ljava/io/FileReader;-><init>(Ljava/lang/String;)V

    invoke-direct {v3, v4}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_all

    :try_start_read
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    :goto_read
    invoke-virtual {v3}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_parse

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_read

    :cond_parse
    invoke-virtual {v3}, Ljava/io/BufferedReader;->close()V

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_done

    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v1, "android_id"

    invoke-virtual {v3, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_sig

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v4

    const/16 v5, 0x10

    if-ne v4, v5, :cond_sig

    sput-object v1, Lcom/floatingmenu/IdentityGuard;->sAndroidId:Ljava/lang/String;

    :cond_sig
    const-string v1, "signature_spoof"

    invoke-virtual {v3, v1, v2}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v1

    sput-boolean v1, Lcom/floatingmenu/IdentityGuard;->sSignatureSpoof:Z

    const-string v1, "signature_sha256"

    const-string v2, ""

    invoke-virtual {v3, v1, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    sput-object v1, Lcom/floatingmenu/IdentityGuard;->sSignatureSha256:Ljava/lang/String;

    const-string v1, "version_code"

    const/4 v2, 0x0

    invoke-virtual {v3, v1, v2}, Lorg/json/JSONObject;->optInt(Ljava/lang/String;I)I

    move-result v1

    sput v1, Lcom/floatingmenu/IdentityGuard;->sVersionCode:I

    const-string v1, "version_name"

    const-string v2, ""

    invoke-virtual {v3, v1, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    sput-object v1, Lcom/floatingmenu/IdentityGuard;->sVersionName:Ljava/lang/String;
    :try_end_read
    .catch Ljava/lang/Exception; {:try_start_read .. :try_end_read} :catch_all

    :cond_done
    :catch_all
    return-void
.end method

.method public static getSpoofedAndroidId(Ljava/lang/String;)Ljava/lang/String;
    .registers 2

    invoke-static {p0}, Lcom/floatingmenu/IdentityGuard;->ensureLoaded(Ljava/lang/String;)V

    sget-object v0, Lcom/floatingmenu/IdentityGuard;->sAndroidId:Ljava/lang/String;

    if-eqz v0, :cond_empty

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_empty

    return-object v0

    :cond_empty
    const/4 v0, 0x0

    return-object v0
.end method

.method public static isSignatureSpoofEnabled()Z
    .registers 1

    sget-boolean v0, Lcom/floatingmenu/IdentityGuard;->sSignatureSpoof:Z

    return v0
.end method

.method public static getSignatureSha256()Ljava/lang/String;
    .registers 1

    sget-object v0, Lcom/floatingmenu/IdentityGuard;->sSignatureSha256:Ljava/lang/String;

    return-object v0
.end method

.method public static invalidate()V
    .registers 1

    const/4 v0, 0x0

    sput-boolean v0, Lcom/floatingmenu/IdentityGuard;->sLoaded:Z

    return-void
.end method

.method public static interceptSettings(Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;
    .registers 8
    const/4 v0, 0x0
    if-eqz p0, :ret
    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sIsTargetPackage:Z
    if-nez v1, :ret
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$000()Ljava/lang/String;
    move-result-object v1
    invoke-static {v1}, Lcom/floatingmenu/IdentityGuard;->getSpoofedAndroidId(Ljava/lang/String;)Ljava/lang/String;
    move-result-object v1
    if-nez v1, :ret
    invoke-virtual {p0}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;
    move-result-object v2
    const-string v3, "call"
    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z
    move-result v3
    if-eqz v3, :q
    if-eqz p1, :ret
    array-length v2, p1
    const/4 v3, 0x0
    :cl
    if-ge v3, v2, :ret
    aget-object v4, p1, v3
    instance-of v5, v4, Ljava/lang/String;
    if-eqz v5, :cn
    check-cast v4, Ljava/lang/String;
    const-string v5, "android_id"
    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v4
    if-eqz v4, :cn
    new-instance v0, Landroid/os/Bundle;
    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V
    const-string v2, "value"
    invoke-virtual {v0, v2, v1}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V
    return-object v0
    :cn
    add-int/lit8 v3, v3, 0x1
    goto :cl
    :q
    const-string v3, "query"
    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v2
    if-eqz v2, :ret
    if-eqz p1, :ret
    array-length v2, p1
    const/4 v3, 0x0
    :ql
    if-ge v3, v2, :ret
    aget-object v4, p1, v3
    instance-of v5, v4, Landroid/net/Uri;
    if-eqz v5, :qn
    check-cast v4, Landroid/net/Uri;
    const-string v5, "android_id"
    invoke-virtual {v4}, Landroid/net/Uri;->getLastPathSegment()Ljava/lang/String;
    move-result-object v4
    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
    move-result v4
    if-eqz v4, :mk
    :qn
    add-int/lit8 v3, v3, 0x1
    goto :ql
    :mk
    new-instance v0, Landroid/database/MatrixCursor;
    const/4 v2, 0x3
    new-array v3, v2, [Ljava/lang/String;
    const-string v4, "_id"
    const/4 v5, 0x0
    aput-object v4, v3, v5
    const-string v4, "name"
    const/4 v6, 0x1
    aput-object v4, v3, v6
    const/4 v4, 0x2
    const-string v7, "value"
    aput-object v7, v3, v4
    invoke-direct {v0, v3}, Landroid/database/MatrixCursor;-><init>([Ljava/lang/String;)V
    new-array v2, v2, [Ljava/lang/Object;
    invoke-static {v6}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;
    move-result-object v3
    aput-object v3, v2, v5
    const-string v3, "android_id"
    aput-object v3, v2, v6
    aput-object v1, v2, v4
    invoke-virtual {v0, v2}, Landroid/database/MatrixCursor;->addRow([Ljava/lang/Object;)V
    :ret
    return-object v0
.end method

.method public static applyPackageInfoSpoof(Ljava/lang/Object;)Ljava/lang/Object;
    .registers 6

    if-nez p0, :go

    return-object p0

    :go
    instance-of v0, p0, Landroid/content/pm/PackageInfo;

    if-nez v0, :go2

    return-object p0

    :go2
    check-cast p0, Landroid/content/pm/PackageInfo;

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$000()Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    if-eqz v0, :ret

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :ret

    sget v0, Lcom/floatingmenu/IdentityGuard;->sVersionCode:I

    if-lez v0, :sig

    iput v0, p0, Landroid/content/pm/PackageInfo;->versionCode:I

    :sig
    sget-object v0, Lcom/floatingmenu/IdentityGuard;->sVersionName:Ljava/lang/String;

    if-eqz v0, :sig2

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :sig2

    iput-object v0, p0, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;

    :sig2
    invoke-static {}, Lcom/floatingmenu/IdentityGuard;->isSignatureSpoofEnabled()Z

    move-result v0

    if-eqz v0, :ret

    :try_start_0
    new-instance v0, Landroid/content/pm/Signature;

    const-string v1, "3082"

    invoke-direct {v0, v1}, Landroid/content/pm/Signature;-><init>(Ljava/lang/String;)V

    const/4 v1, 0x1

    new-array v1, v1, [Landroid/content/pm/Signature;

    const/4 v2, 0x0

    aput-object v0, v1, v2

    iput-object v1, p0, Landroid/content/pm/PackageInfo;->signatures:[Landroid/content/pm/Signature;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :ret

    :ret
    return-object p0
.end method
