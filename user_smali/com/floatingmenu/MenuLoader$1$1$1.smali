.class Lcom/floatingmenu/MenuLoader$1$1$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$1:Lcom/floatingmenu/MenuLoader$1$1;

.field final synthetic val$activity:Landroid/app/Activity;

.field final synthetic val$prefs:Landroid/content/SharedPreferences;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/MenuLoader$1$1;Landroid/content/SharedPreferences;Landroid/app/Activity;)V
    .registers 4

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$1$1$1;->this$1:Lcom/floatingmenu/MenuLoader$1$1;

    iput-object p2, p0, Lcom/floatingmenu/MenuLoader$1$1$1;->val$prefs:Landroid/content/SharedPreferences;

    iput-object p3, p0, Lcom/floatingmenu/MenuLoader$1$1$1;->val$activity:Landroid/app/Activity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 6

    const-string v0, "GET_LICENSE"

    # invokes: Lcom/floatingmenu/MenuLoader;->querySocket(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$600(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "GET_LICENSE_STATUS"

    # invokes: Lcom/floatingmenu/MenuLoader;->querySocket(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v1}, Lcom/floatingmenu/MenuLoader;->access$600(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    const-string v2, "GET_SIM_SETTINGS"

    # invokes: Lcom/floatingmenu/MenuLoader;->querySocket(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v2}, Lcom/floatingmenu/MenuLoader;->access$600(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    if-eqz v0, :cond_2b

    if-eqz v1, :cond_2b

    if-nez v2, :cond_19

    goto :goto_2b

    :cond_19
    new-instance v3, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v4

    invoke-direct {v3, v4}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v4, Lcom/floatingmenu/MenuLoader$1$1$1$1;

    invoke-direct {v4, p0, v2, v0, v1}, Lcom/floatingmenu/MenuLoader$1$1$1$1;-><init>(Lcom/floatingmenu/MenuLoader$1$1$1;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-virtual {v3, v4}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void

    :cond_2b
    :goto_2b
    const-string v0, "ZygiskMenu @Hivirtus"

    const-string v1, "Socket query returned null. Retaining current license and SIM settings."

    invoke-static {v0, v1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method
