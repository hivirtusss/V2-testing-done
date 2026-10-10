.class Lcom/virtus/module/TelegramPollingService$3;
.super Ljava/lang/Object;
.source "TelegramPollingService.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/virtus/module/TelegramPollingService;->runStream()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/virtus/module/TelegramPollingService;


# direct methods
.method constructor <init>(Lcom/virtus/module/TelegramPollingService;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 265
    iput-object p1, p0, Lcom/virtus/module/TelegramPollingService$3;->this$0:Lcom/virtus/module/TelegramPollingService;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 1

    .line 266
    iget-object v0, p0, Lcom/virtus/module/TelegramPollingService$3;->this$0:Lcom/virtus/module/TelegramPollingService;

    invoke-static {v0}, Lcom/virtus/module/TelegramPollingService;->access$500(Lcom/virtus/module/TelegramPollingService;)V

    return-void
.end method
