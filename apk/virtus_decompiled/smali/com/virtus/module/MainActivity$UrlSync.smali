.class Lcom/virtus/module/MainActivity$UrlSync;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


.field final synthetic this$0:Lcom/virtus/module/MainActivity;

.field final synthetic val$key:Ljava/lang/String;


.method constructor <init>(Lcom/virtus/module/MainActivity;Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/virtus/module/MainActivity$UrlSync;->this$0:Lcom/virtus/module/MainActivity;

    iput-object p2, p0, Lcom/virtus/module/MainActivity$UrlSync;->val$key:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


.method public run()V
    .locals 2

    iget-object v0, p0, Lcom/virtus/module/MainActivity$UrlSync;->this$0:Lcom/virtus/module/MainActivity;

    iget-object v1, p0, Lcom/virtus/module/MainActivity$UrlSync;->val$key:Ljava/lang/String;

    invoke-static {v0, v1}, Lcom/virtus/module/BotUrlSync;->syncFromBot(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method
