.class public Lcom/floatingmenu/ModuleActionPicker;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field private static sOverlay:Landroid/view/View;

.field private static sWindowManager:Landroid/view/WindowManager;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static dismissOverlay()V
    .registers 3

    sget-object v0, Lcom/floatingmenu/ModuleActionPicker;->sWindowManager:Landroid/view/WindowManager;

    if-eqz v0, :cond_remove

    sget-object v1, Lcom/floatingmenu/ModuleActionPicker;->sOverlay:Landroid/view/View;

    if-eqz v1, :cond_remove

    :try_start_0
    invoke-interface {v0, v1}, Landroid/view/ViewManager;->removeView(Landroid/view/View;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    :catch_0
    const/4 v0, 0x0

    sput-object v0, Lcom/floatingmenu/ModuleActionPicker;->sOverlay:Landroid/view/View;

    sput-object v0, Lcom/floatingmenu/ModuleActionPicker;->sWindowManager:Landroid/view/WindowManager;

    :cond_remove
    return-void
.end method

.method private static getAppContext()Landroid/content/Context;
    .registers 6

    const/4 v0, 0x0

    :try_start_app
    const-string v1, "android.app.ActivityThread"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "systemMain"

    const/4 v3, 0x0

    new-array v4, v3, [Ljava/lang/Class;

    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    const/4 v5, 0x1

    invoke-virtual {v2, v5}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v4, v3, [Ljava/lang/Object;

    invoke-virtual {v2, v0, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-nez v2, :cond_ctx

    const-string v2, "currentActivityThread"

    new-array v4, v3, [Ljava/lang/Class;

    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    invoke-virtual {v2, v5}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v4, v3, [Ljava/lang/Object;

    invoke-virtual {v2, v0, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    :cond_ctx
    if-nez v2, :cond_sys

    return-object v0

    :cond_sys
    const-string v4, "getSystemContext"

    new-array v3, v3, [Ljava/lang/Class;

    invoke-virtual {v1, v4, v3}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    invoke-virtual {v1, v5}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    const/4 v3, 0x0

    new-array v3, v3, [Ljava/lang/Object;

    invoke-virtual {v1, v2, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/content/Context;
    :try_end_app
    .catchall {:try_start_app .. :try_end_app} :catchall

    return-object v1

    :catchall
    return-object v0
.end method

.method public static main([Ljava/lang/String;)V
    .registers 4

    invoke-static {}, Landroid/os/Looper;->prepareMainLooper()V

    invoke-static {}, Lcom/floatingmenu/ModuleActionPicker;->getAppContext()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_ok

    const/4 v0, 0x1

    invoke-static {v0}, Ljava/lang/System;->exit(I)V

    :cond_ok
    new-instance v1, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v2

    invoke-direct {v1, v2}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v2, Lcom/floatingmenu/ModuleActionPicker$ShowPickerRunnable;

    invoke-direct {v2, v0}, Lcom/floatingmenu/ModuleActionPicker$ShowPickerRunnable;-><init>(Landroid/content/Context;)V

    invoke-virtual {v1, v2}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    invoke-static {}, Landroid/os/Looper;->loop()V

    return-void
.end method
