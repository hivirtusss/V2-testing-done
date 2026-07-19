.class Lcom/floatingmenu/MenuLoader$1$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/app/Application$ActivityLifecycleCallbacks;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/MenuLoader$1;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/MenuLoader$1;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$1$1;->this$0:Lcom/floatingmenu/MenuLoader$1;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onActivityCreated(Landroid/app/Activity;Landroid/os/Bundle;)V
    .registers 3

    return-void
.end method

.method public onActivityDestroyed(Landroid/app/Activity;)V
    .registers 4

    # getter for: Lcom/floatingmenu/MenuLoader;->sCurrentActivity:Ljava/lang/ref/WeakReference;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$500()Ljava/lang/ref/WeakReference;

    move-result-object v0

    const/4 v1, 0x0

    if-eqz v0, :cond_14

    # getter for: Lcom/floatingmenu/MenuLoader;->sCurrentActivity:Ljava/lang/ref/WeakReference;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$500()Ljava/lang/ref/WeakReference;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/ref/Reference;->get()Ljava/lang/Object;

    move-result-object v0

    if-ne v0, p1, :cond_14

    # setter for: Lcom/floatingmenu/MenuLoader;->sCurrentActivity:Ljava/lang/ref/WeakReference;
    invoke-static {v1}, Lcom/floatingmenu/MenuLoader;->access$502(Ljava/lang/ref/WeakReference;)Ljava/lang/ref/WeakReference;

    :cond_14
    # getter for: Lcom/floatingmenu/MenuLoader;->sLockOverlay:Landroid/view/View;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$800()Landroid/view/View;

    move-result-object v0

    if-eqz v0, :cond_27

    # getter for: Lcom/floatingmenu/MenuLoader;->sLockOverlay:Landroid/view/View;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$800()Landroid/view/View;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    if-ne v0, p1, :cond_27

    # setter for: Lcom/floatingmenu/MenuLoader;->sLockOverlay:Landroid/view/View;
    invoke-static {v1}, Lcom/floatingmenu/MenuLoader;->access$802(Landroid/view/View;)Landroid/view/View;

    :cond_27
    return-void
.end method

.method public onActivityPaused(Landroid/app/Activity;)V
    .registers 5

    :try_start_0
    new-instance v0, Landroid/content/Intent;

    const-string v1, "com.floatingmenu.ACTION_FOREGROUND_CHANGED"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v1, "package_name"

    const-string v2, "none"

    invoke-virtual {v0, v1, v2}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const/high16 v1, 0x1000000

    invoke-virtual {v0, v1}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    invoke-virtual {p1, v0}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V
    :try_end_16
    .catchall {:try_start_0 .. :try_end_16} :catchall_17

    goto :goto_1f

    :catchall_17
    move-exception p1

    const-string v0, "ZygiskMenu Virtus v3"

    const-string v1, "Failed to send foreground none broadcast: "

    invoke-static {v0, v1, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_1f
    return-void
.end method

.method public onActivityResumed(Landroid/app/Activity;)V
    .registers 6

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    const-string v1, "Activity resumed: "

    invoke-virtual {v1, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    const-string v1, "ZygiskMenu Virtus v3"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    new-instance v0, Ljava/lang/ref/WeakReference;

    invoke-direct {v0, p1}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    # setter for: Lcom/floatingmenu/MenuLoader;->sCurrentActivity:Ljava/lang/ref/WeakReference;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$502(Ljava/lang/ref/WeakReference;)Ljava/lang/ref/WeakReference;

    :try_start_1b
    new-instance v0, Landroid/content/Intent;

    const-string v2, "com.floatingmenu.ACTION_FOREGROUND_CHANGED"

    invoke-direct {v0, v2}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    const-string v2, "package_name"

    invoke-virtual {p1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v2, v3}, Landroid/content/Intent;->putExtra(Ljava/lang/String;Ljava/lang/String;)Landroid/content/Intent;

    const/high16 v2, 0x1000000

    invoke-virtual {v0, v2}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    invoke-virtual {p1, v0}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V
    :try_end_33
    .catchall {:try_start_1b .. :try_end_33} :catchall_34

    goto :goto_3a

    :catchall_34
    move-exception v0

    const-string v2, "Failed to send foreground broadcast: "

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_3a
    const-string v0, "zygisk_menu_prefs"

    const/4 v1, 0x0

    invoke-virtual {p1, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-virtual {p1}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/floatingmenu/TargetPackageGuard;->isBlockedPackage(Ljava/lang/String;)Z

    move-result v2

    if-nez v2, :cond_50

    invoke-static {v1}, Lcom/floatingmenu/TargetPackageGuard;->isPackageSelected(Ljava/lang/String;)Z

    move-result v1

    if-eqz v1, :cond_show_bubble

    goto :goto_50

    :cond_show_bubble
    invoke-static {p1}, Lcom/floatingmenu/FloatingMenu;->show(Landroid/app/Activity;)V

    :cond_50
    :goto_50
    new-instance v1, Ljava/lang/Thread;

    new-instance v2, Lcom/floatingmenu/MenuLoader$1$1$1;

    invoke-direct {v2, p0, v0, p1}, Lcom/floatingmenu/MenuLoader$1$1$1;-><init>(Lcom/floatingmenu/MenuLoader$1$1;Landroid/content/SharedPreferences;Landroid/app/Activity;)V

    invoke-direct {v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v1}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method public onActivitySaveInstanceState(Landroid/app/Activity;Landroid/os/Bundle;)V
    .registers 3

    return-void
.end method

.method public onActivityStarted(Landroid/app/Activity;)V
    .registers 2

    return-void
.end method

.method public onActivityStopped(Landroid/app/Activity;)V
    .registers 2

    return-void
.end method
