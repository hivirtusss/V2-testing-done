.class Lcom/floatingmenu/MenuLoader$8;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic val$app:Landroid/app/Application;


# direct methods
.method public constructor <init>(Landroid/app/Application;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$8;->val$app:Landroid/app/Application;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 5

    const-string v0, "GET_LICENSE_STATUS"

    # invokes: Lcom/floatingmenu/MenuLoader;->querySocket(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$600(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "GET_LICENSE"

    # invokes: Lcom/floatingmenu/MenuLoader;->querySocket(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v1}, Lcom/floatingmenu/MenuLoader;->access$600(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    new-instance v2, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v3

    invoke-direct {v2, v3}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v3, Lcom/floatingmenu/MenuLoader$8$1;

    invoke-direct {v3, p0, v0, v1}, Lcom/floatingmenu/MenuLoader$8$1;-><init>(Lcom/floatingmenu/MenuLoader$8;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v2, v3}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method
