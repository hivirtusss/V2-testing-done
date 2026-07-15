.class Lcom/floatingmenu/VercelPoller$5;
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
    .registers 18

    const-string v1, "SSE Listener Error: "

    const-string v2, "SSE Connection failed with response code: "

    const-string v3, ", body="

    const-string v4, "Received INSTANT SMS command via SSE: sender="

    const-string v5, "Connecting to SSE stream: "

    const-string v6, "active"

    const-string v7, "GET_LICENSE_STATUS"

    const-string v8, "ZygiskMenuPoller"

    const-string v0, "Asynchronous SSE SMS Listener Thread started."

    invoke-static {v8, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v0}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V

    :catch_18
    :goto_18
    const-wide/16 v10, 0x1388

    :try_start_1a
    # invokes: Lcom/floatingmenu/VercelPoller;->getLicenseKeyFromPrefs()Ljava/lang/String;
    invoke-static {}, Lcom/floatingmenu/VercelPoller;->access$600()Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_31

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v12

    if-eqz v12, :cond_27

    goto :goto_31

    :cond_27
    # invokes: Lcom/floatingmenu/VercelPoller;->querySocket(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v7}, Lcom/floatingmenu/VercelPoller;->access$200(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v12

    invoke-virtual {v6, v12}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v12

    if-nez v12, :cond_3b

    :cond_31
    :goto_31
    invoke-static {v10, v11}, Ljava/lang/Thread;->sleep(J)V

    goto :goto_18

    :catchall_35
    move-exception v0

    const/4 v9, 0x0

    :goto_37
    const/16 v16, 0x0

    goto/16 :goto_19d

    :cond_3b
    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    const-string v13, "pria_sms_"

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v13, "[^a-zA-Z0-9_-]"

    const-string v14, ""

    invoke-virtual {v0, v13, v14}, Ljava/lang/String;->replaceAll(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v12, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    const-string v13, "https://ntfy.sh/"

    invoke-virtual {v12, v13}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "/json"

    invoke-virtual {v12, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v12, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v12

    invoke-static {v8, v12}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v12, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v12

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v12}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V

    new-instance v12, Ljava/net/URL;

    invoke-direct {v12, v0}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {v12}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v0

    move-object v12, v0

    check-cast v12, Ljava/net/HttpURLConnection;
    :try_end_9a
    .catchall {:try_start_1a .. :try_end_9a} :catchall_35

    :try_start_9a
    const-string v0, "GET"

    invoke-virtual {v12, v0}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/16 v0, 0x2710

    invoke-virtual {v12, v0}, Ljava/net/URLConnection;->setConnectTimeout(I)V

    const/4 v0, 0x0

    invoke-virtual {v12, v0}, Ljava/net/URLConnection;->setReadTimeout(I)V

    invoke-virtual {v12, v0}, Ljava/net/URLConnection;->setUseCaches(Z)V

    invoke-virtual {v12}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v13

    const/16 v14, 0xc8

    if-ne v13, v14, :cond_16f

    new-instance v13, Ljava/io/BufferedReader;

    new-instance v14, Ljava/io/InputStreamReader;

    invoke-virtual {v12}, Ljava/net/URLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v15

    const-string v9, "UTF-8"

    invoke-direct {v14, v15, v9}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    invoke-direct {v13, v14}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V
    :try_end_c3
    .catchall {:try_start_9a .. :try_end_c3} :catchall_16b

    :cond_c3
    :goto_c3
    :try_start_c3
    invoke-virtual {v13}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v9

    if-eqz v9, :cond_169

    invoke-virtual {v9}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v9}, Ljava/lang/String;->isEmpty()Z

    move-result v14

    if-eqz v14, :cond_d4

    goto :goto_c3

    :cond_d4
    new-instance v14, Ljava/lang/StringBuilder;

    invoke-direct {v14}, Ljava/lang/StringBuilder;-><init>()V

    const-string v15, "Received stream line: "

    invoke-virtual {v14, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v14, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v14}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v14

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v14}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V

    # invokes: Lcom/floatingmenu/VercelPoller;->querySocket(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v7}, Lcom/floatingmenu/VercelPoller;->access$200(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v14

    invoke-virtual {v6, v14}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v14

    if-nez v14, :cond_f4

    goto/16 :goto_169

    :cond_f4
    const-string v14, "\"event\":\"message\""

    invoke-virtual {v9, v14}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v14

    if-eqz v14, :cond_c3

    const-string v14, "message"

    # invokes: Lcom/floatingmenu/VercelPoller;->extractJsonString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v9, v14}, Lcom/floatingmenu/VercelPoller;->access$700(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9

    if-eqz v9, :cond_c3

    const-string v14, "|"

    invoke-virtual {v9, v14}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v14

    if-eqz v14, :cond_c3

    const-string v14, "\\|"

    const/4 v15, 0x2

    invoke-virtual {v9, v14, v15}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v9

    array-length v14, v9

    if-ne v14, v15, :cond_c3

    aget-object v14, v9, v0

    invoke-virtual {v14}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v14

    const/4 v15, 0x1

    aget-object v9, v9, v15

    invoke-virtual {v9}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v9

    invoke-virtual {v14}, Ljava/lang/String;->isEmpty()Z

    move-result v15

    if-nez v15, :cond_c3

    invoke-virtual {v9}, Ljava/lang/String;->isEmpty()Z

    move-result v15

    if-nez v15, :cond_c3

    new-instance v15, Ljava/lang/StringBuilder;

    invoke-direct {v15}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v15, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v15, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v15, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v15, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v15}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v15

    invoke-static {v8, v15}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    new-instance v15, Ljava/lang/StringBuilder;

    invoke-direct {v15}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v15, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v15, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v15, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v15, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v15}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v15

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v15}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V

    # invokes: Lcom/floatingmenu/VercelPoller;->broadcastSms(Ljava/lang/String;Ljava/lang/String;)V
    invoke-static {v14, v9}, Lcom/floatingmenu/VercelPoller;->access$800(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_162
    .catchall {:try_start_c3 .. :try_end_162} :catchall_164

    goto/16 :goto_c3

    :catchall_164
    move-exception v0

    move-object v9, v12

    move-object/from16 v16, v13

    goto :goto_19d

    :cond_169
    :goto_169
    move-object v9, v13

    goto :goto_194

    :catchall_16b
    move-exception v0

    move-object v9, v12

    goto/16 :goto_37

    :cond_16f
    :try_start_16f
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v8, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v13}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v0}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V
    :try_end_193
    .catchall {:try_start_16f .. :try_end_193} :catchall_16b

    const/4 v9, 0x0

    :goto_194
    if-eqz v9, :cond_199

    :try_start_196
    invoke-virtual {v9}, Ljava/io/BufferedReader;->close()V
    :try_end_199
    .catch Ljava/lang/Exception; {:try_start_196 .. :try_end_199} :catch_199

    :catch_199
    :cond_199
    :try_start_199
    invoke-virtual {v12}, Ljava/net/HttpURLConnection;->disconnect()V
    :try_end_19c
    .catch Ljava/lang/Exception; {:try_start_199 .. :try_end_19c} :catch_1c2

    goto :goto_1c2

    :goto_19d
    :try_start_19d
    invoke-static {v8, v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    new-instance v12, Ljava/lang/StringBuilder;

    invoke-direct {v12}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v12, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/Throwable;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v12, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    # invokes: Lcom/floatingmenu/VercelPoller;->logToFile(Ljava/lang/String;)V
    invoke-static {v0}, Lcom/floatingmenu/VercelPoller;->access$000(Ljava/lang/String;)V
    :try_end_1b6
    .catchall {:try_start_19d .. :try_end_1b6} :catchall_1c7

    if-eqz v16, :cond_1bd

    :try_start_1b8
    invoke-virtual/range {v16 .. v16}, Ljava/io/BufferedReader;->close()V
    :try_end_1bb
    .catch Ljava/lang/Exception; {:try_start_1b8 .. :try_end_1bb} :catch_1bc

    goto :goto_1bd

    :catch_1bc
    nop

    :cond_1bd
    :goto_1bd
    if-eqz v9, :cond_1c2

    :try_start_1bf
    invoke-virtual {v9}, Ljava/net/HttpURLConnection;->disconnect()V
    :try_end_1c2
    .catch Ljava/lang/Exception; {:try_start_1bf .. :try_end_1c2} :catch_1c2

    :catch_1c2
    :cond_1c2
    :goto_1c2
    :try_start_1c2
    invoke-static {v10, v11}, Ljava/lang/Thread;->sleep(J)V
    :try_end_1c5
    .catch Ljava/lang/InterruptedException; {:try_start_1c2 .. :try_end_1c5} :catch_18

    goto/16 :goto_18

    :catchall_1c7
    move-exception v0

    if-eqz v16, :cond_1cf

    :try_start_1ca
    invoke-virtual/range {v16 .. v16}, Ljava/io/BufferedReader;->close()V
    :try_end_1cd
    .catch Ljava/lang/Exception; {:try_start_1ca .. :try_end_1cd} :catch_1ce

    goto :goto_1cf

    :catch_1ce
    nop

    :cond_1cf
    :goto_1cf
    if-eqz v9, :cond_1d4

    :try_start_1d1
    invoke-virtual {v9}, Ljava/net/HttpURLConnection;->disconnect()V
    :try_end_1d4
    .catch Ljava/lang/Exception; {:try_start_1d1 .. :try_end_1d4} :catch_1d4

    :catch_1d4
    :cond_1d4
    goto :goto_1d6

    :goto_1d5
    throw v0

    :goto_1d6
    goto :goto_1d5
.end method
