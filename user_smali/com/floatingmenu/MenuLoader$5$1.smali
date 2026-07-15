.class Lcom/floatingmenu/MenuLoader$5$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/reflect/InvocationHandler;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/MenuLoader$5;

.field final synthetic val$realProvider:Ljava/lang/Object;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/MenuLoader$5;Ljava/lang/Object;)V
    .registers 3

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$5$1;->this$0:Lcom/floatingmenu/MenuLoader$5;

    iput-object p2, p0, Lcom/floatingmenu/MenuLoader$5$1;->val$realProvider:Ljava/lang/Object;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public invoke(Ljava/lang/Object;Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;
    .registers 21

    move-object/from16 v0, p3

    invoke-virtual/range {p2 .. p2}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v1

    sget-boolean v2, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    const-string v3, "0"

    const-string v4, "value"

    const-string v5, "ZygiskMenu @Hivirtus"

    const-string v6, "oem_unlock_disallowed"

    const-string v7, "oem_unlock_supported"

    const-string v8, "adb_enabled"

    const-string v9, "development_settings_enabled"

    if-eqz v2, :cond_6a

    if-eqz v1, :cond_6a

    const-string v2, "call"

    invoke-virtual {v1, v2}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v2

    if-eqz v2, :cond_6a

    if-eqz v0, :cond_6a

    array-length v2, v0

    const/4 v11, 0x0

    :goto_26
    if-ge v11, v2, :cond_6a

    aget-object v12, v0, v11

    instance-of v13, v12, Ljava/lang/String;

    if-eqz v13, :cond_67

    check-cast v12, Ljava/lang/String;

    invoke-virtual {v9, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-nez v13, :cond_48

    invoke-virtual {v8, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-nez v13, :cond_48

    invoke-virtual {v7, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-nez v13, :cond_48

    invoke-virtual {v6, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v13

    if-eqz v13, :cond_67

    :cond_48
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "IContentProvider: Intercepted Settings call for key: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", returning 0"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v5, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    new-instance v0, Landroid/os/Bundle;

    invoke-direct {v0}, Landroid/os/Bundle;-><init>()V

    invoke-virtual {v0, v4, v3}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V

    return-object v0

    :cond_67
    add-int/lit8 v11, v11, 0x1

    goto :goto_26

    :cond_6a
    const-string v2, "query"

    invoke-virtual {v2, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-eqz v1, :cond_1de

    if-eqz v0, :cond_84

    array-length v2, v0

    const/4 v11, 0x0

    :goto_76
    if-ge v11, v2, :cond_84

    aget-object v12, v0, v11

    instance-of v13, v12, Landroid/net/Uri;

    if-eqz v13, :cond_81

    check-cast v12, Landroid/net/Uri;

    goto :goto_85

    :cond_81
    add-int/lit8 v11, v11, 0x1

    goto :goto_76

    :cond_84
    const/4 v12, 0x0

    :goto_85
    sget-boolean v2, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    if-eqz v2, :cond_167

    if-eqz v12, :cond_167

    invoke-virtual {v12}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v11, "settings"

    invoke-virtual {v2, v11}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_167

    invoke-virtual {v12}, Landroid/net/Uri;->getLastPathSegment()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v9, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-nez v11, :cond_b5

    invoke-virtual {v8, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-nez v11, :cond_b5

    invoke-virtual {v7, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-nez v11, :cond_b5

    invoke-virtual {v6, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v11

    if-eqz v11, :cond_b4

    goto :goto_b5

    :cond_b4
    const/4 v2, 0x0

    :cond_b5
    :goto_b5
    if-nez v2, :cond_129

    if-eqz v0, :cond_129

    array-length v11, v0

    const/4 v13, 0x0

    :goto_bb
    if-ge v13, v11, :cond_129

    aget-object v14, v0, v13

    instance-of v15, v14, [Ljava/lang/String;

    if-eqz v15, :cond_e9

    check-cast v14, [Ljava/lang/String;

    array-length v15, v14

    const/4 v1, 0x0

    :goto_c7
    if-ge v1, v15, :cond_126

    aget-object v10, v14, v1

    invoke-virtual {v9, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v16

    if-nez v16, :cond_e7

    invoke-virtual {v8, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v16

    if-nez v16, :cond_e7

    invoke-virtual {v7, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v16

    if-nez v16, :cond_e7

    invoke-virtual {v6, v10}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v16

    if-eqz v16, :cond_e4

    goto :goto_e7

    :cond_e4
    add-int/lit8 v1, v1, 0x1

    goto :goto_c7

    :cond_e7
    :goto_e7
    move-object v2, v10

    goto :goto_126

    :cond_e9
    instance-of v1, v14, Ljava/lang/String;

    if-eqz v1, :cond_126

    check-cast v14, Ljava/lang/String;

    invoke-virtual {v14, v9}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_107

    invoke-virtual {v14, v8}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_107

    invoke-virtual {v14, v7}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :cond_107

    invoke-virtual {v14, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_126

    :cond_107
    invoke-virtual {v14, v9}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_10f

    move-object v6, v9

    goto :goto_12a

    :cond_10f
    invoke-virtual {v14, v8}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_117

    move-object v6, v8

    goto :goto_12a

    :cond_117
    invoke-virtual {v14, v7}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_11f

    move-object v6, v7

    goto :goto_12a

    :cond_11f
    invoke-virtual {v14, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_129

    goto :goto_12a

    :cond_126
    :goto_126
    add-int/lit8 v13, v13, 0x1

    goto :goto_bb

    :cond_129
    move-object v6, v2

    :goto_12a
    if-eqz v6, :cond_167

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "IContentProvider: Intercepted Settings query for key: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", returning MatrixCursor with 0"

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v5, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    new-instance v0, Landroid/database/MatrixCursor;

    const/4 v1, 0x3

    new-array v2, v1, [Ljava/lang/String;

    const-string v5, "_id"

    const/4 v7, 0x0

    aput-object v5, v2, v7

    const-string v5, "name"

    const/4 v8, 0x1

    aput-object v5, v2, v8

    const/4 v5, 0x2

    aput-object v4, v2, v5

    invoke-direct {v0, v2}, Landroid/database/MatrixCursor;-><init>([Ljava/lang/String;)V

    new-array v1, v1, [Ljava/lang/Object;

    invoke-static {v8}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v1, v7

    aput-object v6, v1, v8

    aput-object v3, v1, v5

    invoke-virtual {v0, v1}, Landroid/database/MatrixCursor;->addRow([Ljava/lang/Object;)V

    return-object v0

    :cond_167
    const/4 v7, 0x0

    sget-boolean v1, Lcom/floatingmenu/FloatingMenu;->sHookOutgoing:Z

    if-eqz v1, :cond_1a4

    if-eqz v12, :cond_1a4

    invoke-virtual {v12}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "sms"

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_1a4

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "IContentProvider: Intercepted sent SMS database query: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v5, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz v0, :cond_19e

    array-length v1, v0

    const/4 v10, 0x0

    :goto_18f
    if-ge v10, v1, :cond_19e

    aget-object v2, v0, v10

    instance-of v3, v2, [Ljava/lang/String;

    if-eqz v3, :cond_19b

    move-object v1, v2

    check-cast v1, [Ljava/lang/String;

    goto :goto_19f

    :cond_19b
    add-int/lit8 v10, v10, 0x1

    goto :goto_18f

    :cond_19e
    const/4 v1, 0x0

    :goto_19f
    # invokes: Lcom/floatingmenu/MenuLoader;->createMockSmsCursor([Ljava/lang/String;)Landroid/database/Cursor;
    invoke-static {v1}, Lcom/floatingmenu/MenuLoader;->access$1600([Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v0

    return-object v0

    :cond_1a4
    if-eqz v12, :cond_1de

    invoke-virtual {v12}, Landroid/net/Uri;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "telephony/siminfo"

    invoke-virtual {v1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-eqz v1, :cond_1de

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "IContentProvider: Intercepted telephony/siminfo query: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v5, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz v0, :cond_1d6

    array-length v1, v0

    const/4 v10, 0x0

    :goto_1c7
    if-ge v10, v1, :cond_1d6

    aget-object v2, v0, v10

    instance-of v3, v2, [Ljava/lang/String;

    if-eqz v3, :cond_1d3

    move-object v1, v2

    check-cast v1, [Ljava/lang/String;

    goto :goto_1d7

    :cond_1d3
    add-int/lit8 v10, v10, 0x1

    goto :goto_1c7

    :cond_1d6
    const/4 v1, 0x0

    :goto_1d7
    # invokes: Lcom/floatingmenu/MenuLoader;->createMockSimCursor([Ljava/lang/String;)Landroid/database/Cursor;
    invoke-static {v1}, Lcom/floatingmenu/MenuLoader;->access$1700([Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object v1

    if-eqz v1, :cond_1de

    return-object v1

    :cond_1de
    move-object/from16 v1, p0

    :try_start_1e0
    iget-object v2, v1, Lcom/floatingmenu/MenuLoader$5$1;->val$realProvider:Ljava/lang/Object;

    move-object/from16 v3, p2

    invoke-virtual {v3, v2, v0}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0
    :try_end_1e8
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_1e0 .. :try_end_1e8} :catch_1e9

    return-object v0

    :catch_1e9
    move-exception v0

    invoke-virtual {v0}, Ljava/lang/reflect/InvocationTargetException;->getTargetException()Ljava/lang/Throwable;

    move-result-object v0

    goto :goto_1f0

    :goto_1ef
    throw v0

    :goto_1f0
    goto :goto_1ef
.end method
