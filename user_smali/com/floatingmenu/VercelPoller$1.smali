.class Lcom/floatingmenu/VercelPoller$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic val$key:Ljava/lang/String;

.field final synthetic val$pkgName:Ljava/lang/String;

.field final synthetic val$prefsFile:Ljava/io/File;


# direct methods
.method public constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/io/File;)V
    .registers 4

    iput-object p1, p0, Lcom/floatingmenu/VercelPoller$1;->val$key:Ljava/lang/String;

    iput-object p2, p0, Lcom/floatingmenu/VercelPoller$1;->val$pkgName:Ljava/lang/String;

    iput-object p3, p0, Lcom/floatingmenu/VercelPoller$1;->val$prefsFile:Ljava/io/File;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 18

    move-object/from16 v1, p0

    const-string v0, "device_mismatch"

    const-string v2, "expired"

    const-string v3, "blocked"

    const-string v4, "Asynchronous validation complete (admin bypass). Status: active"

    const-string v5, "global"

    const-string v6, "ZygiskMenuPoller"

    const-string v7, "Asynchronous validation complete. Status: "

    const-string v8, "Asynchronous validation complete for "

    const-string v9, "SET_LICENSE_STATUS|"

    const-string v10, "validateKeyOnBehalfOfApp - decrypted response: "

    const-string v11, "{\"licenseKey\":\""

    const-string v12, "device_"

    const-string v13, "Starting validateKeyOnBehalfOfApp. Key: "

    const-string v14, "Validating key \'"

    :try_start_1e
    new-instance v15, Ljava/lang/StringBuilder;

    invoke-direct {v15, v14}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v14, v1, Lcom/floatingmenu/VercelPoller$1;->val$key:Ljava/lang/String;

    invoke-virtual {v15, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v14, "\' on behalf of package: "

    invoke-virtual {v15, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v14, v1, Lcom/floatingmenu/VercelPoller$1;->val$pkgName:Ljava/lang/String;

    if-eqz v14, :cond_32

    goto :goto_33

    :cond_32
    move-object v14, v5

    :goto_33
    invoke-virtual {v15, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v15}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v14

    invoke-static {v6, v14}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    new-instance v14, Ljava/lang/StringBuilder;

    invoke-direct {v14, v13}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v13, v1, Lcom/floatingmenu/VercelPoller$1;->val$key:Ljava/lang/String;

    invoke-virtual {v14, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v13, ", Package: "

    invoke-virtual {v14, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v13, v1, Lcom/floatingmenu/VercelPoller$1;->val$pkgName:Ljava/lang/String;

    if-eqz v13, :cond_51

    goto :goto_52

    :cond_51
    move-object v13, v5

    :goto_52
    invoke-virtual {v14, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v14}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v13

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v13}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V

    iget-object v13, v1, Lcom/floatingmenu/VercelPoller$1;->val$key:Ljava/lang/String;

    const-string v14, "admin"

    invoke-virtual {v13, v14}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v13
    :try_end_64
    .catchall {:try_start_1e .. :try_end_64} :catchall_73

    const-string v14, "active"

    const/4 v15, 0x1

    if-eqz v13, :cond_85

    :try_start_69
    iget-object v0, v1, Lcom/floatingmenu/VercelPoller$1;->val$prefsFile:Ljava/io/File;

    if-eqz v0, :cond_76

    iget-object v2, v1, Lcom/floatingmenu/VercelPoller$1;->val$key:Ljava/lang/String;

    # invokes: Lcom/floatingmenu/VercelPoller;->writeValidationResponseToPrefs(Ljava/io/File;ZLjava/lang/String;Ljava/lang/String;)V
    invoke-static {v0, v15, v14, v2}, Lcom/floatingmenu/VercelPoller;->access$100(Ljava/io/File;ZLjava/lang/String;Ljava/lang/String;)V

    goto :goto_76

    :catchall_73
    move-exception v0

    goto/16 :goto_167

    :cond_76
    :goto_76
    const-string v0, "SET_LICENSE_STATUS|active"

    # invokes: Lcom/floatingmenu/VercelPoller;->querySocket(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v0}, Lcom/floatingmenu/VercelPoller;->access$200(Ljava/lang/String;)Ljava/lang/String;

    # invokes: Lcom/floatingmenu/VercelPoller;->sendStateChangedBroadcast()V
    invoke-static {}, Lcom/floatingmenu/VercelPoller;->access$300()V

    invoke-static {v6, v4}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v4}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V

    return-void

    :cond_85
    new-instance v4, Ljava/io/File;

    const-string v13, "/data/adb/modules/zygisk_floating_menu/device_id"

    invoke-direct {v4, v13}, Ljava/io/File;-><init>(Ljava/lang/String;)V

    const-string v13, ""

    invoke-virtual {v4}, Ljava/io/File;->exists()Z

    move-result v16

    if-eqz v16, :cond_9e

    # invokes: Lcom/floatingmenu/VercelPoller;->readFileToString(Ljava/io/File;)Ljava/lang/String;
    invoke-static {v4}, Lcom/floatingmenu/VercelPoller;->access$400(Ljava/io/File;)Ljava/lang/String;

    move-result-object v13

    if-eqz v13, :cond_9e

    invoke-virtual {v13}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v13

    :cond_9e
    if-eqz v13, :cond_a9

    invoke-virtual {v13}, Ljava/lang/String;->isEmpty()Z

    move-result v16

    if-eqz v16, :cond_a7

    goto :goto_a9

    :cond_a7
    move-object v12, v14

    goto :goto_c5

    :cond_a9
    :goto_a9
    new-instance v13, Ljava/lang/StringBuilder;

    invoke-direct {v13, v12}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    move-object v12, v14

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v14

    invoke-virtual {v13, v14, v15}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v13
    :try_end_ba
    .catchall {:try_start_69 .. :try_end_ba} :catchall_73

    :try_start_ba
    new-instance v14, Ljava/io/FileWriter;

    invoke-direct {v14, v4}, Ljava/io/FileWriter;-><init>(Ljava/io/File;)V

    invoke-virtual {v14, v13}, Ljava/io/Writer;->write(Ljava/lang/String;)V

    invoke-virtual {v14}, Ljava/io/Writer;->close()V
    :try_end_c5
    .catchall {:try_start_ba .. :try_end_c5} :catchall_c5

    :catchall_c5
    :goto_c5
    :try_start_c5
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v11}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v11, v1, Lcom/floatingmenu/VercelPoller$1;->val$key:Ljava/lang/String;

    invoke-virtual {v4, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v11, "\",\"deviceId\":\""

    invoke-virtual {v4, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v11, "\",\"timestamp\":"

    invoke-virtual {v4, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v13

    invoke-virtual {v4, v13, v14}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v11, "}"

    invoke-virtual {v4, v11}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/floatingmenu/CryptoHelper;->encrypt(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    const-string v11, "validateKeyOnBehalfOfApp - sending POST request to verify-license..."

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v11}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V

    const-string v11, "https://vercellicenseapi.vercel.app/api/verify-license"

    # invokes: Lcom/floatingmenu/VercelPoller;->makePostRequest(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v11, v4}, Lcom/floatingmenu/VercelPoller;->access$500(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/floatingmenu/CryptoHelper;->decrypt(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    new-instance v11, Ljava/lang/StringBuilder;

    invoke-direct {v11, v10}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v11, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v11}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v10

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v10}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V

    const-string v10, "invalid"

    const-string v11, "\"status\":\"active\""

    invoke-virtual {v4, v11}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v11

    if-eqz v11, :cond_11b

    move-object v0, v12

    const/4 v15, 0x1

    goto :goto_12f

    :cond_11b
    invoke-virtual {v4, v3}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v11

    const/4 v15, 0x0

    if-eqz v11, :cond_124

    move-object v0, v3

    goto :goto_12f

    :cond_124
    move-object v0, v12

    const/4 v15, 0x1

    goto :goto_12f

    invoke-virtual {v4, v0}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_12e

    goto :goto_12f

    :cond_12e
    move-object v0, v10

    :goto_12f
    iget-object v2, v1, Lcom/floatingmenu/VercelPoller$1;->val$prefsFile:Ljava/io/File;

    if-eqz v2, :cond_138

    iget-object v3, v1, Lcom/floatingmenu/VercelPoller$1;->val$key:Ljava/lang/String;

    # invokes: Lcom/floatingmenu/VercelPoller;->writeValidationResponseToPrefs(Ljava/io/File;ZLjava/lang/String;Ljava/lang/String;)V
    invoke-static {v2, v15, v0, v3}, Lcom/floatingmenu/VercelPoller;->access$100(Ljava/io/File;ZLjava/lang/String;Ljava/lang/String;)V

    :cond_138
    invoke-virtual {v9, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    # invokes: Lcom/floatingmenu/VercelPoller;->querySocket(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v2}, Lcom/floatingmenu/VercelPoller;->access$200(Ljava/lang/String;)Ljava/lang/String;

    # invokes: Lcom/floatingmenu/VercelPoller;->sendStateChangedBroadcast()V
    invoke-static {}, Lcom/floatingmenu/VercelPoller;->access$300()V

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v8}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v3, v1, Lcom/floatingmenu/VercelPoller$1;->val$pkgName:Ljava/lang/String;

    if-eqz v3, :cond_14c

    goto :goto_14d

    :cond_14c
    move-object v3, v5

    :goto_14d
    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, ". Status: "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v6, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    invoke-virtual {v7, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v0}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V
    :try_end_166
    .catchall {:try_start_c5 .. :try_end_166} :catchall_73

    goto :goto_197

    :goto_167
    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "Failed to validate key on behalf of "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v3, v1, Lcom/floatingmenu/VercelPoller$1;->val$pkgName:Ljava/lang/String;

    if-eqz v3, :cond_173

    move-object v5, v3

    :cond_173
    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v3, ": "

    invoke-virtual {v2, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v6, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "Failed to validate key: "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v0}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V

    :goto_197
    return-void
.end method
