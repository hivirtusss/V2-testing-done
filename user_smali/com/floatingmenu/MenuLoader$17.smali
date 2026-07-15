.class Lcom/floatingmenu/MenuLoader$17;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/reflect/InvocationHandler;


# instance fields
.field final synthetic val$realPhone:Ljava/lang/Object;


# direct methods
.method public constructor <init>(Ljava/lang/Object;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$17;->val$realPhone:Ljava/lang/Object;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public invoke(Ljava/lang/Object;Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;
    .registers 11

    invoke-virtual {p2}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object p1

    const-string v0, "asBinder"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, "ZygiskMenu @Hivirtus"

    if-eqz v0, :cond_18

    const-string p1, "Intercepted ITelephony asBinder(), returning sITelephonyBinderProxy"

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    # getter for: Lcom/floatingmenu/MenuLoader;->sITelephonyBinderProxy:Landroid/os/IBinder;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$3800()Landroid/os/IBinder;

    move-result-object p1

    return-object p1

    :cond_18
    sget-boolean v0, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    const-string v2, " for slot "

    const-string v3, "Intercepted "

    if-nez v0, :cond_24

    sget-boolean v0, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    if-eqz v0, :cond_f7

    :cond_24
    const-string v0, "hasIccCard"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_43

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ", returning true"

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    sget-object p1, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    return-object p1

    :cond_43
    const-string v0, "getSimState"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1c8

    const-string v0, "getSimStateForSlotIndex"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_55

    goto/16 :goto_1c8

    :cond_55
    const-string v0, "getPhoneCount"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1a4

    const-string v0, "getActiveModemCount"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1a4

    const-string v0, "getSimCount"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_6f

    goto/16 :goto_1a4

    :cond_6f
    const-string v0, "getSimCountryIso"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    const/4 v4, 0x1

    if-nez v0, :cond_c4

    const-string v0, "getNetworkCountryIso"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_81

    goto :goto_c4

    :cond_81
    const-string v0, "getCardStateForSlotIndex"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_f7

    const/4 v0, 0x0

    if-eqz p3, :cond_9b

    array-length v5, p3

    if-lez v5, :cond_9b

    aget-object v5, p3, v0

    instance-of v6, v5, Ljava/lang/Integer;

    if-eqz v6, :cond_9b

    check-cast v5, Ljava/lang/Integer;

    invoke-virtual {v5}, Ljava/lang/Integer;->intValue()I

    move-result v0

    :cond_9b
    if-ne v0, v4, :cond_a0

    sget-boolean v4, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    goto :goto_a2

    :cond_a0
    sget-boolean v4, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    :goto_a2
    if-eqz v4, :cond_f7

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", returning CARD_STATE_PRESENT (2)"

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p1, 0x2

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    return-object p1

    :cond_c4
    :goto_c4
    # invokes: Lcom/floatingmenu/MenuLoader;->getSubIdFromArgs([Ljava/lang/Object;)I
    invoke-static {p3}, Lcom/floatingmenu/MenuLoader;->access$3300([Ljava/lang/Object;)I

    move-result v0

    # invokes: Lcom/floatingmenu/MenuLoader;->getSlotIndexFromSubId(I)I
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$3400(I)I

    move-result v0

    if-ne v0, v4, :cond_d1

    sget-boolean v4, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    goto :goto_d3

    :cond_d1
    sget-boolean v4, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    :goto_d3
    if-eqz v4, :cond_f7

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, ", returning "

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object p1, Lcom/floatingmenu/MenuLoader;->sSimCountry:Ljava/lang/String;

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    sget-object p1, Lcom/floatingmenu/MenuLoader;->sSimCountry:Ljava/lang/String;

    return-object p1

    :cond_f7
    const-string v0, "getSimOperatorName"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    const-string v4, ", returning: "

    if-eqz v0, :cond_131

    # invokes: Lcom/floatingmenu/MenuLoader;->getSubIdFromArgs([Ljava/lang/Object;)I
    invoke-static {p3}, Lcom/floatingmenu/MenuLoader;->access$3300([Ljava/lang/Object;)I

    move-result v0

    # invokes: Lcom/floatingmenu/MenuLoader;->getSlotIndexFromSubId(I)I
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$3400(I)I

    move-result v0

    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimOperatorName(I)Ljava/lang/String;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$3900(I)Ljava/lang/String;

    move-result-object v5

    if-eqz v5, :cond_197

    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-nez v6, :cond_197

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    :goto_11a
    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object v5

    :cond_131
    const-string v0, "getSimOperator"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_153

    # invokes: Lcom/floatingmenu/MenuLoader;->getSubIdFromArgs([Ljava/lang/Object;)I
    invoke-static {p3}, Lcom/floatingmenu/MenuLoader;->access$3300([Ljava/lang/Object;)I

    move-result v0

    # invokes: Lcom/floatingmenu/MenuLoader;->getSlotIndexFromSubId(I)I
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$3400(I)I

    move-result v0

    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimOperator(I)Ljava/lang/String;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$4000(I)Ljava/lang/String;

    move-result-object v5

    if-eqz v5, :cond_197

    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-nez v6, :cond_197

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    goto :goto_11a

    :cond_153
    const-string v0, "getNetworkOperatorName"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_175

    # invokes: Lcom/floatingmenu/MenuLoader;->getSubIdFromArgs([Ljava/lang/Object;)I
    invoke-static {p3}, Lcom/floatingmenu/MenuLoader;->access$3300([Ljava/lang/Object;)I

    move-result v0

    # invokes: Lcom/floatingmenu/MenuLoader;->getSlotIndexFromSubId(I)I
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$3400(I)I

    move-result v0

    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimOperatorName(I)Ljava/lang/String;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$3900(I)Ljava/lang/String;

    move-result-object v5

    if-eqz v5, :cond_197

    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-nez v6, :cond_197

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    goto :goto_11a

    :cond_175
    const-string v0, "getNetworkOperator"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_197

    # invokes: Lcom/floatingmenu/MenuLoader;->getSubIdFromArgs([Ljava/lang/Object;)I
    invoke-static {p3}, Lcom/floatingmenu/MenuLoader;->access$3300([Ljava/lang/Object;)I

    move-result v0

    # invokes: Lcom/floatingmenu/MenuLoader;->getSlotIndexFromSubId(I)I
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$3400(I)I

    move-result v0

    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimOperator(I)Ljava/lang/String;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$4000(I)Ljava/lang/String;

    move-result-object v5

    if-eqz v5, :cond_197

    invoke-virtual {v5}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-nez v6, :cond_197

    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    goto :goto_11a

    :cond_197
    :try_start_197
    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$17;->val$realPhone:Ljava/lang/Object;

    invoke-virtual {p2, p1, p3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1
    :try_end_19d
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_197 .. :try_end_19d} :catch_19e

    return-object p1

    :catch_19e
    move-exception p1

    invoke-virtual {p1}, Ljava/lang/reflect/InvocationTargetException;->getTargetException()Ljava/lang/Throwable;

    move-result-object p1

    throw p1

    :cond_1a4
    :goto_1a4
    sget-boolean p2, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    sget-boolean p3, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    if-eqz p3, :cond_1ac

    add-int/lit8 p2, p2, 0x1

    :cond_1ac
    new-instance p3, Ljava/lang/StringBuilder;

    invoke-direct {p3, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ", returning mock count: "

    invoke-virtual {p3, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p3, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    return-object p1

    :cond_1c8
    :goto_1c8
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ", returning SIM_STATE_READY (5)"

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p1, 0x5

    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    return-object p1
.end method
