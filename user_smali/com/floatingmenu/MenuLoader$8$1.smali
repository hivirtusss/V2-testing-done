.class Lcom/floatingmenu/MenuLoader$8$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/MenuLoader$8;

.field final synthetic val$globalKey:Ljava/lang/String;

.field final synthetic val$globalStatus:Ljava/lang/String;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/MenuLoader$8;Ljava/lang/String;Ljava/lang/String;)V
    .registers 4

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$8$1;->this$0:Lcom/floatingmenu/MenuLoader$8;

    iput-object p2, p0, Lcom/floatingmenu/MenuLoader$8$1;->val$globalStatus:Ljava/lang/String;

    iput-object p3, p0, Lcom/floatingmenu/MenuLoader$8$1;->val$globalKey:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    const-string v0, "active"

    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$8$1;->val$globalStatus:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_12

    :cond_a
    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$8$1;->this$0:Lcom/floatingmenu/MenuLoader$8;

    iget-object v0, v0, Lcom/floatingmenu/MenuLoader$8;->val$app:Landroid/app/Application;

    # invokes: Lcom/floatingmenu/MenuLoader;->dismissSystemUiOverlay(Landroid/app/Application;)V
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$2000(Landroid/app/Application;)V

    goto :goto_2f

    :cond_12
    # getter for: Lcom/floatingmenu/MenuLoader;->sForegroundApp:Ljava/lang/String;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$1800()Ljava/lang/String;

    move-result-object v0

    # invokes: Lcom/floatingmenu/MenuLoader;->isTargetApplication(Ljava/lang/String;)Z
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$2100(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_a

    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$8$1;->val$globalStatus:Ljava/lang/String;

    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$8$1;->val$globalKey:Ljava/lang/String;

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_28

    const-string v0, "required"

    :cond_28
    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$8$1;->this$0:Lcom/floatingmenu/MenuLoader$8;

    iget-object v1, v1, Lcom/floatingmenu/MenuLoader$8;->val$app:Landroid/app/Application;

    # invokes: Lcom/floatingmenu/MenuLoader;->showSystemUiOverlay(Landroid/app/Application;Ljava/lang/String;)V
    invoke-static {v1, v0}, Lcom/floatingmenu/MenuLoader;->access$2200(Landroid/app/Application;Ljava/lang/String;)V

    :goto_2f
    return-void
.end method
