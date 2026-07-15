.class Lcom/floatingmenu/MenuLoader$18;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/reflect/InvocationHandler;


# instance fields
.field final synthetic val$realSub:Ljava/lang/Object;


# direct methods
.method public constructor <init>(Ljava/lang/Object;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$18;->val$realSub:Ljava/lang/Object;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public invoke(Ljava/lang/Object;Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;
    .registers 21

    move-object/from16 v0, p3

    invoke-virtual/range {p2 .. p2}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v1

    const-string v2, "asBinder"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    const-string v3, "ZygiskMenu @Hivirtus"

    if-eqz v2, :cond_1a

    const-string v0, "Intercepted ISub asBinder(), returning sISubBinderProxy"

    invoke-static {v3, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    # getter for: Lcom/floatingmenu/MenuLoader;->sISubBinderProxy:Landroid/os/IBinder;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$4100()Landroid/os/IBinder;

    move-result-object v0

    return-object v0

    :cond_1a
    sget-boolean v2, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    if-nez v2, :cond_27

    sget-boolean v2, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    if-eqz v2, :cond_23

    goto :goto_27

    :cond_23
    move-object/from16 v2, p0

    goto/16 :goto_1b6

    :cond_27
    :goto_27
    const-string v2, "getActiveSubscriptionInfoList"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    const-string v4, "840"

    const-string v5, "405"

    const-string v6, "Intercepted "

    const/4 v7, 0x3

    const/4 v8, 0x1

    const/4 v9, 0x0

    if-nez v2, :cond_40

    const-string v2, "getAllSubscriptionInfoList"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_44

    :cond_40
    move-object/from16 v2, p0

    goto/16 :goto_1c5

    :cond_44
    const-string v2, "getActiveSubscriptionInfo"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_a8

    # invokes: Lcom/floatingmenu/MenuLoader;->getSubIdFromArgs([Ljava/lang/Object;)I
    invoke-static/range {p3 .. p3}, Lcom/floatingmenu/MenuLoader;->access$3300([Ljava/lang/Object;)I

    move-result v2

    # invokes: Lcom/floatingmenu/MenuLoader;->getSlotIndexFromSubId(I)I
    invoke-static {v2}, Lcom/floatingmenu/MenuLoader;->access$3400(I)I

    move-result v15

    if-ne v15, v8, :cond_59

    sget-boolean v10, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    goto :goto_5b

    :cond_59
    sget-boolean v10, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    :goto_5b
    if-eqz v10, :cond_23

    if-ne v15, v8, :cond_63

    sget-object v0, Lcom/floatingmenu/MenuLoader;->sSim2Number:Ljava/lang/String;

    :goto_61
    move-object v12, v0

    goto :goto_66

    :cond_63
    sget-object v0, Lcom/floatingmenu/MenuLoader;->sSim1Number:Ljava/lang/String;

    goto :goto_61

    :goto_66
    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimOperator(I)Ljava/lang/String;
    invoke-static {v15}, Lcom/floatingmenu/MenuLoader;->access$4000(I)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_70

    invoke-virtual {v0, v9, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    :cond_70
    move-object v14, v5

    if-eqz v0, :cond_77

    invoke-virtual {v0, v7}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v4

    :cond_77
    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimOperatorName(I)Ljava/lang/String;
    invoke-static {v15}, Lcom/floatingmenu/MenuLoader;->access$3900(I)Ljava/lang/String;

    move-result-object v13

    move v10, v2

    move v11, v15

    move v0, v15

    move-object v15, v4

    # invokes: Lcom/floatingmenu/MenuLoader;->createMockSubscriptionInfo(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;
    invoke-static/range {v10 .. v15}, Lcom/floatingmenu/MenuLoader;->access$4200(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v4

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " for subId "

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ", slot "

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, ", returning mock info"

    invoke-virtual {v5, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object v4

    :cond_a8
    const-string v2, "getActiveSubscriptionInfoForSimSlotIndex"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_136

    if-eqz v0, :cond_c2

    array-length v2, v0

    if-lez v2, :cond_c2

    aget-object v2, v0, v9

    instance-of v10, v2, Ljava/lang/Integer;

    if-eqz v10, :cond_c2

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v2

    goto :goto_c3

    :cond_c2
    const/4 v2, -0x1

    :goto_c3
    if-nez v2, :cond_fd

    sget-boolean v10, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    if-eqz v10, :cond_fd

    sget-object v13, Lcom/floatingmenu/MenuLoader;->sSim1Number:Ljava/lang/String;

    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimOperator(I)Ljava/lang/String;
    invoke-static {v9}, Lcom/floatingmenu/MenuLoader;->access$4000(I)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_d5

    invoke-virtual {v0, v9, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    :cond_d5
    move-object v15, v5

    if-eqz v0, :cond_dc

    invoke-virtual {v0, v7}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v4

    :cond_dc
    move-object/from16 v16, v4

    const/4 v11, 0x1

    const/4 v12, 0x0

    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimOperatorName(I)Ljava/lang/String;
    invoke-static {v9}, Lcom/floatingmenu/MenuLoader;->access$3900(I)Ljava/lang/String;

    move-result-object v14

    # invokes: Lcom/floatingmenu/MenuLoader;->createMockSubscriptionInfo(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;
    invoke-static/range {v11 .. v16}, Lcom/floatingmenu/MenuLoader;->access$4200(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " for slot 0, returning mock info"

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v3, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object v0

    :cond_fd
    if-ne v2, v8, :cond_23

    sget-boolean v2, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    if-eqz v2, :cond_23

    sget-object v12, Lcom/floatingmenu/MenuLoader;->sSim2Number:Ljava/lang/String;

    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimOperator(I)Ljava/lang/String;
    invoke-static {v8}, Lcom/floatingmenu/MenuLoader;->access$4000(I)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_10f

    invoke-virtual {v0, v9, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    :cond_10f
    move-object v14, v5

    if-eqz v0, :cond_116

    invoke-virtual {v0, v7}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v4

    :cond_116
    move-object v15, v4

    const/4 v10, 0x2

    const/4 v11, 0x1

    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimOperatorName(I)Ljava/lang/String;
    invoke-static {v8}, Lcom/floatingmenu/MenuLoader;->access$3900(I)Ljava/lang/String;

    move-result-object v13

    # invokes: Lcom/floatingmenu/MenuLoader;->createMockSubscriptionInfo(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;
    invoke-static/range {v10 .. v15}, Lcom/floatingmenu/MenuLoader;->access$4200(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " for slot 1, returning mock info"

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v3, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object v0

    :cond_136
    const-string v2, "getActiveSubscriptionInfoCount"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_162

    sget-boolean v0, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    sget-boolean v2, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    if-eqz v2, :cond_146

    add-int/lit8 v0, v0, 0x1

    :cond_146
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", returning mock count: "

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v3, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    return-object v0

    :cond_162
    const-string v2, "getActiveSubIdList"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_23

    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    sget-boolean v2, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    if-eqz v2, :cond_17a

    invoke-static {v8}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_17a
    sget-boolean v2, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    if-eqz v2, :cond_186

    const/4 v2, 0x2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_186
    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v2

    new-array v2, v2, [I

    :goto_18c
    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v4

    if-ge v9, v4, :cond_1a1

    invoke-virtual {v0, v9}, Ljava/util/ArrayList;->get(I)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/lang/Integer;

    invoke-virtual {v4}, Ljava/lang/Integer;->intValue()I

    move-result v4

    aput v4, v2, v9

    add-int/lit8 v9, v9, 0x1

    goto :goto_18c

    :cond_1a1
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", returning mock array"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v3, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object v2

    :goto_1b6
    :try_start_1b6
    iget-object v1, v2, Lcom/floatingmenu/MenuLoader$18;->val$realSub:Ljava/lang/Object;

    move-object/from16 v3, p2

    invoke-virtual {v3, v1, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0
    :try_end_1be
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_1b6 .. :try_end_1be} :catch_1bf

    return-object v0

    :catch_1bf
    move-exception v0

    invoke-virtual {v0}, Ljava/lang/reflect/InvocationTargetException;->getTargetException()Ljava/lang/Throwable;

    move-result-object v0

    throw v0

    :goto_1c5
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    sget-boolean v10, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    if-eqz v10, :cond_1f7

    sget-object v13, Lcom/floatingmenu/MenuLoader;->sSim1Number:Ljava/lang/String;

    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimOperator(I)Ljava/lang/String;
    invoke-static {v9}, Lcom/floatingmenu/MenuLoader;->access$4000(I)Ljava/lang/String;

    move-result-object v10

    if-eqz v10, :cond_1dc

    invoke-virtual {v10, v9, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v11

    move-object v15, v11

    goto :goto_1dd

    :cond_1dc
    move-object v15, v5

    :goto_1dd
    if-eqz v10, :cond_1e6

    invoke-virtual {v10, v7}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v10

    move-object/from16 v16, v10

    goto :goto_1e8

    :cond_1e6
    move-object/from16 v16, v4

    :goto_1e8
    const/4 v11, 0x1

    const/4 v12, 0x0

    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimOperatorName(I)Ljava/lang/String;
    invoke-static {v9}, Lcom/floatingmenu/MenuLoader;->access$3900(I)Ljava/lang/String;

    move-result-object v14

    # invokes: Lcom/floatingmenu/MenuLoader;->createMockSubscriptionInfo(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;
    invoke-static/range {v11 .. v16}, Lcom/floatingmenu/MenuLoader;->access$4200(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v10

    if-eqz v10, :cond_1f7

    invoke-virtual {v0, v10}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_1f7
    sget-boolean v10, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    if-eqz v10, :cond_21f

    sget-object v13, Lcom/floatingmenu/MenuLoader;->sSim2Number:Ljava/lang/String;

    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimOperator(I)Ljava/lang/String;
    invoke-static {v8}, Lcom/floatingmenu/MenuLoader;->access$4000(I)Ljava/lang/String;

    move-result-object v10

    if-eqz v10, :cond_207

    invoke-virtual {v10, v9, v7}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v5

    :cond_207
    move-object v15, v5

    if-eqz v10, :cond_20e

    invoke-virtual {v10, v7}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v4

    :cond_20e
    move-object/from16 v16, v4

    const/4 v11, 0x2

    const/4 v12, 0x1

    # invokes: Lcom/floatingmenu/MenuLoader;->getMockSimOperatorName(I)Ljava/lang/String;
    invoke-static {v8}, Lcom/floatingmenu/MenuLoader;->access$3900(I)Ljava/lang/String;

    move-result-object v14

    # invokes: Lcom/floatingmenu/MenuLoader;->createMockSubscriptionInfo(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;
    invoke-static/range {v11 .. v16}, Lcom/floatingmenu/MenuLoader;->access$4200(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v4

    if-eqz v4, :cond_21f

    invoke-virtual {v0, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    :cond_21f
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", returning mock list with "

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/util/ArrayList;->size()I

    move-result v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " items"

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v3, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object v0
.end method
