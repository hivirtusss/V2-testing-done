.class Lcom/floatingmenu/VercelPoller$2;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic val$key:Ljava/lang/String;

.field final synthetic val$pkgName:Ljava/lang/String;

.field final synthetic val$prefsFile:Ljava/io/File;


# direct methods
.method public constructor <init>(Ljava/lang/String;Ljava/io/File;Ljava/lang/String;)V
    .registers 4

    iput-object p1, p0, Lcom/floatingmenu/VercelPoller$2;->val$key:Ljava/lang/String;

    iput-object p2, p0, Lcom/floatingmenu/VercelPoller$2;->val$prefsFile:Ljava/io/File;

    iput-object p3, p0, Lcom/floatingmenu/VercelPoller$2;->val$pkgName:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 17

    move-object/from16 v1, p0

    const-string v2, "socket"

    const-string v0, "device_mismatch"

    const-string v3, "expired"

    const-string v4, "blocked"

    const-string v5, "ZygiskMenuPoller"

    const-string v6, "verifyActiveKeyStatus - key is no longer active! Status updated to: "

    const-string v7, "Key for "

    const-string v8, "SET_LICENSE_STATUS|"

    const-string v9, "verifyActiveKeyStatus - decrypted response: "

    const-string v10, "{\"licenseKey\":\""

    const-string v11, "device_"

    const-string v12, "Starting verifyActiveKeyStatus check. Key: "

    const-string v13, "Silent check running for key: "

    :try_start_1c
    new-instance v14, Ljava/lang/StringBuilder;

    invoke-direct {v14, v13}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v13, v1, Lcom/floatingmenu/VercelPoller$2;->val$key:Ljava/lang/String;

    invoke-virtual {v14, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v14}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v13

    invoke-static {v5, v13}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    new-instance v13, Ljava/lang/StringBuilder;

    invoke-direct {v13, v12}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v12, v1, Lcom/floatingmenu/VercelPoller$2;->val$key:Ljava/lang/String;

    invoke-virtual {v13, v12}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v12

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v12}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V

    iget-object v12, v1, Lcom/floatingmenu/VercelPoller$2;->val$key:Ljava/lang/String;

    const-string v13, "admin"

    invoke-virtual {v12, v13}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v12
    :try_end_46
    .catchall {:try_start_1c .. :try_end_46} :catchall_56

    const-string v13, "SET_LICENSE_STATUS|active"

    if-eqz v12, :cond_5a

    :try_start_4a
    # invokes: Lcom/floatingmenu/VercelPoller;->querySocket(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v13}, Lcom/floatingmenu/VercelPoller;->access$200(Ljava/lang/String;)Ljava/lang/String;

    # invokes: Lcom/floatingmenu/VercelPoller;->sendStateChangedBroadcast()V
    invoke-static {}, Lcom/floatingmenu/VercelPoller;->access$300()V

    const-string v0, "verifyActiveKeyStatus - developer key admin bypass."

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v0}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V

    return-void

    :catchall_56
    move-exception v0

    move-object v11, v5

    goto/16 :goto_154

    :cond_5a
    new-instance v12, Ljava/io/File;

    const-string v14, "/data/adb/modules/zygisk_floating_menu/device_id"

    invoke-direct {v12, v14}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    const-string v14, ""

    invoke-virtual {v12}, Ljava/io/File;->exists()Z

    move-result v15

    if-eqz v15, :cond_73

    # invokes: Lcom/floatingmenu/VercelPoller;->readFileToString(Ljava/io/File;)Ljava/lang/String;
    invoke-static {v12}, Lcom/floatingmenu/VercelPoller;->access$400(Ljava/io/File;)Ljava/lang/String;

    move-result-object v14

    if-eqz v14, :cond_73

    invoke-virtual {v14}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v14

    :cond_73
    if-eqz v14, :cond_7f

    invoke-virtual {v14}, Ljava/lang/String;->isEmpty()Z

    move-result v15

    if-eqz v15, :cond_7c

    goto :goto_7f

    :cond_7c
    move-object v11, v5

    move-object v15, v6

    goto :goto_9c

    :cond_7f
    :goto_7f
    new-instance v14, Ljava/lang/StringBuilder;

    invoke-direct {v14, v11}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V
    :try_end_84
    .catchall {:try_start_4a .. :try_end_84} :catchall_56

    move-object v11, v5

    move-object v15, v6

    :try_start_86
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v5

    invoke-virtual {v14, v5, v6}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v14}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v14
    :try_end_91
    .catchall {:try_start_86 .. :try_end_91} :catchall_fa

    :try_start_91
    new-instance v5, Ljava/io/FileWriter;

    invoke-direct {v5, v12}, Ljava/io/FileWriter;-><init>(Ljava/io/File;)V

    invoke-virtual {v5, v14}, Ljava/io/Writer;->write(Ljava/lang/String;)V

    invoke-virtual {v5}, Ljava/io/Writer;->close()V
    :try_end_9c
    .catchall {:try_start_91 .. :try_end_9c} :catchall_9c

    :catchall_9c
    :goto_9c
    :try_start_9c
    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v6, v1, Lcom/floatingmenu/VercelPoller$2;->val$key:Ljava/lang/String;

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, "\",\"deviceId\":\""

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v6, "\",\"timestamp\":"

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-object v6, v15

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v14

    invoke-virtual {v5, v14, v15}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v10, "}"

    invoke-virtual {v5, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lcom/floatingmenu/CryptoHelper;->encrypt(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    const-string v10, "verifyActiveKeyStatus - sending POST request to verify-license..."

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v10}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V

    const-string v10, "https://vercellicenseapi.vercel.app/api/verify-license"

    # invokes: Lcom/floatingmenu/VercelPoller;->makePostRequest(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v10, v5}, Lcom/floatingmenu/VercelPoller;->access$500(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lcom/floatingmenu/CryptoHelper;->decrypt(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    new-instance v10, Ljava/lang/StringBuilder;

    invoke-direct {v10, v9}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v10, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v10}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v9}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V

    const-string v9, "\"status\":\"active\""

    invoke-virtual {v5, v9}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v9

    if-eqz v9, :cond_fc

    # invokes: Lcom/floatingmenu/VercelPoller;->querySocket(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v13}, Lcom/floatingmenu/VercelPoller;->access$200(Ljava/lang/String;)Ljava/lang/String;

    # invokes: Lcom/floatingmenu/VercelPoller;->sendStateChangedBroadcast()V
    invoke-static {}, Lcom/floatingmenu/VercelPoller;->access$300()V

    const-string v0, "verifyActiveKeyStatus - key remains active."

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v0}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V

    return-void

    :catchall_fa
    move-exception v0

    goto :goto_154

    :cond_fc
    const-string v9, "invalid"

    invoke-virtual {v5, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v10

    if-eqz v10, :cond_106

    move-object v0, v4

    goto :goto_11a

    :cond_106
    # invokes: Lcom/floatingmenu/VercelPoller;->querySocket(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v13}, Lcom/floatingmenu/VercelPoller;->access$200(Ljava/lang/String;)Ljava/lang/String;

    # invokes: Lcom/floatingmenu/VercelPoller;->sendStateChangedBroadcast()V
    invoke-static {}, Lcom/floatingmenu/VercelPoller;->access$300()V

    const-string v0, "verifyActiveKeyStatus - key remains active."

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v0}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V

    return-void

    invoke-virtual {v5, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3

    if-eqz v3, :cond_119

    goto :goto_11a

    :cond_119
    move-object v0, v9

    :goto_11a
    iget-object v3, v1, Lcom/floatingmenu/VercelPoller$2;->val$prefsFile:Ljava/io/File;

    if-eqz v3, :cond_124

    iget-object v4, v1, Lcom/floatingmenu/VercelPoller$2;->val$key:Ljava/lang/String;

    const/4 v5, 0x0

    # invokes: Lcom/floatingmenu/VercelPoller;->writeValidationResponseToPrefs(Ljava/io/File;ZLjava/lang/String;Ljava/lang/String;)V
    invoke-static {v3, v5, v0, v4}, Lcom/floatingmenu/VercelPoller;->access$100(Ljava/io/File;ZLjava/lang/String;Ljava/lang/String;)V

    :cond_124
    invoke-virtual {v8, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    # invokes: Lcom/floatingmenu/VercelPoller;->querySocket(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v3}, Lcom/floatingmenu/VercelPoller;->access$200(Ljava/lang/String;)Ljava/lang/String;

    # invokes: Lcom/floatingmenu/VercelPoller;->sendStateChangedBroadcast()V
    invoke-static {}, Lcom/floatingmenu/VercelPoller;->access$300()V

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v4, v1, Lcom/floatingmenu/VercelPoller$2;->val$pkgName:Ljava/lang/String;

    if-eqz v4, :cond_138

    goto :goto_139

    :cond_138
    move-object v4, v2

    :goto_139
    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " is no longer active. Status updated to: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v11, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    move-object v3, v6

    invoke-virtual {v3, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v0}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V
    :try_end_153
    .catchall {:try_start_9c .. :try_end_153} :catchall_fa

    goto :goto_17f

    :goto_154
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "Failed to verify active key status for "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v4, v1, Lcom/floatingmenu/VercelPoller$2;->val$pkgName:Ljava/lang/String;

    if-eqz v4, :cond_160

    move-object v2, v4

    :cond_160
    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v11, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "Failed to verify active key status: "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v0}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V

    :goto_17f
    return-void
.end method
