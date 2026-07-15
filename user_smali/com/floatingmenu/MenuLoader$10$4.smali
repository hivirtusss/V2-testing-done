.class Lcom/floatingmenu/MenuLoader$10$4;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/MenuLoader$10;

.field final synthetic val$input:Landroid/widget/EditText;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/MenuLoader$10;Landroid/widget/EditText;)V
    .registers 3

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$10$4;->this$0:Lcom/floatingmenu/MenuLoader$10;

    iput-object p2, p0, Lcom/floatingmenu/MenuLoader$10$4;->val$input:Landroid/widget/EditText;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    const-string v0, "GET_LICENSE"

    # invokes: Lcom/floatingmenu/MenuLoader;->querySocket(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$600(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_1f

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_1f

    new-instance v1, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v2, Lcom/floatingmenu/MenuLoader$10$4$1;

    invoke-direct {v2, p0, v0}, Lcom/floatingmenu/MenuLoader$10$4$1;-><init>(Lcom/floatingmenu/MenuLoader$10$4;Ljava/lang/String;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :cond_1f
    return-void
.end method
