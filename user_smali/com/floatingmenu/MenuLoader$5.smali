.class Lcom/floatingmenu/MenuLoader$5;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/reflect/InvocationHandler;


# instance fields
.field final synthetic val$finalRealAm:Ljava/lang/Object;


# direct methods
.method public constructor <init>(Ljava/lang/Object;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$5;->val$finalRealAm:Ljava/lang/Object;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public invoke(Ljava/lang/Object;Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;
    .registers 10

    invoke-virtual {p2}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object p1

    const-string v0, "asBinder"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, "ZygiskMenu @Hivirtus"

    if-eqz v0, :cond_18

    const-string p1, "Intercepted IActivityManager asBinder(), returning sIActivityManagerBinderProxy"

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    # getter for: Lcom/floatingmenu/MenuLoader;->sIActivityManagerBinderProxy:Landroid/os/IBinder;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$1500()Landroid/os/IBinder;

    move-result-object p1

    return-object p1

    :cond_18
    const-string v0, "getContentProvider"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_73

    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$5;->val$finalRealAm:Ljava/lang/Object;

    invoke-virtual {p2, p1, p3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    if-eqz p1, :cond_72

    sget-boolean p2, Lcom/floatingmenu/FloatingMenu;->sHookOutgoing:Z

    if-nez p2, :cond_30

    sget-boolean p2, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    if-eqz p2, :cond_72

    :cond_30
    :try_start_30
    const-string p2, "android.app.ContentProviderHolder"

    invoke-static {p2}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p2

    const-string p3, "provider"

    invoke-virtual {p2, p3}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object p2

    const/4 p3, 0x1

    invoke-virtual {p2, p3}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    invoke-virtual {p2, p1}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-eqz v0, :cond_72

    const-string v2, "android.content.IContentProvider"

    invoke-static {v2}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v2

    invoke-virtual {v2}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v3

    const/4 v4, 0x2

    new-array v4, v4, [Ljava/lang/Class;

    const/4 v5, 0x0

    aput-object v2, v4, v5

    const-class v2, Landroid/os/IInterface;

    aput-object v2, v4, p3

    new-instance p3, Lcom/floatingmenu/MenuLoader$5$1;

    invoke-direct {p3, p0, v0}, Lcom/floatingmenu/MenuLoader$5$1;-><init>(Lcom/floatingmenu/MenuLoader$5;Ljava/lang/Object;)V

    invoke-static {v3, v4, p3}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object p3

    invoke-virtual {p2, p1, p3}, Ljava/lang/reflect/Field;->set(Ljava/lang/Object;Ljava/lang/Object;)V

    const-string p2, "Successfully wrapped IContentProvider inside ContentProviderHolder."

    invoke-static {v1, p2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_6b
    .catchall {:try_start_30 .. :try_end_6b} :catchall_6c

    goto :goto_72

    :catchall_6c
    move-exception p2

    const-string p3, "Error proxying IContentProvider client: "

    invoke-static {v1, p3, p2}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_72
    :goto_72
    return-object p1

    :cond_73
    :try_start_73
    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$5;->val$finalRealAm:Ljava/lang/Object;

    invoke-virtual {p2, p1, p3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1
    :try_end_79
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_73 .. :try_end_79} :catch_7a

    return-object p1

    :catch_7a
    move-exception p1

    invoke-virtual {p1}, Ljava/lang/reflect/InvocationTargetException;->getTargetException()Ljava/lang/Throwable;

    move-result-object p1

    throw p1
.end method
