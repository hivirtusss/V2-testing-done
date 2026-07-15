.class Lcom/floatingmenu/MenuLoader$13;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/reflect/InvocationHandler;


# instance fields
.field final synthetic val$originalSubBinder:Landroid/os/IBinder;


# direct methods
.method public constructor <init>(Landroid/os/IBinder;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$13;->val$originalSubBinder:Landroid/os/IBinder;

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

    if-eqz p1, :cond_26

    const/4 p1, 0x0

    aget-object p1, p3, p1

    check-cast p1, Ljava/lang/String;

    :try_start_11
    const-string p1, "com.android.internal.telephony.IPhoneSubInfo"

    invoke-static {p1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$13;->val$originalSubBinder:Landroid/os/IBinder;

    # invokes: Lcom/floatingmenu/MenuLoader;->createIPhoneSubInfoProxy(Landroid/os/IBinder;Ljava/lang/Class;)Ljava/lang/Object;
    invoke-static {v0, p1}, Lcom/floatingmenu/MenuLoader;->access$2900(Landroid/os/IBinder;Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p1
    :try_end_1d
    .catchall {:try_start_11 .. :try_end_1d} :catchall_1e

    return-object p1

    :catchall_1e
    move-exception p1

    const-string v0, "ZygiskMenu @Hivirtus"

    const-string v1, "Failed to create IPhoneSubInfo proxy"

    invoke-static {v0, v1, p1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_26
    :try_start_26
    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$13;->val$originalSubBinder:Landroid/os/IBinder;

    invoke-virtual {p2, p1, p3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1
    :try_end_2c
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_26 .. :try_end_2c} :catch_2d

    return-object p1

    :catch_2d
    move-exception p1

    invoke-virtual {p1}, Ljava/lang/reflect/InvocationTargetException;->getTargetException()Ljava/lang/Throwable;

    move-result-object p1

    throw p1
.end method
