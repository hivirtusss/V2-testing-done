#!/usr/bin/env python3
"""Optional KEY|firebase_url in runTest — no extra classes, no bot HTTP."""

from pathlib import Path

MAIN = Path(__file__).resolve().parent / "virtus_decompiled/smali/com/virtus/module/MainActivity.smali"

OLD = """    .line 290
    :cond_0
    iget-object v1, p0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "license_key"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V"""

NEW = """    .line 290
    :cond_0
    const-string v1, "|"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :save_plain_key

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

    :save_plain_key
    iget-object v1, p0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "license_key"

    invoke-interface {v1, v2, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V"""


def main() -> None:
    text = MAIN.read_text()
    if ":save_plain_key" in text:
        print("runTest KEY|url pipe already patched (skip)")
        return
    if OLD not in text:
        raise SystemExit("runTest block not found")
    text = text.replace(".method private runTest()V\n    .locals 3", ".method private runTest()V\n    .locals 4", 1)
    MAIN.write_text(text.replace(OLD, NEW, 1))
    print("runTest: optional KEY|firebase_url (multi-DB, no BotUrlSync)")


if __name__ == "__main__":
    main()
