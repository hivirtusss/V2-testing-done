.class Lcom/floatingmenu/FloatingMenu$3;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic val$intent:Landroid/content/Intent;

.field final synthetic val$receiver:Landroid/content/BroadcastReceiver;

.field final synthetic val$receiverContext:Landroid/content/Context;


# direct methods
.method public constructor <init>(Landroid/content/BroadcastReceiver;Landroid/content/Context;Landroid/content/Intent;)V
    .registers 4

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$3;->val$receiver:Landroid/content/BroadcastReceiver;

    iput-object p2, p0, Lcom/floatingmenu/FloatingMenu$3;->val$receiverContext:Landroid/content/Context;

    iput-object p3, p0, Lcom/floatingmenu/FloatingMenu$3;->val$intent:Landroid/content/Intent;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    :try_start_0
    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$3;->val$receiver:Landroid/content/BroadcastReceiver;

    iget-object v1, p0, Lcom/floatingmenu/FloatingMenu$3;->val$receiverContext:Landroid/content/Context;

    iget-object v2, p0, Lcom/floatingmenu/FloatingMenu$3;->val$intent:Landroid/content/Intent;

    invoke-virtual {v0, v1, v2}, Landroid/content/BroadcastReceiver;->onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    :try_end_9
    .catchall {:try_start_0 .. :try_end_9} :catchall_a

    goto :goto_12

    :catchall_a
    move-exception v0

    const-string v1, "zygisk_floating_menu"

    const-string v2, "Error in onReceive"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_12
    return-void
.end method
