.class public Lcom/floatingmenu/VercelPoller;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field private static final CONFIG_FILE_PATH:Ljava/lang/String; = "/data/media/0/http/config.json"

.field private static final TAG:Ljava/lang/String; = "ZygiskMenuPoller"

.field private static sLastCheckTime:J

.field private static sLastMessageId:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static synthetic access$000(Ljava/lang/String;)V
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic access$100(Ljava/io/File;ZLjava/lang/String;Ljava/lang/String;)V
    .registers 4

    invoke-static {p0, p1, p2, p3}, Lcom/floatingmenu/VercelPoller;->writeValidationResponseToPrefs(Ljava/io/File;ZLjava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic access$200(Ljava/lang/String;)Ljava/lang/String;
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/VercelPoller;->querySocket(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$300()V
    .registers 0

    invoke-static {}, Lcom/floatingmenu/VercelPoller;->sendStateChangedBroadcast()V

    return-void
.end method

.method public static synthetic access$400(Ljava/io/File;)Ljava/lang/String;
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/VercelPoller;->readFileToString(Ljava/io/File;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$500(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 2

    invoke-static {p0, p1}, Lcom/floatingmenu/VercelPoller;->makePostRequest(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$600()Ljava/lang/String;
    .registers 1

    invoke-static {}, Lcom/floatingmenu/VercelPoller;->getLicenseKeyFromPrefs()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static synthetic access$700(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 2

    invoke-static {p0, p1}, Lcom/floatingmenu/VercelPoller;->extractJsonString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$800(Ljava/lang/String;Ljava/lang/String;)V
    .registers 2

    invoke-static {p0, p1}, Lcom/floatingmenu/VercelPoller;->broadcastSms(Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic access$900(Ljava/lang/String;)Ljava/lang/String;
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/VercelPoller;->handleLocalCommand(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static broadcastSms(Ljava/lang/String;Ljava/lang/String;)V
    .registers 6

    :try_start_0
    new-instance v0, Ljava/lang/ProcessBuilder;

    const/4 v1, 0x5

    new-array v1, v1, [Ljava/lang/String;

    const-string v2, "app_process"

    const/4 v3, 0x0

    aput-object v2, v1, v3

    const-string v2, "/system/bin"

    const/4 v3, 0x1

    aput-object v2, v1, v3

    const-string v2, "com.floatingmenu.SmsBroadcaster"

    const/4 v3, 0x2

    aput-object v2, v1, v3

    const/4 v2, 0x3

    aput-object p0, v1, v2

    const/4 p0, 0x4

    aput-object p1, v1, p0

    invoke-direct {v0, v1}, Ljava/lang/ProcessBuilder;-><init>([Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/ProcessBuilder;->environment()Ljava/util/Map;

    move-result-object p0

    const-string p1, "CLASSPATH"

    const-string v1, "/data/adb/modules/zygisk_floating_menu/classes.dex"

    invoke-interface {p0, p1, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    invoke-virtual {v0}, Ljava/lang/ProcessBuilder;->start()Ljava/lang/Process;
    :try_end_2b
    .catchall {:try_start_0 .. :try_end_2b} :catchall_2c

    goto :goto_34

    :catchall_2c
    move-exception p0

    const-string p1, "ZygiskMenuPoller"

    const-string v0, "Failed to spawn SmsBroadcaster process: "

    invoke-static {p1, v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_34
    return-void
.end method

.method private static disableSSLCertificateChecking()V
    .registers 4

    const/4 v0, 0x1

    :try_start_1
    new-array v0, v0, [Ljavax/net/ssl/TrustManager;

    new-instance v1, Lcom/floatingmenu/VercelPoller$3;

    invoke-direct {v1}, Lcom/floatingmenu/VercelPoller$3;-><init>()V

    const/4 v2, 0x0

    aput-object v1, v0, v2

    const-string v1, "SSL"

    invoke-static {v1}, Ljavax/net/ssl/SSLContext;->getInstance(Ljava/lang/String;)Ljavax/net/ssl/SSLContext;

    move-result-object v1

    new-instance v2, Ljava/security/SecureRandom;

    invoke-direct {v2}, Ljava/security/SecureRandom;-><init>()V

    const/4 v3, 0x0

    invoke-virtual {v1, v3, v0, v2}, Ljavax/net/ssl/SSLContext;->init([Ljavax/net/ssl/KeyManager;[Ljavax/net/ssl/TrustManager;Ljava/security/SecureRandom;)V

    invoke-virtual {v1}, Ljavax/net/ssl/SSLContext;->getSocketFactory()Ljavax/net/ssl/SSLSocketFactory;

    move-result-object v0

    invoke-static {v0}, Ljavax/net/ssl/HttpsURLConnection;->setDefaultSSLSocketFactory(Ljavax/net/ssl/SSLSocketFactory;)V

    new-instance v0, Lcom/floatingmenu/VercelPoller$4;

    invoke-direct {v0}, Lcom/floatingmenu/VercelPoller$4;-><init>()V

    invoke-static {v0}, Ljavax/net/ssl/HttpsURLConnection;->setDefaultHostnameVerifier(Ljavax/net/ssl/HostnameVerifier;)V
    :try_end_29
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_29} :catch_2a

    goto :goto_32

    :catch_2a
    move-exception v0

    const-string v1, "ZygiskMenuPoller"

    const-string v2, "Failed to disable SSL checking"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_32
    return-void
.end method

.method private static escapeJson(Ljava/lang/String;)Ljava/lang/String;
    .registers 3

    if-nez p0, :cond_5

    const-string p0, ""

    return-object p0

    :cond_5
    const-string v0, "\\"

    const-string v1, "\\\\"

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    const-string v0, "\""

    const-string v1, "\\\""

    invoke-virtual {p0, v0, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static extractJsonString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 10

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\""

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\":"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v0

    const/4 v2, 0x0

    const/4 v3, -0x1

    if-ne v0, v3, :cond_1c

    return-object v2

    :cond_1c
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    add-int/2addr p1, v0

    add-int/lit8 p1, p1, 0x2

    invoke-virtual {p0, v1, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result p1

    if-ne p1, v3, :cond_2a

    return-object v2

    :cond_2a
    const/4 v0, 0x1

    add-int/2addr p1, v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_33
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v5

    if-ge p1, v5, :cond_9f

    invoke-virtual {p0, p1}, Ljava/lang/String;->charAt(I)C

    move-result v5

    if-eqz v4, :cond_8b

    const/16 v4, 0x75

    if-ne v5, v4, :cond_63

    add-int/lit8 v5, p1, 0x4

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v6

    if-ge v5, v6, :cond_5f

    add-int/lit8 v6, p1, 0x1

    add-int/lit8 v7, p1, 0x5

    invoke-virtual {p0, v6, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v6

    const/16 v7, 0x10

    :try_start_55
    invoke-static {v6, v7}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;I)I

    move-result v6

    int-to-char v6, v6

    invoke-virtual {v1, v6}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;
    :try_end_5d
    .catch Ljava/lang/NumberFormatException; {:try_start_55 .. :try_end_5d} :catch_5f

    move p1, v5

    goto :goto_89

    :catch_5f
    :cond_5f
    :goto_5f
    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_89

    :cond_63
    const/16 v4, 0x6e

    if-ne v5, v4, :cond_6a

    const/16 v4, 0xa

    goto :goto_5f

    :cond_6a
    const/16 v4, 0x72

    if-ne v5, v4, :cond_71

    const/16 v4, 0xd

    goto :goto_5f

    :cond_71
    const/16 v4, 0x74

    if-ne v5, v4, :cond_78

    const/16 v4, 0x9

    goto :goto_5f

    :cond_78
    const/16 v4, 0x62

    if-ne v5, v4, :cond_7f

    const/16 v4, 0x8

    goto :goto_5f

    :cond_7f
    const/16 v4, 0x66

    if-ne v5, v4, :cond_86

    const/16 v4, 0xc

    goto :goto_5f

    :cond_86
    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    :goto_89
    const/4 v4, 0x0

    goto :goto_9d

    :cond_8b
    const/16 v6, 0x5c

    if-ne v5, v6, :cond_91

    const/4 v4, 0x1

    goto :goto_9d

    :cond_91
    const/16 v6, 0x22

    if-ne v5, v6, :cond_9a

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_9a
    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    :goto_9d
    add-int/2addr p1, v0

    goto :goto_33

    :cond_9f
    return-object v2
.end method

.method private static extractValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 7

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "name=\""

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "\">"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v0

    const/4 v3, -0x1

    if-eq v0, v3, :cond_3f

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    add-int/2addr p1, v0

    const-string v0, "</string>"

    invoke-virtual {p0, v0, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result v0

    if-eq v0, v3, :cond_3f

    invoke-virtual {p0, p1, v0}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_3f
    const/4 p0, 0x0

    return-object p0
.end method

.method private static getJsonBooleanValue(Ljava/lang/String;Ljava/lang/String;)Z
    .registers 5

    const/4 v0, 0x0

    if-eqz p0, :cond_6b

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_a

    goto :goto_6b

    :cond_a
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\""

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\":"

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    const/4 v2, -0x1

    if-ne v1, v2, :cond_25

    return v0

    :cond_25
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    add-int/2addr p1, v1

    :goto_2a
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    if-ge p1, v1, :cond_5b

    invoke-virtual {p0, p1}, Ljava/lang/String;->charAt(I)C

    move-result v1

    const/16 v2, 0x20

    if-eq v1, v2, :cond_58

    invoke-virtual {p0, p1}, Ljava/lang/String;->charAt(I)C

    move-result v1

    const/16 v2, 0x9

    if-eq v1, v2, :cond_58

    invoke-virtual {p0, p1}, Ljava/lang/String;->charAt(I)C

    move-result v1

    const/16 v2, 0xd

    if-eq v1, v2, :cond_58

    invoke-virtual {p0, p1}, Ljava/lang/String;->charAt(I)C

    move-result v1

    const/16 v2, 0xa

    if-eq v1, v2, :cond_58

    invoke-virtual {p0, p1}, Ljava/lang/String;->charAt(I)C

    move-result v1

    const/16 v2, 0x3a

    if-ne v1, v2, :cond_5b

    :cond_58
    add-int/lit8 p1, p1, 0x1

    goto :goto_2a

    :cond_5b
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    if-ge p1, v1, :cond_6b

    const-string v1, "true"

    invoke-virtual {p0, v1, p1}, Ljava/lang/String;->startsWith(Ljava/lang/String;I)Z

    move-result p0

    if-eqz p0, :cond_6b

    const/4 p0, 0x1

    return p0

    :cond_6b
    :goto_6b
    return v0
.end method

.method private static getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 9

    const-string v0, ""

    if-eqz p0, :cond_7a

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_c

    goto/16 :goto_7a

    :cond_c
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\""

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\":"

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    const/4 v3, -0x1

    if-ne v1, v3, :cond_27

    return-object v0

    :cond_27
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    add-int/2addr p1, v1

    invoke-virtual {p0, v2, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result p1

    if-ne p1, v3, :cond_33

    return-object v0

    :cond_33
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v2, 0x1

    add-int/2addr p1, v2

    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_3c
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v5

    if-ge p1, v5, :cond_7a

    invoke-virtual {p0, p1}, Ljava/lang/String;->charAt(I)C

    move-result v5

    if-eqz v4, :cond_65

    const/16 v4, 0x6e

    if-ne v5, v4, :cond_52

    const/16 v4, 0xa

    :goto_4e
    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_63

    :cond_52
    const/16 v4, 0x72

    if-ne v5, v4, :cond_59

    const/16 v4, 0xd

    goto :goto_4e

    :cond_59
    const/16 v4, 0x74

    if-ne v5, v4, :cond_60

    const/16 v4, 0x9

    goto :goto_4e

    :cond_60
    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    :goto_63
    const/4 v4, 0x0

    goto :goto_77

    :cond_65
    const/16 v6, 0x5c

    if-ne v5, v6, :cond_6b

    const/4 v4, 0x1

    goto :goto_77

    :cond_6b
    const/16 v6, 0x22

    if-ne v5, v6, :cond_74

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_74
    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    :goto_77
    add-int/lit8 p1, p1, 0x1

    goto :goto_3c

    :cond_7a
    :goto_7a
    return-object v0
.end method

.method private static getLicenseKeyFromPrefs()Ljava/lang/String;
    .registers 3

    :try_start_0
    invoke-static {}, Lcom/floatingmenu/VercelPoller;->readConfigJson()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_23

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_23

    const-string v1, "license_key"

    invoke-static {v0, v1}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_23

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1
    :try_end_18
    .catchall {:try_start_0 .. :try_end_18} :catchall_1b

    if-nez v1, :cond_23

    return-object v0

    :catchall_1b
    move-exception v0

    const-string v1, "ZygiskMenuPoller"

    const-string v2, "Failed to read license key from config.json: "

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_23
    const-string v0, ""

    return-object v0
.end method

.method private static handleLocalCommand(Ljava/lang/String;)Ljava/lang/String;
    .registers 30

    move-object/from16 v0, p0

    const-string v1, "|"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    const/4 v3, 0x0

    const-string v4, "\\|"

    const/4 v5, 0x1

    const/4 v6, 0x2

    const-string v7, ""

    if-eqz v2, :cond_1a

    invoke-virtual {v0, v4, v6}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v2

    aget-object v8, v2, v3

    aget-object v2, v2, v5

    goto :goto_1c

    :cond_1a
    move-object v8, v0

    move-object v2, v7

    :goto_1c
    const-string v9, "GET_CONFIG"

    invoke-virtual {v9, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    const-string v10, "telegram_chat_id"

    const-string v11, "telegram_token"

    if-eqz v9, :cond_47

    invoke-static {}, Lcom/floatingmenu/VercelPoller;->readConfigJson()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v11}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v10}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    :cond_47
    const-string v9, "SET_CONFIG"

    invoke-virtual {v9, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    const/4 v12, -0x1

    const-string v13, "ERROR"

    const-string v14, "OK"

    if-eqz v9, :cond_85

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_84

    invoke-virtual {v0, v4, v12}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v0

    array-length v1, v0

    if-le v1, v5, :cond_66

    aget-object v1, v0, v5

    move-object/from16 v17, v1

    goto :goto_68

    :cond_66
    move-object/from16 v17, v7

    :goto_68
    array-length v1, v0

    if-le v1, v6, :cond_6d

    aget-object v7, v0, v6

    :cond_6d
    move-object/from16 v18, v7

    const/4 v15, 0x0

    const/16 v16, 0x0

    const/16 v19, 0x0

    const/16 v20, 0x0

    const/16 v21, 0x0

    const/16 v22, 0x0

    const/16 v23, 0x0

    const/16 v24, 0x0

    const/16 v25, 0x0

    invoke-static/range {v15 .. v25}, Lcom/floatingmenu/VercelPoller;->updateConfigFields(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-object v14

    :cond_84
    return-object v13

    :cond_85
    const-string v9, "GET_LICENSE"

    invoke-virtual {v9, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_92

    invoke-static {}, Lcom/floatingmenu/VercelPoller;->getLicenseKeyFromPrefs()Ljava/lang/String;

    move-result-object v0

    return-object v0

    :cond_92
    const-string v9, "SET_LICENSE"

    invoke-virtual {v9, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    const-string v15, "license_key"

    if-eqz v9, :cond_a0

    invoke-static {v15, v2}, Lcom/floatingmenu/VercelPoller;->updateConfigField(Ljava/lang/String;Ljava/lang/String;)V

    return-object v14

    :cond_a0
    const-string v9, "GET_LICENSE_STATUS"

    invoke-virtual {v9, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    const-string v3, "license_status"

    if-eqz v9, :cond_b3

    invoke-static {}, Lcom/floatingmenu/VercelPoller;->readConfigJson()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v3}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    return-object v0

    :cond_b3
    const-string v9, "SET_LICENSE_STATUS"

    invoke-virtual {v9, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v9

    if-eqz v9, :cond_bf

    invoke-static {v3, v2}, Lcom/floatingmenu/VercelPoller;->updateConfigField(Ljava/lang/String;Ljava/lang/String;)V

    return-object v14

    :cond_bf
    const-string v2, "GET_SIM_SETTINGS"

    invoke-virtual {v2, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    const-string v9, "in"

    if-eqz v2, :cond_152

    invoke-static {}, Lcom/floatingmenu/VercelPoller;->readConfigJson()Ljava/lang/String;

    move-result-object v0

    const-string v2, "sim1_enabled"

    invoke-static {v0, v2}, Lcom/floatingmenu/VercelPoller;->getJsonBooleanValue(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v2

    invoke-static {v2}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v2

    const-string v3, "sim1_provider"

    invoke-static {v0, v3}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    const-string v4, "sim1_number"

    invoke-static {v0, v4}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v5, "sim2_enabled"

    invoke-static {v0, v5}, Lcom/floatingmenu/VercelPoller;->getJsonBooleanValue(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v5

    invoke-static {v5}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v5

    const-string v6, "sim2_provider"

    invoke-static {v0, v6}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    const-string v7, "sim2_number"

    invoke-static {v0, v7}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    const-string v8, "sim_country"

    invoke-static {v0, v8}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    if-eqz v8, :cond_109

    invoke-virtual {v8}, Ljava/lang/String;->isEmpty()Z

    move-result v10

    if-eqz v10, :cond_108

    goto :goto_109

    :cond_108
    move-object v9, v8

    :cond_109
    :goto_109
    const-string v8, "iamnotdeveloper"

    invoke-static {v0, v8}, Lcom/floatingmenu/VercelPoller;->getJsonBooleanValue(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v8

    const-string v10, "iamnoroot"

    invoke-static {v0, v10}, Lcom/floatingmenu/VercelPoller;->getJsonBooleanValue(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v10, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v8}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10, v0}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0

    :cond_152
    const-string v2, "SET_SIM_SETTINGS"

    invoke-virtual {v2, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_1e3

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_1e2

    invoke-virtual {v0, v4, v12}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v0

    array-length v1, v0

    const-string v2, "false"

    if-le v1, v5, :cond_16c

    aget-object v1, v0, v5

    goto :goto_16d

    :cond_16c
    move-object v1, v2

    :goto_16d
    array-length v4, v0

    const-string v5, "jio"

    if-le v4, v6, :cond_177

    aget-object v4, v0, v6

    move-object/from16 v21, v4

    goto :goto_179

    :cond_177
    move-object/from16 v21, v5

    :goto_179
    array-length v4, v0

    const/4 v6, 0x3

    if-le v4, v6, :cond_182

    aget-object v4, v0, v6

    move-object/from16 v22, v4

    goto :goto_184

    :cond_182
    move-object/from16 v22, v7

    :goto_184
    array-length v4, v0

    const/4 v6, 0x4

    if-le v4, v6, :cond_18b

    aget-object v4, v0, v6

    goto :goto_18c

    :cond_18b
    move-object v4, v2

    :goto_18c
    array-length v6, v0

    const/4 v8, 0x5

    if-le v6, v8, :cond_192

    aget-object v5, v0, v8

    :cond_192
    move-object/from16 v24, v5

    array-length v5, v0

    const/4 v6, 0x6

    if-le v5, v6, :cond_19a

    aget-object v7, v0, v6

    :cond_19a
    move-object/from16 v25, v7

    array-length v5, v0

    const/4 v6, 0x7

    if-le v5, v6, :cond_1a2

    aget-object v9, v0, v6

    :cond_1a2
    move-object/from16 v26, v9

    array-length v5, v0

    const/16 v6, 0x8

    if-le v5, v6, :cond_1ae

    const/16 v5, 0x8

    aget-object v5, v0, v5

    goto :goto_1af

    :cond_1ae
    move-object v5, v2

    :goto_1af
    array-length v6, v0

    const/16 v7, 0x9

    if-le v6, v7, :cond_1b8

    const/16 v2, 0x9

    aget-object v2, v0, v2

    :cond_1b8
    invoke-static {}, Lcom/floatingmenu/VercelPoller;->readConfigJson()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0, v15}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v16

    invoke-static {v0, v3}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v17

    invoke-static {v0, v11}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v18

    invoke-static {v0, v10}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v19

    const-string v0, "true"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v20

    invoke-virtual {v0, v4}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v23

    invoke-virtual {v0, v5}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v27

    invoke-virtual {v0, v2}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v28

    invoke-static/range {v16 .. v28}, Lcom/floatingmenu/VercelPoller;->writeConfigJson(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)V

    return-object v14

    :cond_1e2
    return-object v13

    :cond_1e3
    const-string v2, "GET_DEVICE_ID"

    invoke-virtual {v2, v8}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_218

    new-instance v0, Ljava/io/File;

    const-string v1, "/data/adb/modules/zygisk_floating_menu/device_id"

    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v1

    if-nez v1, :cond_20d

    :try_start_1f8
    invoke-static {}, Ljava/util/UUID;->randomUUID()Ljava/util/UUID;

    move-result-object v1

    invoke-virtual {v1}, Ljava/util/UUID;->toString()Ljava/lang/String;

    move-result-object v1

    new-instance v2, Ljava/io/FileWriter;

    invoke-direct {v2, v0}, Ljava/io/FileWriter;-><init>(Ljava/io/File;)V

    invoke-virtual {v2, v1}, Ljava/io/Writer;->write(Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/Writer;->close()V
    :try_end_20b
    .catchall {:try_start_1f8 .. :try_end_20b} :catchall_20c

    goto :goto_20d

    :catchall_20c
    nop

    :cond_20d
    :goto_20d
    invoke-static {v0}, Lcom/floatingmenu/VercelPoller;->readFileToString(Ljava/io/File;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_217

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v7

    :cond_217
    return-object v7

    :cond_218
    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_22e

    invoke-virtual {v0, v4, v6}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v0

    array-length v1, v0

    if-ne v1, v6, :cond_22e

    const/4 v1, 0x0

    aget-object v1, v0, v1

    aget-object v0, v0, v5

    invoke-static {v1, v0}, Lcom/floatingmenu/VercelPoller;->broadcastSms(Ljava/lang/String;Ljava/lang/String;)V

    return-object v14

    :cond_22e
    return-object v13
.end method

.method private static logToFile(Ljava/lang/String;)V
    .registers 4

    :try_start_0
    new-instance v0, Ljava/io/File;

    const-string v1, "/data/adb/modules/zygisk_floating_menu/poller.log"

    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    new-instance v1, Ljava/io/FileWriter;

    const/4 v2, 0x1

    invoke-direct {v1, v0, v2}, Ljava/io/FileWriter;-><init>(Ljava/io/File;Z)V

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    new-instance v2, Ljava/util/Date;

    invoke-direct {v2}, Ljava/util/Date;-><init>()V

    invoke-virtual {v2}, Ljava/util/Date;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " - "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "\n"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0}, Ljava/io/Writer;->write(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/io/Writer;->close()V
    :try_end_35
    .catchall {:try_start_0 .. :try_end_35} :catchall_35

    :catchall_35
    return-void
.end method

.method public static main([Ljava/lang/String;)V
    .registers 18

    move-object/from16 v0, p0

    const-string v1, "license_status"

    if-eqz v0, :cond_a2

    array-length v2, v0

    if-lez v2, :cond_a2

    invoke-static {}, Lcom/floatingmenu/VercelPoller;->disableSSLCertificateChecking()V

    const/4 v2, 0x0

    aget-object v2, v0, v2

    const-string v3, "UPDATE_TELEGRAM"

    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    const/4 v4, 0x2

    const-string v5, ""

    const/4 v6, 0x1

    if-eqz v3, :cond_33

    array-length v1, v0

    if-le v1, v6, :cond_21

    aget-object v1, v0, v6

    goto :goto_22

    :cond_21
    move-object v1, v5

    :goto_22
    array-length v2, v0

    if-le v2, v4, :cond_27

    aget-object v5, v0, v4

    :cond_27
    const-string v0, "telegram_token"

    invoke-static {v0, v1}, Lcom/floatingmenu/VercelPoller;->updateConfigField(Ljava/lang/String;Ljava/lang/String;)V

    const-string v0, "telegram_chat_id"

    :goto_2e
    invoke-static {v0, v5}, Lcom/floatingmenu/VercelPoller;->updateConfigField(Ljava/lang/String;Ljava/lang/String;)V

    goto/16 :goto_a1

    :cond_33
    const-string v3, "UPDATE_LICENSE"

    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_43

    array-length v1, v0

    if-le v1, v6, :cond_40

    aget-object v5, v0, v6

    :cond_40
    const-string v0, "license_key"

    goto :goto_2e

    :cond_43
    const-string v3, "UPDATE_LICENSE_STATUS"

    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_54

    array-length v2, v0

    if-le v2, v6, :cond_50

    aget-object v5, v0, v6

    :cond_50
    invoke-static {v1, v5}, Lcom/floatingmenu/VercelPoller;->updateConfigField(Ljava/lang/String;Ljava/lang/String;)V

    goto :goto_a1

    :cond_54
    const-string v1, "UPDATE_SIM"

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_a1

    array-length v1, v0

    const-string v2, "false"

    if-le v1, v6, :cond_65

    aget-object v1, v0, v6

    move-object v10, v1

    goto :goto_66

    :cond_65
    move-object v10, v2

    :goto_66
    array-length v1, v0

    if-le v1, v4, :cond_6d

    aget-object v1, v0, v4

    move-object v11, v1

    goto :goto_6e

    :cond_6d
    move-object v11, v5

    :goto_6e
    array-length v1, v0

    const/4 v3, 0x3

    if-le v1, v3, :cond_76

    aget-object v1, v0, v3

    move-object v12, v1

    goto :goto_77

    :cond_76
    move-object v12, v5

    :goto_77
    array-length v1, v0

    const/4 v3, 0x4

    if-le v1, v3, :cond_7d

    aget-object v2, v0, v3

    :cond_7d
    move-object v13, v2

    array-length v1, v0

    const/4 v2, 0x5

    if-le v1, v2, :cond_86

    aget-object v1, v0, v2

    move-object v14, v1

    goto :goto_87

    :cond_86
    move-object v14, v5

    :goto_87
    array-length v1, v0

    const/4 v2, 0x6

    if-le v1, v2, :cond_8d

    aget-object v5, v0, v2

    :cond_8d
    move-object v15, v5

    array-length v1, v0

    const/4 v2, 0x7

    if-le v1, v2, :cond_97

    aget-object v0, v0, v2

    :goto_94
    move-object/from16 v16, v0

    goto :goto_9a

    :cond_97
    const-string v0, "in"

    goto :goto_94

    :goto_9a
    const/4 v6, 0x0

    const/4 v7, 0x0

    const/4 v8, 0x0

    const/4 v9, 0x0

    invoke-static/range {v6 .. v16}, Lcom/floatingmenu/VercelPoller;->updateConfigFields(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_a1
    :goto_a1
    return-void

    :cond_a2
    const-string v2, "ZygiskMenuPoller"

    const-string v0, "Background root poller daemon started."

    invoke-static {v2, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    invoke-static {v0}, Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V

    invoke-static {}, Lcom/floatingmenu/VercelPoller;->disableSSLCertificateChecking()V

    invoke-static {}, Lcom/floatingmenu/VercelPoller;->startLocalSocketServer()V

    invoke-static {}, Lcom/floatingmenu/VercelPoller;->startSmsPollingThread()V

    :catch_b5
    :cond_b5
    :goto_b5
    :try_start_b5
    new-instance v0, Ljava/io/File;

    const-string v3, "/data/media/0/http/config.json"

    invoke-direct {v0, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v0

    if-nez v0, :cond_de

    const-string v3, ""

    const-string v4, ""

    const-string v5, ""

    const-string v6, ""

    const/4 v7, 0x0

    const-string v8, "jio"

    const-string v9, ""

    const/4 v10, 0x0

    const-string v11, "jio"

    const-string v12, ""

    const-string v13, "in"

    const/4 v14, 0x0

    const/4 v15, 0x0

    invoke-static/range {v3 .. v15}, Lcom/floatingmenu/VercelPoller;->writeConfigJson(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)V

    goto :goto_de

    :catchall_dc
    move-exception v0

    goto :goto_142

    :cond_de
    :goto_de
    const-wide/16 v3, 0x1388

    invoke-static {v3, v4}, Ljava/lang/Thread;->sleep(J)V

    invoke-static {}, Lcom/floatingmenu/VercelPoller;->getLicenseKeyFromPrefs()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_b5

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_f0

    goto :goto_b5

    :cond_f0
    const-string v3, "GET_LICENSE_STATUS"

    invoke-static {v3}, Lcom/floatingmenu/VercelPoller;->querySocket(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "Poller Loop iteration. Key: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, ", Status: "

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V

    const-string v4, "admin"

    invoke-virtual {v0, v4}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v4
    :try_end_118
    .catchall {:try_start_b5 .. :try_end_118} :catchall_dc

    const-string v5, "active"

    if-eqz v4, :cond_129

    :try_start_11c
    invoke-virtual {v5, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-nez v4, :cond_129

    invoke-static {v1, v5}, Lcom/floatingmenu/VercelPoller;->updateConfigField(Ljava/lang/String;Ljava/lang/String;)V

    invoke-static {}, Lcom/floatingmenu/VercelPoller;->sendStateChangedBroadcast()V

    move-object v3, v5

    :cond_129
    const-string v4, "pending"

    invoke-virtual {v4, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    const/4 v6, 0x0

    if-eqz v4, :cond_137

    invoke-static {v6, v0, v6}, Lcom/floatingmenu/VercelPoller;->validateKeyOnBehalfOfApp(Ljava/lang/String;Ljava/lang/String;Ljava/io/File;)V

    goto/16 :goto_b5

    :cond_137
    invoke-virtual {v5, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_b5

    invoke-static {v6, v0, v6}, Lcom/floatingmenu/VercelPoller;->verifyActiveKeyStatus(Ljava/lang/String;Ljava/lang/String;Ljava/io/File;)V
    :try_end_140
    .catchall {:try_start_11c .. :try_end_140} :catchall_dc

    goto/16 :goto_b5

    :goto_142
    const-string v3, "VercelPoller Error: "

    invoke-static {v2, v3, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V

    const-wide/16 v3, 0x2710

    :try_start_15c
    invoke-static {v3, v4}, Ljava/lang/Thread;->sleep(J)V
    :try_end_15f
    .catch Ljava/lang/InterruptedException; {:try_start_15c .. :try_end_15f} :catch_b5

    goto/16 :goto_b5
.end method

.method private static makePostRequest(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 7

    new-instance v0, Ljava/net/URL;

    invoke-direct {v0, p0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object p0

    check-cast p0, Ljava/net/HttpURLConnection;

    const-string v0, "POST"

    invoke-virtual {p0, v0}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/16 v0, 0xbb8

    invoke-virtual {p0, v0}, Ljava/net/URLConnection;->setConnectTimeout(I)V

    invoke-virtual {p0, v0}, Ljava/net/URLConnection;->setReadTimeout(I)V

    const/4 v0, 0x1

    invoke-virtual {p0, v0}, Ljava/net/URLConnection;->setDoOutput(Z)V

    const-string v0, "Content-Type"

    const-string v1, "text/plain"

    invoke-virtual {p0, v0, v1}, Ljava/net/URLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/net/URLConnection;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v0

    const-string v1, "UTF-8"

    invoke-virtual {p1, v1}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {v0}, Ljava/io/OutputStream;->flush()V

    invoke-virtual {v0}, Ljava/io/OutputStream;->close()V

    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result p1

    const/16 v0, 0xc8

    if-lt p1, v0, :cond_47

    const/16 v2, 0x12c

    if-ge p1, v2, :cond_47

    invoke-virtual {p0}, Ljava/net/URLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v2

    goto :goto_4b

    :cond_47
    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->getErrorStream()Ljava/io/InputStream;

    move-result-object v2

    :goto_4b
    if-eqz v2, :cond_93

    new-instance v3, Ljava/io/BufferedReader;

    new-instance v4, Ljava/io/InputStreamReader;

    invoke-direct {v4, v2, v1}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    invoke-direct {v3, v4}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    :goto_5c
    invoke-virtual {v3}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_66

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_5c

    :cond_66
    invoke-virtual {v3}, Ljava/io/BufferedReader;->close()V

    invoke-virtual {p0}, Ljava/net/HttpURLConnection;->disconnect()V

    if-ne p1, v0, :cond_73

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_73
    new-instance p0, Ljava/lang/Exception;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "HTTP "

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ": "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V

    throw p0

    :cond_93
    new-instance p0, Ljava/lang/Exception;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Response code: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {p0, p1}, Ljava/lang/Exception;-><init>(Ljava/lang/String;)V

    goto :goto_a8

    :goto_a7
    throw p0

    :goto_a8
    goto :goto_a7
.end method

.method private static querySocket(Ljava/lang/String;)Ljava/lang/String;
    .registers 9

    const-string v0, "UTF-8"

    const-string v1, "\n"

    const-string v2, ""

    if-nez p0, :cond_9

    return-object v2

    :cond_9
    const-string v3, "|"

    invoke-virtual {p0, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_1f

    const-string v3, "\\|"

    const/4 v4, 0x2

    invoke-virtual {p0, v3, v4}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v3

    const/4 v4, 0x0

    aget-object v4, v3, v4

    const/4 v5, 0x1

    aget-object v3, v3, v5

    goto :goto_21

    :cond_1f
    move-object v4, p0

    move-object v3, v2

    :goto_21
    const-string v5, "GET_LICENSE"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_2e

    invoke-static {}, Lcom/floatingmenu/VercelPoller;->getLicenseKeyFromPrefs()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_2e
    const-string v5, "GET_LICENSE_STATUS"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    const-string v6, "license_status"

    if-eqz v5, :cond_4a

    :try_start_38
    invoke-static {}, Lcom/floatingmenu/VercelPoller;->readConfigJson()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0, v6}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0
    :try_end_40
    .catchall {:try_start_38 .. :try_end_40} :catchall_41

    return-object p0

    :catchall_41
    move-exception p0

    const-string v0, "ZygiskMenuPoller"

    const-string v1, "Failed to read license status directly: "

    invoke-static {v0, v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v2

    :cond_4a
    const-string v5, "SET_LICENSE_STATUS"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    const-string v7, "OK"

    if-eqz v5, :cond_58

    invoke-static {v6, v3}, Lcom/floatingmenu/VercelPoller;->updateConfigField(Ljava/lang/String;Ljava/lang/String;)V

    return-object v7

    :cond_58
    const-string v5, "SET_LICENSE"

    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_66

    const-string p0, "license_key"

    invoke-static {p0, v3}, Lcom/floatingmenu/VercelPoller;->updateConfigField(Ljava/lang/String;Ljava/lang/String;)V

    return-object v7

    :cond_66
    const/4 v3, 0x0

    :try_start_67
    new-instance v4, Landroid/net/LocalSocket;

    invoke-direct {v4}, Landroid/net/LocalSocket;-><init>()V
    :try_end_6c
    .catchall {:try_start_67 .. :try_end_6c} :catchall_b0

    :try_start_6c
    new-instance v3, Landroid/net/LocalSocketAddress;

    const-string v5, "zygisk_menu_socket"

    invoke-direct {v3, v5}, Landroid/net/LocalSocketAddress;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v3}, Landroid/net/LocalSocket;->connect(Landroid/net/LocalSocketAddress;)V

    const/16 v3, 0xbb8

    invoke-virtual {v4, v3}, Landroid/net/LocalSocket;->setSoTimeout(I)V

    invoke-virtual {v4}, Landroid/net/LocalSocket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v3

    invoke-virtual {p0, v1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object p0

    invoke-virtual {v3, p0}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {v3}, Ljava/io/OutputStream;->flush()V

    new-instance p0, Ljava/io/BufferedReader;

    new-instance v1, Ljava/io/InputStreamReader;

    invoke-virtual {v4}, Landroid/net/LocalSocket;->getInputStream()Ljava/io/InputStream;

    move-result-object v3

    invoke-direct {v1, v3, v0}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    invoke-direct {p0, v1}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    invoke-virtual {p0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_ac

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0
    :try_end_a5
    .catchall {:try_start_6c .. :try_end_a5} :catchall_a9

    :try_start_a5
    invoke-virtual {v4}, Landroid/net/LocalSocket;->close()V
    :try_end_a8
    .catch Ljava/lang/Exception; {:try_start_a5 .. :try_end_a8} :catch_a8

    :catch_a8
    return-object p0

    :catchall_a9
    nop

    move-object v3, v4

    goto :goto_b1

    :cond_ac
    :try_start_ac
    invoke-virtual {v4}, Landroid/net/LocalSocket;->close()V

    goto :goto_b6

    :catchall_b0
    nop

    :goto_b1
    if-eqz v3, :cond_b6

    invoke-virtual {v3}, Landroid/net/LocalSocket;->close()V
    :try_end_b6
    .catch Ljava/lang/Exception; {:try_start_ac .. :try_end_b6} :catch_b6

    :catch_b6
    :cond_b6
    :goto_b6
    return-object v2
.end method

.method private static readConfigJson()Ljava/lang/String;
    .registers 3

    :try_start_0
    new-instance v0, Ljava/io/File;

    const-string v1, "/data/media/0/http/config.json"

    invoke-direct {v0, v1}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/io/File;->exists()Z

    move-result v1

    if-eqz v1, :cond_20

    invoke-static {v0}, Lcom/floatingmenu/VercelPoller;->readFileToString(Ljava/io/File;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_20

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0
    :try_end_17
    .catchall {:try_start_0 .. :try_end_17} :catchall_18

    return-object v0

    :catchall_18
    move-exception v0

    const-string v1, "ZygiskMenuPoller"

    const-string v2, "Failed to read config.json: "

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_20
    const-string v0, ""

    return-object v0
.end method

.method private static readFileToString(Ljava/io/File;)Ljava/lang/String;
    .registers 3

    :try_start_0
    new-instance v0, Ljava/io/BufferedReader;

    new-instance v1, Ljava/io/FileReader;

    invoke-direct {v1, p0}, Ljava/io/FileReader;-><init>(Ljava/io/File;)V

    invoke-direct {v0, v1}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    :goto_f
    invoke-virtual {v0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_19

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_f

    :cond_19
    invoke-virtual {v0}, Ljava/io/BufferedReader;->close()V

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_20
    .catchall {:try_start_0 .. :try_end_20} :catchall_21

    return-object p0

    :catchall_21
    const/4 p0, 0x0

    return-object p0
.end method

.method private static sendStateChangedBroadcast()V
    .registers 4

    :try_start_0
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object v0

    const/4 v1, 0x5

    new-array v1, v1, [Ljava/lang/String;

    const-string v2, "am"

    const/4 v3, 0x0

    aput-object v2, v1, v3

    const-string v2, "broadcast"

    const/4 v3, 0x1

    aput-object v2, v1, v3

    const-string v2, "-a"

    const/4 v3, 0x2

    aput-object v2, v1, v3

    const-string v2, "com.floatingmenu.ACTION_LICENSE_STATE_CHANGED"

    const/4 v3, 0x3

    aput-object v2, v1, v3

    const-string v2, "--receiver-include-background"

    const/4 v3, 0x4

    aput-object v2, v1, v3

    invoke-virtual {v0, v1}, Ljava/lang/Runtime;->exec([Ljava/lang/String;)Ljava/lang/Process;
    :try_end_23
    .catchall {:try_start_0 .. :try_end_23} :catchall_24

    goto :goto_2c

    :catchall_24
    move-exception v0

    const-string v1, "ZygiskMenuPoller"

    const-string v2, "Failed to send state change broadcast: "

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_2c
    return-void
.end method

.method private static startLocalSocketServer()V
    .registers 2

    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/floatingmenu/VercelPoller$6;

    invoke-direct {v1}, Lcom/floatingmenu/VercelPoller$6;-><init>()V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private static startSmsPollingThread()V
    .registers 2

    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/floatingmenu/VercelPoller$5;

    invoke-direct {v1}, Lcom/floatingmenu/VercelPoller$5;-><init>()V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private static updateConfigField(Ljava/lang/String;Ljava/lang/String;)V
    .registers 30

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    invoke-static {}, Lcom/floatingmenu/VercelPoller;->readConfigJson()Ljava/lang/String;

    move-result-object v2

    const-string v3, "license_key"

    invoke-static {v2, v3}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v5, "license_status"

    invoke-static {v2, v5}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    const-string v7, "telegram_token"

    invoke-static {v2, v7}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    const-string v9, "telegram_chat_id"

    invoke-static {v2, v9}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10

    const-string v11, "sim1_enabled"

    invoke-static {v2, v11}, Lcom/floatingmenu/VercelPoller;->getJsonBooleanValue(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v12

    const-string v13, "sim1_provider"

    invoke-static {v2, v13}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v14

    const-string v15, "sim1_number"

    invoke-static {v2, v15}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v16

    move-object/from16 v17, v4

    const-string v4, "sim2_enabled"

    invoke-static {v2, v4}, Lcom/floatingmenu/VercelPoller;->getJsonBooleanValue(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v18

    move-object/from16 v19, v6

    const-string v6, "sim2_provider"

    invoke-static {v2, v6}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v20

    move-object/from16 v21, v8

    const-string v8, "sim2_number"

    invoke-static {v2, v8}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v22

    move-object/from16 v23, v10

    const-string v10, "sim_country"

    invoke-static {v2, v10}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v24

    if-eqz v24, :cond_5e

    invoke-virtual/range {v24 .. v24}, Ljava/lang/String;->isEmpty()Z

    move-result v25

    if-eqz v25, :cond_5b

    goto :goto_5e

    :cond_5b
    :goto_5b
    move/from16 v25, v12

    goto :goto_61

    :cond_5e
    :goto_5e
    const-string v24, "in"

    goto :goto_5b

    :goto_61
    const-string v12, "iamnotdeveloper"

    invoke-static {v2, v12}, Lcom/floatingmenu/VercelPoller;->getJsonBooleanValue(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v26

    move-object/from16 v27, v14

    const-string v14, "iamnoroot"

    invoke-static {v2, v14}, Lcom/floatingmenu/VercelPoller;->getJsonBooleanValue(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v2

    invoke-virtual {v3, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_8f

    move-object v3, v1

    move v15, v2

    move-object/from16 v9, v16

    :goto_79
    move/from16 v10, v18

    move-object/from16 v4, v19

    :goto_7d
    move-object/from16 v11, v20

    :goto_7f
    move-object/from16 v5, v21

    :goto_81
    move-object/from16 v12, v22

    :goto_83
    move-object/from16 v6, v23

    :goto_85
    move-object/from16 v13, v24

    :goto_87
    move/from16 v7, v25

    :goto_89
    move/from16 v14, v26

    move-object/from16 v8, v27

    goto/16 :goto_17b

    :cond_8f
    invoke-virtual {v5, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_9e

    move-object v4, v1

    move v15, v2

    move-object/from16 v9, v16

    move-object/from16 v3, v17

    move/from16 v10, v18

    goto :goto_7d

    :cond_9e
    invoke-virtual {v7, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_b1

    move-object v5, v1

    move v15, v2

    move-object/from16 v9, v16

    move-object/from16 v3, v17

    move/from16 v10, v18

    move-object/from16 v4, v19

    move-object/from16 v11, v20

    goto :goto_81

    :cond_b1
    invoke-virtual {v9, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_c8

    move-object v6, v1

    move v15, v2

    move-object/from16 v9, v16

    move-object/from16 v3, v17

    move/from16 v10, v18

    move-object/from16 v4, v19

    move-object/from16 v11, v20

    move-object/from16 v5, v21

    move-object/from16 v12, v22

    goto :goto_85

    :cond_c8
    invoke-virtual {v11, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    const-string v5, "true"

    if-eqz v3, :cond_e9

    invoke-virtual {v5, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v12

    move v15, v2

    move v7, v12

    move-object/from16 v9, v16

    move-object/from16 v3, v17

    move/from16 v10, v18

    move-object/from16 v4, v19

    move-object/from16 v11, v20

    move-object/from16 v5, v21

    move-object/from16 v12, v22

    move-object/from16 v6, v23

    move-object/from16 v13, v24

    goto :goto_89

    :cond_e9
    invoke-virtual {v13, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_109

    move-object v8, v1

    move v15, v2

    move-object/from16 v9, v16

    move-object/from16 v3, v17

    move/from16 v10, v18

    move-object/from16 v4, v19

    move-object/from16 v11, v20

    move-object/from16 v5, v21

    move-object/from16 v12, v22

    move-object/from16 v6, v23

    move-object/from16 v13, v24

    move/from16 v7, v25

    move/from16 v14, v26

    goto/16 :goto_17b

    :cond_109
    invoke-virtual {v15, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_115

    move-object v9, v1

    move v15, v2

    :goto_111
    move-object/from16 v3, v17

    goto/16 :goto_79

    :cond_115
    invoke-virtual {v4, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_123

    invoke-virtual {v5, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v18

    :cond_11f
    :goto_11f
    move v15, v2

    move-object/from16 v9, v16

    goto :goto_111

    :cond_123
    invoke-virtual {v6, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_135

    move-object v11, v1

    move v15, v2

    move-object/from16 v9, v16

    move-object/from16 v3, v17

    move/from16 v10, v18

    move-object/from16 v4, v19

    goto/16 :goto_7f

    :cond_135
    invoke-virtual {v8, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_14b

    move-object v12, v1

    move v15, v2

    move-object/from16 v9, v16

    move-object/from16 v3, v17

    move/from16 v10, v18

    move-object/from16 v4, v19

    move-object/from16 v11, v20

    move-object/from16 v5, v21

    goto/16 :goto_83

    :cond_14b
    invoke-virtual {v10, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_165

    move-object v13, v1

    move v15, v2

    move-object/from16 v9, v16

    move-object/from16 v3, v17

    move/from16 v10, v18

    move-object/from16 v4, v19

    move-object/from16 v11, v20

    move-object/from16 v5, v21

    move-object/from16 v12, v22

    move-object/from16 v6, v23

    goto/16 :goto_87

    :cond_165
    invoke-virtual {v12, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_170

    invoke-virtual {v5, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v26

    goto :goto_11f

    :cond_170
    invoke-virtual {v14, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_11f

    invoke-virtual {v5, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v2

    goto :goto_11f

    :goto_17b
    invoke-static/range {v3 .. v15}, Lcom/floatingmenu/VercelPoller;->writeConfigJson(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)V

    return-void
.end method

.method private static updateConfigFields(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .registers 28

    move-object/from16 v0, p4

    move-object/from16 v1, p7

    invoke-static {}, Lcom/floatingmenu/VercelPoller;->readConfigJson()Ljava/lang/String;

    move-result-object v2

    if-eqz p0, :cond_d

    move-object/from16 v4, p0

    goto :goto_14

    :cond_d
    const-string v3, "license_key"

    invoke-static {v2, v3}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    move-object v4, v3

    :goto_14
    if-eqz p1, :cond_19

    move-object/from16 v5, p1

    goto :goto_20

    :cond_19
    const-string v3, "license_status"

    invoke-static {v2, v3}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    move-object v5, v3

    :goto_20
    if-eqz p2, :cond_25

    move-object/from16 v6, p2

    goto :goto_2c

    :cond_25
    const-string v3, "telegram_token"

    invoke-static {v2, v3}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    move-object v6, v3

    :goto_2c
    if-eqz p3, :cond_31

    move-object/from16 v7, p3

    goto :goto_38

    :cond_31
    const-string v3, "telegram_chat_id"

    invoke-static {v2, v3}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    move-object v7, v3

    :goto_38
    const-string v3, "true"

    if-eqz v0, :cond_42

    invoke-virtual {v3, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    :goto_40
    move v8, v0

    goto :goto_49

    :cond_42
    const-string v0, "sim1_enabled"

    invoke-static {v2, v0}, Lcom/floatingmenu/VercelPoller;->getJsonBooleanValue(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    goto :goto_40

    :goto_49
    if-eqz p5, :cond_4e

    move-object/from16 v9, p5

    goto :goto_55

    :cond_4e
    const-string v0, "sim1_provider"

    invoke-static {v2, v0}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    move-object v9, v0

    :goto_55
    if-eqz p6, :cond_5a

    move-object/from16 v10, p6

    goto :goto_61

    :cond_5a
    const-string v0, "sim1_number"

    invoke-static {v2, v0}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    move-object v10, v0

    :goto_61
    if-eqz v1, :cond_69

    invoke-virtual {v3, v1}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    :goto_67
    move v11, v0

    goto :goto_70

    :cond_69
    const-string v0, "sim2_enabled"

    invoke-static {v2, v0}, Lcom/floatingmenu/VercelPoller;->getJsonBooleanValue(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    goto :goto_67

    :goto_70
    if-eqz p8, :cond_75

    move-object/from16 v12, p8

    goto :goto_7c

    :cond_75
    const-string v0, "sim2_provider"

    invoke-static {v2, v0}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    move-object v12, v0

    :goto_7c
    if-eqz p9, :cond_81

    move-object/from16 v13, p9

    goto :goto_88

    :cond_81
    const-string v0, "sim2_number"

    invoke-static {v2, v0}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    move-object v13, v0

    :goto_88
    if-eqz p10, :cond_8d

    move-object/from16 v0, p10

    goto :goto_93

    :cond_8d
    const-string v0, "sim_country"

    invoke-static {v2, v0}, Lcom/floatingmenu/VercelPoller;->getJsonStringValue(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    :goto_93
    if-eqz v0, :cond_9e

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_9c

    goto :goto_9e

    :cond_9c
    :goto_9c
    move-object v14, v0

    goto :goto_a1

    :cond_9e
    :goto_9e
    const-string v0, "in"

    goto :goto_9c

    :goto_a1
    const-string v0, "iamnotdeveloper"

    invoke-static {v2, v0}, Lcom/floatingmenu/VercelPoller;->getJsonBooleanValue(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v15

    const-string v0, "iamnoroot"

    invoke-static {v2, v0}, Lcom/floatingmenu/VercelPoller;->getJsonBooleanValue(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v16

    invoke-static/range {v4 .. v16}, Lcom/floatingmenu/VercelPoller;->writeConfigJson(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)V

    return-void
.end method

.method private static validateKeyOnBehalfOfApp(Ljava/lang/String;Ljava/lang/String;Ljava/io/File;)V
    .registers 5

    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/floatingmenu/VercelPoller$1;

    invoke-direct {v1, p1, p0, p2}, Lcom/floatingmenu/VercelPoller$1;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/io/File;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private static verifyActiveKeyStatus(Ljava/lang/String;Ljava/lang/String;Ljava/io/File;)V
    .registers 10

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sget-wide v2, Lcom/floatingmenu/VercelPoller;->sLastCheckTime:J

    sub-long v2, v0, v2

    const-wide/32 v4, 0x927c0

    cmp-long v6, v2, v4

    if-gez v6, :cond_10

    return-void

    :cond_10
    sput-wide v0, Lcom/floatingmenu/VercelPoller;->sLastCheckTime:J

    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/floatingmenu/VercelPoller$2;

    invoke-direct {v1, p1, p2, p0}, Lcom/floatingmenu/VercelPoller$2;-><init>(Ljava/lang/String;Ljava/io/File;Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private static writeConfigJson(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)V
    .registers 22

    const-string v0, "chmod"

    const-string v1, "{\n  \"license_key\": \""

    :try_start_4
    new-instance v2, Ljava/io/File;

    const-string v3, "/data/media/0/http/config.json"

    invoke-direct {v2, v3}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2}, Ljava/io/File;->getParentFile()Ljava/io/File;

    move-result-object v3

    if-eqz v3, :cond_1e

    invoke-virtual {v3}, Ljava/io/File;->exists()Z

    move-result v4

    if-nez v4, :cond_1e

    invoke-virtual {v3}, Ljava/io/File;->mkdirs()Z

    goto :goto_1e

    :catchall_1b
    move-exception v0

    goto/16 :goto_f6

    :cond_1e
    :goto_1e
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {p0}, Lcom/floatingmenu/VercelPoller;->escapeJson(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\",\n  \"license_status\": \""

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p1}, Lcom/floatingmenu/VercelPoller;->escapeJson(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\",\n  \"telegram_token\": \""

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p2}, Lcom/floatingmenu/VercelPoller;->escapeJson(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\",\n  \"telegram_chat_id\": \""

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p3}, Lcom/floatingmenu/VercelPoller;->escapeJson(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\",\n  \"sim1_enabled\": "

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move v1, p4

    invoke-virtual {v4, p4}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ",\n  \"sim1_provider\": \""

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p5}, Lcom/floatingmenu/VercelPoller;->escapeJson(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\",\n  \"sim1_number\": \""

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {p6}, Lcom/floatingmenu/VercelPoller;->escapeJson(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\",\n  \"sim2_enabled\": "

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v1, p7

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ",\n  \"sim2_provider\": \""

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static/range {p8 .. p8}, Lcom/floatingmenu/VercelPoller;->escapeJson(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\",\n  \"sim2_number\": \""

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static/range {p9 .. p9}, Lcom/floatingmenu/VercelPoller;->escapeJson(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\",\n  \"sim_country\": \""

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static/range {p10 .. p10}, Lcom/floatingmenu/VercelPoller;->escapeJson(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "\",\n  \"iamnotdeveloper\": "

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v1, p11

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ",\n  \"iamnoroot\": "

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move/from16 v1, p12

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, "\n}"

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    new-instance v4, Ljava/io/FileWriter;

    invoke-direct {v4, v2}, Ljava/io/FileWriter;-><init>(Ljava/io/File;)V

    invoke-virtual {v4, v1}, Ljava/io/Writer;->write(Ljava/lang/String;)V

    invoke-virtual {v4}, Ljava/io/Writer;->close()V

    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object v1

    const/4 v4, 0x3

    new-array v5, v4, [Ljava/lang/String;

    const/4 v6, 0x0

    aput-object v0, v5, v6

    const-string v7, "666"

    const/4 v8, 0x1

    aput-object v7, v5, v8

    invoke-virtual {v2}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v2

    const/4 v7, 0x2

    aput-object v2, v5, v7

    invoke-virtual {v1, v5}, Ljava/lang/Runtime;->exec([Ljava/lang/String;)Ljava/lang/Process;

    if-eqz v3, :cond_fd

    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object v1

    new-array v2, v4, [Ljava/lang/String;

    aput-object v0, v2, v6

    const-string v0, "777"

    aput-object v0, v2, v8

    invoke-virtual {v3}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object v0

    aput-object v0, v2, v7

    invoke-virtual {v1, v2}, Ljava/lang/Runtime;->exec([Ljava/lang/String;)Ljava/lang/Process;
    :try_end_f5
    .catchall {:try_start_4 .. :try_end_f5} :catchall_1b

    goto :goto_fd

    :goto_f6
    const-string v1, "ZygiskMenuPoller"

    const-string v2, "Failed to write config.json: "

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_fd
    :goto_fd
    return-void
.end method

.method private static writeValidationResponseToPrefs(Ljava/io/File;ZLjava/lang/String;Ljava/lang/String;)V
    .registers 9

    const-string v0, "</string>\n</map>\n"

    const-string v1, "</string>\n    <string name=\"license_key\">"

    const-string v2, "\" />\n    <string name=\"validation_status\">"

    const-string v3, "<?xml version=\'1.0\' encoding=\'utf-8\' standalone=\'yes\' ?>\n<map>\n    <boolean name=\"is_licensed\" value=\""

    :try_start_8
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, p1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    new-instance p1, Ljava/io/FileWriter;

    invoke-direct {p1, p0}, Ljava/io/FileWriter;-><init>(Ljava/io/File;)V

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/io/Writer;->write(Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/io/Writer;->close()V

    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object p1

    const/4 p2, 0x3

    new-array p2, p2, [Ljava/lang/String;

    const-string p3, "chmod"

    const/4 v0, 0x0

    aput-object p3, p2, v0

    const-string p3, "660"

    const/4 v0, 0x1

    aput-object p3, p2, v0

    invoke-virtual {p0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object p3

    const/4 v0, 0x2

    aput-object p3, p2, v0

    invoke-virtual {p1, p2}, Ljava/lang/Runtime;->exec([Ljava/lang/String;)Ljava/lang/Process;
    :try_end_49
    .catchall {:try_start_8 .. :try_end_49} :catchall_4a

    goto :goto_62

    :catchall_4a
    move-exception p1

    new-instance p2, Ljava/lang/StringBuilder;

    const-string p3, "Failed to write validation response to prefs file "

    invoke-direct {p2, p3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Ljava/io/File;->getAbsolutePath()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p2, "ZygiskMenuPoller"

    invoke-static {p2, p0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_62
    return-void
.end method
