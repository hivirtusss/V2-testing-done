#!/usr/bin/env python3
"""Keep inject service alive up to 60+ min; uptime survives app close."""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parent
OUT = ROOT / "virtus_decompiled"

# 60 min wake lock (was 30 min) — config thread renews every 2s anyway
WAKE_60 = """    const-wide/32 v1, 0x36ee80

    invoke-virtual {v0, v1, v2}, Landroid/os/PowerManager$WakeLock;->acquire(J)V"""

WAKE_INDEF = """    invoke-virtual {v0}, Landroid/os/PowerManager$WakeLock;->acquire()V"""

WAKE_OLD = """    const-wide/32 v1, 0x1b7740

    invoke-virtual {v0, v1, v2}, Landroid/os/PowerManager$WakeLock;->acquire(J)V"""

START_FG = "invoke-virtual {{{}, {}}}, {}/{};->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;"

REPLACEMENTS: list[tuple[str, str]] = [
    (WAKE_OLD, WAKE_INDEF),
    (
        ".field public static volatile cfgTs:J",
        ".field public static volatile cfgTs:J\n\n.field public static serviceStartedAt:J",
    ),
    (
        """    iput-boolean p1, p0, Lcom/astik/module/TelegramPollingService;->isRunning:Z

    const/4 p2, 0x0

    .line 98
    iput-boolean p2, p0, Lcom/astik/module/TelegramPollingService;->streamStop:Z""",
        """    iput-boolean p1, p0, Lcom/astik/module/TelegramPollingService;->isRunning:Z

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v0

    sget-wide v2, Lcom/astik/module/TelegramPollingService;->serviceStartedAt:J

    const-wide/16 v4, 0x0

    cmp-long v2, v2, v4

    if-gtz v2, :skip_service_start_ts

    sput-wide v0, Lcom/astik/module/TelegramPollingService;->serviceStartedAt:J

    const-string v2, "astik_module_prefs"

    const/4 v4, 0x0

    invoke-virtual {p0, v2, v4}, Lcom/astik/module/TelegramPollingService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v2

    invoke-interface {v2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v2

    const-string v4, "service_started_at"

    invoke-interface {v2, v4, v0, v1}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    :skip_service_start_ts
    const/4 p2, 0x0

    .line 98
    iput-boolean p2, p0, Lcom/astik/module/TelegramPollingService;->streamStop:Z""",
    ),
    (
        """.method public onStartCommand(Landroid/content/Intent;II)I
    .locals 1""",
        """.method public onStartCommand(Landroid/content/Intent;II)I
    .locals 6""",
    ),
    (
        """    .line 252
    sget-wide v0, Lcom/astik/module/TelegramPollingService;->cfgTs:J

    .line 253
    sget-boolean v2, Lcom/astik/module/TelegramPollingService;->cfgMonitoring:Z

    const/high16 v3, 0x41200000    # 10.0f

    const/4 v4, 0x0

    if-eqz v2, :cond_1

    const-wide/16 v5, 0x0

    cmp-long v2, v0, v5

    if-lez v2, :cond_1""",
        """    .line 252
    iget-object v0, p0, Lcom/astik/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    const-string v1, "service_started_at"

    const-wide/16 v2, 0x0

    invoke-interface {v0, v1, v2, v3}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v0

    const-wide/16 v5, 0x0

    cmp-long v2, v0, v5

    if-gtz v2, :cond_use_cfg_ts

    goto :cond_has_uptime

    :cond_use_cfg_ts
    sget-wide v0, Lcom/astik/module/TelegramPollingService;->cfgTs:J

    :cond_has_uptime
    sget-boolean v2, Lcom/astik/module/TelegramPollingService;->cfgMonitoring:Z

    const/high16 v3, 0x41200000    # 10.0f

    const/4 v4, 0x0

    if-eqz v2, :cond_check_service_on

    goto :cond_do_uptime

    :cond_check_service_on
    iget-object v2, p0, Lcom/astik/module/MainActivity;->prefs:Landroid/content/SharedPreferences;

    const-string v7, "service_on"

    const/4 v8, 0x0

    invoke-interface {v2, v7, v8}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v2

    if-eqz v2, :cond_1

    :cond_do_uptime
    cmp-long v2, v0, v5

    if-lez v2, :cond_1""",
    ),
    (
        """    invoke-virtual {p2, v0}, Lcom/astik/module/MainActivity;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 183
    iget-object p2, p0, Lcom/astik/module/MainActivity$3;->this$0:Lcom/astik/module/MainActivity;

    const-string v0, "Service started \u2014 always alive\"""",
        """    invoke-virtual {p2, v0}, Lcom/astik/module/MainActivity;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 183
    iget-object p2, p0, Lcom/astik/module/MainActivity$3;->this$0:Lcom/astik/module/MainActivity;

    const-string v0, "Service started \u2014 60 min inject active\"""",
    ),
    (
        """    invoke-virtual {p2, v0}, Lcom/astik/module/MainActivity;->stopService(Landroid/content/Intent;)Z

    .line 186
    iget-object p2, p0, Lcom/astik/module/MainActivity$3;->this$0:Lcom/astik/module/MainActivity;

    const-string v0, "Service stopped\"""",
        """    invoke-virtual {p2, v0}, Lcom/astik/module/MainActivity;->stopService(Landroid/content/Intent;)Z

    const-wide/16 v0, 0x0

    sput-wide v0, Lcom/astik/module/TelegramPollingService;->serviceStartedAt:J

    iget-object p2, p0, Lcom/astik/module/MainActivity$3;->this$0:Lcom/astik/module/MainActivity;

    invoke-static {p2}, Lcom/astik/module/MainActivity;->access$400(Lcom/astik/module/MainActivity;)Landroid/content/SharedPreferences;

    move-result-object p2

    invoke-interface {p2}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    const-string v0, "service_started_at"

    const-wide/16 v1, 0x0

    invoke-interface {p2, v0, v1, v2}, Landroid/content/SharedPreferences$Editor;->putLong(Ljava/lang/String;J)Landroid/content/SharedPreferences$Editor;

    move-result-object p2

    invoke-interface {p2}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 186
    iget-object p2, p0, Lcom/astik/module/MainActivity$3;->this$0:Lcom/astik/module/MainActivity;

    const-string v0, "Service stopped\"""",
    ),
    (
        """    invoke-virtual {v0, v1}, Lcom/astik/module/MainActivity;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 235
    :cond_1
    iget-object v1, v0, Lcom/astik/module/MainActivity;->uiHandler:Landroid/os/Handler;""",
        """    invoke-virtual {v0, v1}, Lcom/astik/module/MainActivity;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 235
    :cond_1
    iget-object v1, v0, Lcom/astik/module/MainActivity;->uiHandler:Landroid/os/Handler;""",
    ),
]


def patch_file(path: Path) -> bool:
    text = path.read_text(encoding="utf-8", errors="replace")
    original = text
    for old, new in REPLACEMENTS:
        if old in text:
            text = text.replace(old, new, 1)
    if text != original:
        path.write_text(text, encoding="utf-8")
        return True
    return False


def main() -> None:
    if not OUT.is_dir():
        raise SystemExit(f"Missing {OUT}")

    changed = 0
    for name in (
        "TelegramPollingService.smali",
        "TelegramPollingService$1.smali",
        "MainActivity.smali",
        "MainActivity$3.smali",
    ):
        path = OUT / "smali/com/astik/module" / name
        if path.is_file() and patch_file(path):
            changed += 1

    print(f"60-min runtime patch applied ({changed} smali files)")


if __name__ == "__main__":
    main()
