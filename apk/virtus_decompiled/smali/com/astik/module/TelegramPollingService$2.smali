.class Lcom/astik/module/TelegramPollingService$2;
.super Ljava/lang/Object;
.source "TelegramPollingService.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/astik/module/TelegramPollingService;->startStreamThread()V
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

    .line 232
    iput-object p1, p0, Lcom/astik/module/TelegramPollingService$2;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 235
    :cond_0
    iget-object v0, p0, Lcom/astik/module/TelegramPollingService$2;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-static {v0}, Lcom/astik/module/TelegramPollingService;->access$000(Lcom/astik/module/TelegramPollingService;)Z

    move-result v0

    if-eqz v0, :cond_1

    iget-object v0, p0, Lcom/astik/module/TelegramPollingService$2;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-static {v0}, Lcom/astik/module/TelegramPollingService;->access$400(Lcom/astik/module/TelegramPollingService;)Z

    move-result v0

    if-nez v0, :cond_1

    .line 237
    :try_start_0
    iget-object v0, p0, Lcom/astik/module/TelegramPollingService$2;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-static {v0}, Lcom/astik/module/TelegramPollingService;->access$500(Lcom/astik/module/TelegramPollingService;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    goto :goto_0

    :catch_0
    move-exception v0

    .line 239
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "stream loop error: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "VirtusModule"

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    :goto_0
    const/4 v0, 0x0

    :goto_1
    const/16 v1, 0x28

    if-ge v0, v1, :cond_0

    .line 242
    iget-object v1, p0, Lcom/astik/module/TelegramPollingService$2;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-static {v1}, Lcom/astik/module/TelegramPollingService;->access$000(Lcom/astik/module/TelegramPollingService;)Z

    move-result v1

    if-eqz v1, :cond_0

    iget-object v1, p0, Lcom/astik/module/TelegramPollingService$2;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-static {v1}, Lcom/astik/module/TelegramPollingService;->access$400(Lcom/astik/module/TelegramPollingService;)Z

    move-result v1

    if-nez v1, :cond_0

    const-wide/16 v1, 0x32

    .line 243
    :try_start_1
    invoke-static {v1, v2}, Ljava/lang/Thread;->sleep(J)V
    :try_end_1
    .catch Ljava/lang/InterruptedException; {:try_start_1 .. :try_end_1} :catch_1

    add-int/lit8 v0, v0, 0x1

    goto :goto_1

    :catch_1
    :cond_1
    return-void
.end method
