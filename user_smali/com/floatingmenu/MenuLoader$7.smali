.class Lcom/floatingmenu/MenuLoader$7;
.super Landroid/content/BroadcastReceiver;
.source "SourceFile"


# instance fields
.field final synthetic val$app:Landroid/app/Application;


# direct methods
.method public constructor <init>(Landroid/app/Application;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$7;->val$app:Landroid/app/Application;

    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .registers 5

    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    const-string v0, "com.floatingmenu.ACTION_FOREGROUND_CHANGED"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, "ZygiskMenu @Hivirtus"

    if-eqz v0, :cond_3d

    const-string p1, "package_name"

    invoke-virtual {p2, p1}, Landroid/content/Intent;->getStringExtra(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    # setter for: Lcom/floatingmenu/MenuLoader;->sForegroundApp:Ljava/lang/String;
    invoke-static {p1}, Lcom/floatingmenu/MenuLoader;->access$1802(Ljava/lang/String;)Ljava/lang/String;

    # getter for: Lcom/floatingmenu/MenuLoader;->sForegroundApp:Ljava/lang/String;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$1800()Ljava/lang/String;

    move-result-object p1

    if-nez p1, :cond_22

    const-string p1, "none"

    # setter for: Lcom/floatingmenu/MenuLoader;->sForegroundApp:Ljava/lang/String;
    invoke-static {p1}, Lcom/floatingmenu/MenuLoader;->access$1802(Ljava/lang/String;)Ljava/lang/String;

    :cond_22
    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "SystemUI received foreground app change: "

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    # getter for: Lcom/floatingmenu/MenuLoader;->sForegroundApp:Ljava/lang/String;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$1800()Ljava/lang/String;

    move-result-object p2

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    :goto_34
    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$7;->val$app:Landroid/app/Application;

    # invokes: Lcom/floatingmenu/MenuLoader;->triggerSystemUiOverlayCheck(Landroid/app/Application;)V
    invoke-static {p1}, Lcom/floatingmenu/MenuLoader;->access$1900(Landroid/app/Application;)V

    goto :goto_48

    :cond_3d
    const-string p2, "com.floatingmenu.ACTION_LICENSE_STATE_CHANGED"

    invoke-virtual {p2, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_48

    const-string p1, "SystemUI received license state change broadcast"

    goto :goto_34

    :cond_48
    :goto_48
    return-void
.end method
