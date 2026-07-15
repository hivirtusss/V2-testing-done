.class Lcom/floatingmenu/FloatingMenu$4;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic val$body:Ljava/lang/String;

.field final synthetic val$sender:Ljava/lang/String;


# direct methods
.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;)V
    .registers 3

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$4;->val$sender:Ljava/lang/String;

    iput-object p2, p0, Lcom/floatingmenu/FloatingMenu$4;->val$body:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 6

    const/4 v0, 0x0

    :try_start_1
    new-instance v1, Landroid/net/LocalSocket;

    invoke-direct {v1}, Landroid/net/LocalSocket;-><init>()V
    :try_end_6
    .catchall {:try_start_1 .. :try_end_6} :catchall_48

    :try_start_6
    new-instance v0, Landroid/net/LocalSocketAddress;

    const-string v2, "zygisk_menu_socket"

    invoke-direct {v0, v2}, Landroid/net/LocalSocketAddress;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Landroid/net/LocalSocket;->connect(Landroid/net/LocalSocketAddress;)V

    const/16 v0, 0xbb8

    invoke-virtual {v1, v0}, Landroid/net/LocalSocket;->setSoTimeout(I)V

    invoke-virtual {v1}, Landroid/net/LocalSocket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v0

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v3, p0, Lcom/floatingmenu/FloatingMenu$4;->val$sender:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "|"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v3, p0, Lcom/floatingmenu/FloatingMenu$4;->val$body:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, "\n"

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "UTF-8"

    invoke-virtual {v2, v3}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {v0}, Ljava/io/OutputStream;->flush()V
    :try_end_42
    .catchall {:try_start_6 .. :try_end_42} :catchall_46

    :goto_42
    :try_start_42
    invoke-virtual {v1}, Landroid/net/LocalSocket;->close()V
    :try_end_45
    .catch Ljava/lang/Exception; {:try_start_42 .. :try_end_45} :catch_56

    goto :goto_56

    :catchall_46
    move-exception v0

    goto :goto_4c

    :catchall_48
    move-exception v1

    move-object v4, v1

    move-object v1, v0

    move-object v0, v4

    :goto_4c
    :try_start_4c
    const-string v2, "zygisk_floating_menu"

    const-string v3, "Failed to connect to root SMS daemon local socket"

    invoke-static {v2, v3, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I
    :try_end_53
    .catchall {:try_start_4c .. :try_end_53} :catchall_57

    if-eqz v1, :cond_56

    goto :goto_42

    :catch_56
    :cond_56
    :goto_56
    return-void

    :catchall_57
    move-exception v0

    if-eqz v1, :cond_5d

    :try_start_5a
    invoke-virtual {v1}, Landroid/net/LocalSocket;->close()V
    :try_end_5d
    .catch Ljava/lang/Exception; {:try_start_5a .. :try_end_5d} :catch_5d

    :catch_5d
    :cond_5d
    goto :goto_5f

    :goto_5e
    throw v0

    :goto_5f
    goto :goto_5e
.end method
