.class Lcom/floatingmenu/VercelPoller$6$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/VercelPoller$6;

.field final synthetic val$client:Landroid/net/LocalSocket;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/VercelPoller$6;Landroid/net/LocalSocket;)V
    .registers 3

    iput-object p1, p0, Lcom/floatingmenu/VercelPoller$6$1;->this$0:Lcom/floatingmenu/VercelPoller$6;

    iput-object p2, p0, Lcom/floatingmenu/VercelPoller$6$1;->val$client:Landroid/net/LocalSocket;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 6

    const-string v0, "UTF-8"

    const-string v1, "\n"

    :try_start_4
    iget-object v2, p0, Lcom/floatingmenu/VercelPoller$6$1;->val$client:Landroid/net/LocalSocket;

    const/16 v3, 0xbb8

    invoke-virtual {v2, v3}, Landroid/net/LocalSocket;->setSoTimeout(I)V

    new-instance v2, Ljava/io/BufferedReader;

    new-instance v3, Ljava/io/InputStreamReader;

    iget-object v4, p0, Lcom/floatingmenu/VercelPoller$6$1;->val$client:Landroid/net/LocalSocket;

    invoke-virtual {v4}, Landroid/net/LocalSocket;->getInputStream()Ljava/io/InputStream;

    move-result-object v4

    invoke-direct {v3, v4, v0}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    invoke-direct {v2, v3}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    invoke-virtual {v2}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_3f

    invoke-virtual {v2}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    # invokes: Lcom/floatingmenu/VercelPoller;->handleLocalCommand(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v2}, Lcom/floatingmenu/VercelPoller;->access$900(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :cond_3f

    iget-object v3, p0, Lcom/floatingmenu/VercelPoller$6$1;->val$client:Landroid/net/LocalSocket;

    invoke-virtual {v3}, Landroid/net/LocalSocket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v3

    invoke-virtual {v2, v1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {v3}, Ljava/io/OutputStream;->flush()V
    :try_end_3f
    .catchall {:try_start_4 .. :try_end_3f} :catchall_3f

    :catchall_3f
    :cond_3f
    :try_start_3f
    iget-object v0, p0, Lcom/floatingmenu/VercelPoller$6$1;->val$client:Landroid/net/LocalSocket;

    invoke-virtual {v0}, Landroid/net/LocalSocket;->close()V
    :try_end_44
    .catch Ljava/lang/Exception; {:try_start_3f .. :try_end_44} :catch_44

    :catch_44
    return-void
.end method
