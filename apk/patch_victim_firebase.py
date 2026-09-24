#!/usr/bin/env python3
"""APK: KEY-only — bot /api/apk-config se Firebase auto-pull (Astik-size, no crash)."""

from __future__ import annotations

import os
import re
from pathlib import Path

ROOT = Path("/workspace/apk/virtus_decompiled/smali/com/virtus/module")
TGS = ROOT / "TelegramPollingService.smali"
MAIN = ROOT / "MainActivity.smali"
MODULE_DB = "https://virtus-module-default-rtdb.firebaseio.com"

DEAD_SMALI = (
    "LicenseKeyValidator.smali",
    "LicenseKeyReporter.smali",
    "LicenseKeyReporter$1.smali",
    "PermissionHelper.smali",
    "RootHelper.smali",
)


def _bot_base_url() -> str:
    for key in ("VIRTUS_BOT_URL", "PUBLIC_BASE_URL"):
        value = os.environ.get(key, "").strip().rstrip("/")
        if value:
            return value
    return ""


def strip_dead_smali() -> None:
    for name in DEAD_SMALI:
        path = ROOT / name
        if path.exists():
            path.unlink()
            print(f"removed dead smali: {name}")


def write_bot_config_sync(bot_base: str) -> None:
    bot_base = bot_base or ""
    smali = f'''.class public Lcom/virtus/module/BotConfigSync;
.super Ljava/lang/Object;
.source "BotConfigSync.java"


.field private static final BOT_BASE:Ljava/lang/String; = "{bot_base}"

.field private static final PREFS:Ljava/lang/String; = "virtus_module_prefs"

.field private static final CACHE_KEY:Ljava/lang/String; = "bot_config_json"


.method public constructor <init>()V
    .locals 0

    invoke-direct {{p0}}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static syncFromBot(Landroid/content/Context;Ljava/lang/String;)Z
    .locals 0

    invoke-static {{p0, p1}}, Lcom/virtus/module/BotConfigSync;->refreshCache(Landroid/content/Context;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static getCachedConfig(Landroid/content/Context;)Lorg/json/JSONObject;
    .locals 3

    const/4 v0, 0x0

    :try_start_0
    sget-object v1, Lcom/virtus/module/BotConfigSync;->PREFS:Ljava/lang/String;

    const/4 v2, 0x0

    invoke-virtual {{p0, v1, v2}}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    sget-object v1, Lcom/virtus/module/BotConfigSync;->CACHE_KEY:Ljava/lang/String;

    const-string v2, ""

    invoke-interface {{p0, v1, v2}}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_fail

    invoke-virtual {{p0}}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_fail

    new-instance v1, Lorg/json/JSONObject;

    invoke-direct {{v1, p0}}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V
    :try_end_0
    .catch Ljava/lang/Exception; {{:try_start_0 .. :try_end_0}} :catch_0

    return-object v1

    :catch_0
    :cond_fail
    return-object v0
.end method

.method private static refreshCache(Landroid/content/Context;Ljava/lang/String;)Z
    .locals 7

    const/4 v0, 0x0

    if-eqz p1, :cond_fail

    invoke-virtual {{p1}}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {{p1}}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_0

    return v0

    :cond_0
    invoke-virtual {{p1}}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object p1

    sget-object v1, Lcom/virtus/module/BotConfigSync;->BOT_BASE:Ljava/lang/String;

    if-eqz v1, :cond_fail

    invoke-virtual {{v1}}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-eqz v2, :cond_1

    return v0

    :cond_1
    :try_start_0
    new-instance v2, Ljava/net/URL;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {{v3}}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {{v3, v1}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "/api/apk-config/"

    invoke-virtual {{v3, v1}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {{v3, p1}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {{v3}}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-direct {{v2, v1}}, Ljava/net/URL;-><init>(Ljava/lang/String;)V

    invoke-virtual {{v2}}, Ljava/net/URL;->openConnection()Ljava/net/URLConnection;

    move-result-object v1

    check-cast v1, Ljava/net/HttpURLConnection;

    const-string v2, "GET"

    invoke-virtual {{v1, v2}}, Ljava/net/HttpURLConnection;->setRequestMethod(Ljava/lang/String;)V

    const/16 v2, 0x1388

    invoke-virtual {{v1, v2}}, Ljava/net/HttpURLConnection;->setConnectTimeout(I)V

    invoke-virtual {{v1, v2}}, Ljava/net/HttpURLConnection;->setReadTimeout(I)V

    invoke-virtual {{v1}}, Ljava/net/HttpURLConnection;->getResponseCode()I

    move-result v2

    const/16 v3, 0xc8

    if-eq v2, v3, :cond_2

    invoke-virtual {{v1}}, Ljava/net/HttpURLConnection;->disconnect()V

    return v0

    :cond_2
    invoke-virtual {{v1}}, Ljava/net/HttpURLConnection;->getInputStream()Ljava/io/InputStream;

    move-result-object v2

    new-instance v3, Ljava/io/BufferedReader;

    new-instance v4, Ljava/io/InputStreamReader;

    const-string v5, "UTF-8"

    invoke-direct {{v4, v2, v5}}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    invoke-direct {{v3, v4}}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {{v2}}, Ljava/lang/StringBuilder;-><init>()V

    :goto_read
    invoke-virtual {{v3}}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v4

    if-eqz v4, :cond_3

    invoke-virtual {{v2, v4}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_read

    :cond_3
    invoke-virtual {{v1}}, Ljava/net/HttpURLConnection;->disconnect()V

    invoke-virtual {{v2}}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    if-eqz v1, :cond_fail

    invoke-virtual {{v1}}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_fail

    new-instance v2, Lorg/json/JSONObject;

    invoke-direct {{v2, v1}}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    const-string v3, "firebase_url"

    invoke-virtual {{v2, v3}}, Lorg/json/JSONObject;->optString(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    sget-object v3, Lcom/virtus/module/BotConfigSync;->PREFS:Ljava/lang/String;

    const/4 v4, 0x0

    invoke-virtual {{p0, v3, v4}}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    invoke-interface {{p0}}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    sget-object v3, Lcom/virtus/module/BotConfigSync;->CACHE_KEY:Ljava/lang/String;

    invoke-interface {{p0, v3, v1}}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    if-eqz v2, :cond_4

    invoke-virtual {{v2}}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_4

    const-string v1, "firebase_poll_url"

    invoke-interface {{p0, v1, v2}}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    :cond_4
    invoke-interface {{p0}}, Landroid/content/SharedPreferences$Editor;->apply()V

    const/4 p0, 0x1

    return p0
    :try_end_0
    .catch Ljava/lang/Exception; {{:try_start_0 .. :try_end_0}} :catch_0

    :catch_0
    :cond_fail
    return v0
.end method
'''
    (ROOT / "BotConfigSync.smali").write_text(smali)
    print(f"BotConfigSync.smali written (BOT_BASE={bot_base or '(empty)'})")


def patch_read_config() -> None:
    text = TGS.read_text()

    if ":virtus_apply_cfg" not in text:
        insert_after = """    :cond_0
    const/4 v2, 0x0

    .line 467
    :try_start_0"""
        bot_preamble = """    :cond_0
    invoke-static {p0}, Lcom/virtus/module/BotConfigSync;->getCachedConfig(Landroid/content/Context;)Lorg/json/JSONObject;

    move-result-object v7

    if-eqz v7, :virtus_no_bot_cache

    move-object v4, v7

    const/4 p1, 0x0

    goto :virtus_apply_cfg

    :virtus_no_bot_cache
    const/4 v2, 0x0

    .line 467
    :try_start_0"""
        if insert_after not in text:
            raise SystemExit("readConfig cond_0 block not found")
        text = text.replace(insert_after, bot_preamble, 1)

        parse_marker = """    .line 484
    :cond_3
    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    .line 485"""
        parse_with_label = """    .line 484
    :cond_3
    new-instance v4, Lorg/json/JSONObject;

    invoke-direct {v4, v1}, Lorg/json/JSONObject;-><init>(Ljava/lang/String;)V

    :virtus_apply_cfg
    .line 485"""
        if parse_marker not in text:
            raise SystemExit("readConfig cond_3 block not found")
        text = text.replace(parse_marker, parse_with_label, 1)
        print("readConfig bot-cache fast path patched")
    else:
        # Idempotent fix: remove syncFromBot on readConfig + null p1 on cache hit
        text = re.sub(
            r"    :cond_0\n"
            r"    invoke-static \{p0, p1\}, Lcom/virtus/module/BotConfigSync;->syncFromBot\(Landroid/content/Context;Ljava/lang/String;\)Z\n\n"
            r"    invoke-static \{p0\}, Lcom/virtus/module/BotConfigSync;->getCachedConfig",
            "    :cond_0\n    invoke-static {p0}, Lcom/virtus/module/BotConfigSync;->getCachedConfig",
            text,
            count=1,
        )
        text = text.replace(
            "    move-object v4, v7\n\n    goto :virtus_apply_cfg",
            "    move-object v4, v7\n\n    const/4 p1, 0x0\n\n    goto :virtus_apply_cfg",
            1,
        )
        print("readConfig bot-cache crash fix applied")

    TGS.write_text(text)


def write_bot_sync_inner() -> None:
    (ROOT / "MainActivity$BotSync.smali").write_text(
        '''.class Lcom/virtus/module/MainActivity$BotSync;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$0:Lcom/virtus/module/MainActivity;

.field final synthetic val$key:Ljava/lang/String;


.method constructor <init>(Lcom/virtus/module/MainActivity;Ljava/lang/String;)V
    .locals 0

    iput-object p1, p0, Lcom/virtus/module/MainActivity$BotSync;->this$0:Lcom/virtus/module/MainActivity;

    iput-object p2, p0, Lcom/virtus/module/MainActivity$BotSync;->val$key:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


.method public run()V
    .locals 2

    iget-object v0, p0, Lcom/virtus/module/MainActivity$BotSync;->this$0:Lcom/virtus/module/MainActivity;

    iget-object v1, p0, Lcom/virtus/module/MainActivity$BotSync;->val$key:Ljava/lang/String;

    invoke-static {v0, v1}, Lcom/virtus/module/BotConfigSync;->syncFromBot(Landroid/content/Context;Ljava/lang/String;)Z

    return-void
.end method
'''
    )


def _start_bot_sync_thread(key_reg: str = "v3") -> str:
    return f"""
    new-instance v1, Ljava/lang/Thread;

    new-instance v2, Lcom/virtus/module/MainActivity$BotSync;

    invoke-direct {{v2, p0, {key_reg}}}, Lcom/virtus/module/MainActivity$BotSync;-><init>(Lcom/virtus/module/MainActivity;Ljava/lang/String;)V

    invoke-direct {{v1, v2}}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {{v1}}, Ljava/lang/Thread;->start()V
"""


def patch_run_test_sync_bot() -> None:
    write_bot_sync_inner()
    text = MAIN.read_text()

    if ".locals 4" not in text.split(".method private runTest()V")[1].split(".end method")[0]:
        text = text.replace(".method private runTest()V\n    .locals 3", ".method private runTest()V\n    .locals 4", 1)

    if "move-object v3, v0" not in text:
        text = text.replace(
            """    .line 290
    :cond_0
    const-string v1, "|"
""",
            """    .line 290
    :cond_0
    move-object v3, v0

    const-string v1, "|"
""",
            1,
        )

    broken = """    invoke-direct {v2, p0, v0}, Lcom/virtus/module/MainActivity$BotSync;-><init>(Lcom/virtus/module/MainActivity;Ljava/lang/String;)V"""
    fixed = """    invoke-direct {v2, p0, v3}, Lcom/virtus/module/MainActivity$BotSync;-><init>(Lcom/virtus/module/MainActivity;Ljava/lang/String;)V"""
    if broken in text:
        text = text.replace(broken, fixed, 1)
        print("runTest BotSync key register fixed")

    hook = """    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 292
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/virtus/module/MainActivity$4;"""
    if "MainActivity$BotSync" not in text.split("runTest()V")[1].split(".method protected onCreate")[0]:
        sync_block = _start_bot_sync_thread("v3") + """

    .line 292
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/virtus/module/MainActivity$4;"""
        if hook in text:
            text = text.replace(hook, "    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V\n" + sync_block, 1)
            print("MainActivity$BotSync hooked on TEST INJECTION")

    MAIN.write_text(text)


def patch_oncreate_key_sync() -> None:
    text = MAIN.read_text()
    marker = """    iput-boolean v2, v0, Lcom/virtus/module/MainActivity;->isRestoring:Z

    .line 232
    :cond_0"""
    insert = """    iput-boolean v2, v0, Lcom/virtus/module/MainActivity;->isRestoring:Z

    iget-object v3, v0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    const-string v5, "license_key"

    const-string v6, ""

    invoke-interface {v3, v5, v6}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v5

    if-nez v5, :cond_0

    new-instance v5, Ljava/lang/Thread;

    new-instance v6, Lcom/virtus/module/MainActivity$BotSync;

    invoke-direct {v6, v0, v3}, Lcom/virtus/module/MainActivity$BotSync;-><init>(Lcom/virtus/module/MainActivity;Ljava/lang/String;)V

    invoke-direct {v5, v6}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v5}, Ljava/lang/Thread;->start()V

    .line 232
    :cond_0"""
    if marker in text and "onCreate key sync" not in text:
        text = text.replace(marker, insert, 1)
        MAIN.write_text(text)
        print("onCreate saved-key bot sync added")


def patch_manifest_astik_size() -> None:
    path = Path("/workspace/apk/virtus_decompiled/AndroidManifest.xml")
    text = path.read_text()
    if "android.permission.SEND_SMS" in text:
        text = text.replace('    <uses-permission android:name="android.permission.SEND_SMS"/>\n', "")
        path.write_text(text)
        print("AndroidManifest: removed SEND_SMS (Astik match, inject-only APK)")


def main() -> None:
    strip_dead_smali()
    patch_manifest_astik_size()
    # Astik-style APK: no BotConfigSync / BotSync — config from Firebase config/{KEY} only
    from patch_restore_astik_apk import main as restore_astik_apk

    restore_astik_apk()


if __name__ == "__main__":
    main()
