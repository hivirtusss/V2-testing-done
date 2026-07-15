.class Lcom/floatingmenu/MenuLoader$4;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/reflect/InvocationHandler;


# instance fields
.field final synthetic val$originalAmBinder:Landroid/os/IBinder;


# direct methods
.method public constructor <init>(Landroid/os/IBinder;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$4;->val$originalAmBinder:Landroid/os/IBinder;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public invoke(Ljava/lang/Object;Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;
    .registers 6

    invoke-virtual {p2}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object p1

    const-string v0, "queryLocalInterface"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_28

    const/4 p1, 0x0

    aget-object p1, p3, p1

    check-cast p1, Ljava/lang/String;

    const-string v0, "android.app.IActivityManager"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_28

    :try_start_19
    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$4;->val$originalAmBinder:Landroid/os/IBinder;

    # invokes: Lcom/floatingmenu/MenuLoader;->createIActivityManagerProxy(Landroid/os/IBinder;)Ljava/lang/Object;
    invoke-static {p1}, Lcom/floatingmenu/MenuLoader;->access$1400(Landroid/os/IBinder;)Ljava/lang/Object;

    move-result-object p1
    :try_end_1f
    .catchall {:try_start_19 .. :try_end_1f} :catchall_20

    return-object p1

    :catchall_20
    move-exception p1

    const-string v0, "ZygiskMenu @Hivirtus"

    const-string v1, "Failed to create IActivityManager proxy, falling back"

    invoke-static {v0, v1, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_28
    :try_start_28
    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$4;->val$originalAmBinder:Landroid/os/IBinder;

    invoke-virtual {p2, p1, p3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1
    :try_end_2e
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_28 .. :try_end_2e} :catch_2f

    return-object p1

    :catch_2f
    move-exception p1

    invoke-virtual {p1}, Ljava/lang/reflect/InvocationTargetException;->getTargetException()Ljava/lang/Throwable;

    move-result-object p1

    throw p1
.end method
