.class Lcom/floatingmenu/FloatingMenu$1$11$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$1:Lcom/floatingmenu/FloatingMenu$1$11;

.field final synthetic val$chatId:Ljava/lang/String;

.field final synthetic val$token:Ljava/lang/String;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1$11;Ljava/lang/String;Ljava/lang/String;)V
    .registers 4

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$11$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$11;

    iput-object p2, p0, Lcom/floatingmenu/FloatingMenu$1$11$1;->val$token:Ljava/lang/String;

    iput-object p3, p0, Lcom/floatingmenu/FloatingMenu$1$11$1;->val$chatId:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 6

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$11$1;->val$token:Ljava/lang/String;

    iget-object v1, p0, Lcom/floatingmenu/FloatingMenu$1$11$1;->val$chatId:Ljava/lang/String;

    invoke-static {v0, v1}, Lcom/floatingmenu/FloatingMenu;->saveTelegramConfig(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_21

    iget-object v1, p0, Lcom/floatingmenu/FloatingMenu$1$11$1;->val$token:Ljava/lang/String;

    iget-object v2, p0, Lcom/floatingmenu/FloatingMenu$1$11$1;->val$chatId:Ljava/lang/String;

    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "\ud83d\ude80 Telegram Forwarding Test Successful!\nDevice: "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v4, Landroid/os/Build;->MODEL:Ljava/lang/String;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v1, v2, v3}, Lcom/floatingmenu/FloatingMenu;->sendTelegramMessageAsync(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    :cond_21
    iget-object v1, p0, Lcom/floatingmenu/FloatingMenu$1$11$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$11;

    iget-object v1, v1, Lcom/floatingmenu/FloatingMenu$1$11;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iget-object v1, v1, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    new-instance v2, Lcom/floatingmenu/FloatingMenu$1$11$1$1;

    invoke-direct {v2, p0, v0}, Lcom/floatingmenu/FloatingMenu$1$11$1$1;-><init>(Lcom/floatingmenu/FloatingMenu$1$11$1;Z)V

    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method
