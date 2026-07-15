.class Lcom/floatingmenu/MenuLoader$2;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/reflect/InvocationHandler;


# instance fields
.field final synthetic val$originalISmsBinder:Landroid/os/IBinder;


# direct methods
.method public constructor <init>(Landroid/os/IBinder;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$2;->val$originalISmsBinder:Landroid/os/IBinder;

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

    if-eqz p1, :cond_37

    const/4 p1, 0x0

    aget-object p1, p3, p1

    check-cast p1, Ljava/lang/String;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "isms queryLocalInterface descriptor: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "ZygiskMenu @Hivirtus"

    invoke-static {v0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :try_start_24
    const-string p1, "com.android.internal.telephony.ISms"

    invoke-static {p1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$2;->val$originalISmsBinder:Landroid/os/IBinder;

    # invokes: Lcom/floatingmenu/MenuLoader;->createISmsProxy(Landroid/os/IBinder;Ljava/lang/Class;)Ljava/lang/Object;
    invoke-static {v1, p1}, Lcom/floatingmenu/MenuLoader;->access$900(Landroid/os/IBinder;Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p1
    :try_end_30
    .catchall {:try_start_24 .. :try_end_30} :catchall_31

    return-object p1

    :catchall_31
    move-exception p1

    const-string v1, "Failed to create ISms proxy, falling back"

    invoke-static {v0, v1, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_37
    :try_start_37
    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$2;->val$originalISmsBinder:Landroid/os/IBinder;

    invoke-virtual {p2, p1, p3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1
    :try_end_3d
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_37 .. :try_end_3d} :catch_3e

    return-object p1

    :catch_3e
    move-exception p1

    invoke-virtual {p1}, Ljava/lang/reflect/InvocationTargetException;->getTargetException()Ljava/lang/Throwable;

    move-result-object p1

    throw p1
.end method
