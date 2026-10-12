.class Lcom/astik/module/TelegramPollingService$1;
.super Ljava/lang/Object;
.source "TelegramPollingService.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/astik/module/TelegramPollingService;->startConfigThread()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/astik/module/TelegramPollingService;


# direct methods
.method constructor <init>(Lcom/astik/module/TelegramPollingService;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 181
    iput-object p1, p0, Lcom/astik/module/TelegramPollingService$1;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 184
    :cond_0
    :goto_0
    iget-object v0, p0, Lcom/astik/module/TelegramPollingService$1;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-static {v0}, Lcom/astik/module/TelegramPollingService;->access$000(Lcom/astik/module/TelegramPollingService;)Z

    move-result v0

    if-eqz v0, :cond_3

    const-wide/16 v0, 0x7d0

    .line 185
    :try_start_0
    invoke-static {v0, v1}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_3

    .line 186
    :try_start_1
    iget-object v0, p0, Lcom/astik/module/TelegramPollingService$1;->this$0:Lcom/astik/module/TelegramPollingService;

    const-string v1, "astik_module_prefs"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Lcom/astik/module/TelegramPollingService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/astik/module/TelegramPollingService;->access$100(Lcom/astik/module/TelegramPollingService;Landroid/content/SharedPreferences;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    .line 189
    :catch_0
    :try_start_2
    iget-object v0, p0, Lcom/astik/module/TelegramPollingService$1;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-static {v0}, Lcom/astik/module/TelegramPollingService;->access$200(Lcom/astik/module/TelegramPollingService;)Landroid/os/PowerManager$WakeLock;

    move-result-object v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/astik/module/TelegramPollingService$1;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-static {v0}, Lcom/astik/module/TelegramPollingService;->access$200(Lcom/astik/module/TelegramPollingService;)Landroid/os/PowerManager$WakeLock;

    move-result-object v0

    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->isHeld()Z

    move-result v0

    if-nez v0, :cond_1

    .line 190
    iget-object v0, p0, Lcom/astik/module/TelegramPollingService$1;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-static {v0}, Lcom/astik/module/TelegramPollingService;->access$200(Lcom/astik/module/TelegramPollingService;)Landroid/os/PowerManager$WakeLock;

    move-result-object v0

    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->acquire()V
    :try_end_2
    .catch Ljava/lang/Exception; {:try_start_2 .. :try_end_2} :catch_1

    .line 195
    :catch_1
    :cond_1
    :try_start_3
    iget-object v0, p0, Lcom/astik/module/TelegramPollingService$1;->this$0:Lcom/astik/module/TelegramPollingService;

    const-string v1, "notification"

    invoke-virtual {v0, v1}, Lcom/astik/module/TelegramPollingService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/app/NotificationManager;

    if-eqz v0, :cond_0

    .line 196
    iget-object v1, p0, Lcom/astik/module/TelegramPollingService$1;->this$0:Lcom/astik/module/TelegramPollingService;

    .line 197
    sget-boolean v2, Lcom/astik/module/TelegramPollingService;->cfgMonitoring:Z

    if-eqz v2, :cond_2

    const-string v2, "\u25cf MONITORING LIVE \u2014 auto inject active"

    goto :goto_1

    :cond_2
    const-string v2, "Service running \u2014 monitoring OFF"

    .line 196
    :goto_1
    invoke-static {v1, v2}, Lcom/astik/module/TelegramPollingService;->access$300(Lcom/astik/module/TelegramPollingService;Ljava/lang/String;)Landroid/app/Notification;

    move-result-object v1

    const/16 v2, 0x3e7

    invoke-virtual {v0, v2, v1}, Landroid/app/NotificationManager;->notify(ILandroid/app/Notification;)V
    :try_end_3
    .catch Ljava/lang/Exception; {:try_start_3 .. :try_end_3} :catch_2

    goto :goto_0

    :catch_2
    nop

    goto :goto_0

    :catch_3
    :cond_3
    return-void
.end method
