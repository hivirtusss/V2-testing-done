.class Lcom/floatingmenu/VercelPoller$6;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 7

    const-string v0, "ZygiskMenuPoller"

    const/4 v1, 0x0

    :try_start_3
    new-instance v2, Landroid/net/LocalServerSocket;

    const-string v3, "zygisk_menu_socket"

    invoke-direct {v2, v3}, Landroid/net/LocalServerSocket;-><init>(Ljava/lang/String;)V
    :try_end_a
    .catchall {:try_start_3 .. :try_end_a} :catchall_23

    :try_start_a
    const-string v1, "Abstract LocalServerSocket bound successfully."

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :goto_f
    invoke-virtual {v2}, Landroid/net/LocalServerSocket;->accept()Landroid/net/LocalSocket;

    move-result-object v1

    new-instance v3, Ljava/lang/Thread;

    new-instance v4, Lcom/floatingmenu/VercelPoller$6$1;

    invoke-direct {v4, p0, v1}, Lcom/floatingmenu/VercelPoller$6$1;-><init>(Lcom/floatingmenu/VercelPoller$6;Landroid/net/LocalSocket;)V

    invoke-direct {v3, v4}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v3}, Ljava/lang/Thread;->start()V
    :try_end_20
    .catchall {:try_start_a .. :try_end_20} :catchall_21

    goto :goto_f

    :catchall_21
    move-exception v1

    goto :goto_27

    :catchall_23
    move-exception v2

    move-object v5, v2

    move-object v2, v1

    move-object v1, v5

    :goto_27
    :try_start_27
    const-string v3, "Error in LocalServerSocket server loop: "

    invoke-static {v0, v3, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_2c
    .catchall {:try_start_27 .. :try_end_2c} :catchall_32

    if-eqz v2, :cond_31

    :try_start_2e
    invoke-virtual {v2}, Landroid/net/LocalServerSocket;->close()V
    :try_end_31
    .catch Ljava/lang/Exception; {:try_start_2e .. :try_end_31} :catch_31

    :catch_31
    :cond_31
    return-void

    :catchall_32
    move-exception v0

    if-eqz v2, :cond_38

    :try_start_35
    invoke-virtual {v2}, Landroid/net/LocalServerSocket;->close()V
    :try_end_38
    .catch Ljava/lang/Exception; {:try_start_35 .. :try_end_38} :catch_38

    :catch_38
    :cond_38
    goto :goto_3a

    :goto_39
    throw v0

    :goto_3a
    goto :goto_39
.end method
