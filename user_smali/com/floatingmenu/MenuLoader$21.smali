.class Lcom/floatingmenu/MenuLoader$21;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/reflect/InvocationHandler;


# instance fields
.field final synthetic val$originalPmBinder:Landroid/os/IBinder;

.field final synthetic val$pmProxy:Ljava/lang/Object;


# direct methods
.method public constructor <init>(Ljava/lang/Object;Landroid/os/IBinder;)V
    .registers 3

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$21;->val$pmProxy:Ljava/lang/Object;

    iput-object p2, p0, Lcom/floatingmenu/MenuLoader$21;->val$originalPmBinder:Landroid/os/IBinder;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public invoke(Ljava/lang/Object;Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;
    .registers 5

    invoke-virtual {p2}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object p1

    const-string v0, "queryLocalInterface"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1c

    const/4 p1, 0x0

    aget-object p1, p3, p1

    check-cast p1, Ljava/lang/String;

    const-string v0, "android.content.pm.IPackageManager"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1c

    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$21;->val$pmProxy:Ljava/lang/Object;

    return-object p1

    :cond_1c
    :try_start_1c
    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$21;->val$originalPmBinder:Landroid/os/IBinder;

    invoke-virtual {p2, p1, p3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1
    :try_end_22
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_1c .. :try_end_22} :catch_23

    return-object p1

    :catch_23
    move-exception p1

    invoke-virtual {p1}, Ljava/lang/reflect/InvocationTargetException;->getTargetException()Ljava/lang/Throwable;

    move-result-object p1

    throw p1
.end method
