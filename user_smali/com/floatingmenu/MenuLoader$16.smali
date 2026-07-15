.class Lcom/floatingmenu/MenuLoader$16;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/reflect/InvocationHandler;


# instance fields
.field final synthetic val$realSub:Ljava/lang/Object;


# direct methods
.method public constructor <init>(Ljava/lang/Object;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$16;->val$realSub:Ljava/lang/Object;

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

    const-string p1, "Intercepted IPhoneSubInfo asBinder(), returning sIPhoneSubInfoBinderProxy"

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    # getter for: Lcom/floatingmenu/MenuLoader;->sIPhoneSubInfoBinderProxy:Landroid/os/IBinder;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$3200()Landroid/os/IBinder;

    move-result-object p1

    return-object p1

    :cond_18
    const-string v0, "getLine1Number"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    const-string v2, " for slot "

    const-string v3, "Intercepted "

    if-eqz v0, :cond_56

    # invokes: Lcom/floatingmenu/MenuLoader;->getSubIdFromArgs([Ljava/lang/Object;)I
    invoke-static {p3}, Lcom/floatingmenu/MenuLoader;->access$3300([Ljava/lang/Object;)I

    move-result v0

    # invokes: Lcom/floatingmenu/MenuLoader;->getSlotIndexFromSubId(I)I
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$3400(I)I

    move-result v0

    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimNumber(I)Ljava/lang/String;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$3500(I)Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_b0

    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v5

    if-nez v5, :cond_b0

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", returning mock number: "

    :goto_48
    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object v4

    :cond_56
    const-string v0, "getSubscriberId"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_83

    # invokes: Lcom/floatingmenu/MenuLoader;->getSubIdFromArgs([Ljava/lang/Object;)I
    invoke-static {p3}, Lcom/floatingmenu/MenuLoader;->access$3300([Ljava/lang/Object;)I

    move-result v0

    # invokes: Lcom/floatingmenu/MenuLoader;->getSlotIndexFromSubId(I)I
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$3400(I)I

    move-result v0

    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimImsi(I)Ljava/lang/String;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$3600(I)Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_b0

    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v5

    if-nez v5, :cond_b0

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", returning mock IMSI: "

    goto :goto_48

    :cond_83
    const-string v0, "getSimSerialNumber"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_b0

    # invokes: Lcom/floatingmenu/MenuLoader;->getSubIdFromArgs([Ljava/lang/Object;)I
    invoke-static {p3}, Lcom/floatingmenu/MenuLoader;->access$3300([Ljava/lang/Object;)I

    move-result v0

    # invokes: Lcom/floatingmenu/MenuLoader;->getSlotIndexFromSubId(I)I
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$3400(I)I

    move-result v0

    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimIccid(I)Ljava/lang/String;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$3700(I)Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_b0

    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v5

    if-nez v5, :cond_b0

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", returning mock ICCID: "

    goto :goto_48

    :cond_b0
    :try_start_b0
    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$16;->val$realSub:Ljava/lang/Object;

    invoke-virtual {p2, p1, p3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1
    :try_end_b6
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_b0 .. :try_end_b6} :catch_b7

    return-object p1

    :catch_b7
    move-exception p1

    invoke-virtual {p1}, Ljava/lang/reflect/InvocationTargetException;->getTargetException()Ljava/lang/Throwable;

    move-result-object p1

    goto :goto_be

    :goto_bd
    throw p1

    :goto_be
    goto :goto_bd
.end method
