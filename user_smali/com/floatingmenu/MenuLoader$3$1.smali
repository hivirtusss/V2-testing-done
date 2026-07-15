.class Lcom/floatingmenu/MenuLoader$3$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/MenuLoader$3;

.field final synthetic val$finalSentIntent:Landroid/app/PendingIntent;

.field final synthetic val$finalSentIntentsList:Ljava/util/List;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/MenuLoader$3;Landroid/app/PendingIntent;Ljava/util/List;)V
    .registers 4

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$3$1;->this$0:Lcom/floatingmenu/MenuLoader$3;

    iput-object p2, p0, Lcom/floatingmenu/MenuLoader$3$1;->val$finalSentIntent:Landroid/app/PendingIntent;

    iput-object p3, p0, Lcom/floatingmenu/MenuLoader$3$1;->val$finalSentIntentsList:Ljava/util/List;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 5

    const-string v0, "ZygiskMenu @Hivirtus"

    const-wide/16 v1, 0x12c

    :try_start_4
    invoke-static {v1, v2}, Ljava/lang/Thread;->sleep(J)V

    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$3$1;->val$finalSentIntent:Landroid/app/PendingIntent;

    const/4 v2, -0x1

    if-eqz v1, :cond_19

    const-string v1, "Triggering PendingIntent asynchronously with Activity.RESULT_OK"

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$3$1;->val$finalSentIntent:Landroid/app/PendingIntent;

    invoke-virtual {v1, v2}, Landroid/app/PendingIntent;->send(I)V

    goto :goto_3f

    :catchall_17
    move-exception v1

    goto :goto_3a

    :cond_19
    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$3$1;->val$finalSentIntentsList:Ljava/util/List;

    if-eqz v1, :cond_3f

    const-string v1, "Triggering multi-part PendingIntents asynchronously with Activity.RESULT_OK"

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$3$1;->val$finalSentIntentsList:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_28
    :goto_28
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_3f

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/app/PendingIntent;

    if-eqz v3, :cond_28

    invoke-virtual {v3, v2}, Landroid/app/PendingIntent;->send(I)V
    :try_end_39
    .catchall {:try_start_4 .. :try_end_39} :catchall_17

    goto :goto_28

    :goto_3a
    const-string v2, "Error triggering Mock PendingIntent callback: "

    invoke-static {v0, v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_3f
    :goto_3f
    return-void
.end method
