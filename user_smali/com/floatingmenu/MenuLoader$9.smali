.class Lcom/floatingmenu/MenuLoader$9;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic val$app:Landroid/app/Application;


# direct methods
.method public constructor <init>(Landroid/app/Application;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$9;->val$app:Landroid/app/Application;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 5

    const-string v0, "SystemUI License Manager Thread started"

    const-string v1, "ZygiskMenu @Hivirtus"

    invoke-static {v1, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :goto_7
    const-wide/16 v2, 0x1388

    :try_start_9
    invoke-static {v2, v3}, Ljava/lang/Thread;->sleep(J)V

    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$9;->val$app:Landroid/app/Application;

    # invokes: Lcom/floatingmenu/MenuLoader;->triggerSystemUiOverlayCheck(Landroid/app/Application;)V
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$1900(Landroid/app/Application;)V
    :try_end_11
    .catchall {:try_start_9 .. :try_end_11} :catchall_12

    goto :goto_7

    :catchall_12
    move-exception v0

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "Error in SystemUI license manager: "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Throwable;->getMessage()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_7
.end method
