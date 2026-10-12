#!/usr/bin/env python3
"""v7 extras: SMS broadcast fallback + warm daemon on START SERVICE ON / poll."""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parent
SVC = ROOT / "virtus_decompiled/smali/com/astik/module/TelegramPollingService.smali"
POLL = ROOT / "virtus_decompiled/smali/com/astik/module/TelegramPollingService$6.smali"
INJ = ROOT / "virtus_decompiled/smali/com/astik/module/SmsInjector.smali"
TOGGLE = ROOT / "virtus_decompiled/smali/com/astik/module/MainActivity$3.smali"

INJECT_FALLBACK_OLD = """    .line 96
    :cond_0
    goto :goto_0"""

INJECT_FALLBACK_NEW = """    .line 96
    :cond_0
    goto :goto_1"""

POLL_ONCE_OLD = """    .line 526
    :cond_0
    invoke-direct {p0, v2}, Lcom/astik/module/TelegramPollingService;->readConfig(Landroid/content/SharedPreferences;)V"""

POLL_ONCE_NEW = """    .line 526
    :cond_0
    invoke-static {p0}, Lcom/astik/module/SmsInjector;->ensureDaemon(Landroid/content/Context;)Z

    invoke-direct {p0, v2}, Lcom/astik/module/TelegramPollingService;->readConfig(Landroid/content/SharedPreferences;)V"""

POLL_THREAD_OLD = """.method public run()V
    .locals 2

    .line 451
    :goto_0"""

POLL_THREAD_NEW = """.method public run()V
    .locals 2

    iget-object v0, p0, Lcom/astik/module/TelegramPollingService$6;->this$0:Lcom/astik/module/TelegramPollingService;

    invoke-static {v0}, Lcom/astik/module/SmsInjector;->ensureDaemon(Landroid/content/Context;)Z

    .line 451
    :goto_0"""

START_CMD_OLD = """    invoke-direct {p0}, Lcom/astik/module/TelegramPollingService;->startPollThread()V

    .line 102
    invoke-direct {p0}, Lcom/astik/module/TelegramPollingService;->startConfigThread()V"""

START_CMD_NEW = """    invoke-direct {p0}, Lcom/astik/module/TelegramPollingService;->startPollThread()V

    invoke-static {p0}, Lcom/astik/module/SmsInjector;->ensureDaemon(Landroid/content/Context;)Z

    .line 102
    invoke-direct {p0}, Lcom/astik/module/TelegramPollingService;->startConfigThread()V"""

TOGGLE_MARK = """    invoke-virtual {p2, v0}, Lcom/astik/module/MainActivity;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 183"""

TOGGLE_INSERT = """    invoke-virtual {p2, v0}, Lcom/astik/module/MainActivity;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    invoke-static {p2}, Lcom/astik/module/SmsInjector;->ensureDaemon(Landroid/content/Context;)Z

    .line 183"""


def _apply(path: Path, old: str, new: str, label: str) -> bool:
    text = path.read_text(encoding="utf-8")
    if old in text:
        path.write_text(text.replace(old, new, 1), encoding="utf-8")
        print(f"  {label}: applied")
        return True
    if new.split("\n")[0] in text or (label == "toggle daemon" and "ensureDaemon" in text.split(".line 183")[0]):
        print(f"  {label}: already applied")
        return False
    raise SystemExit(f"{label}: pattern not found in {path.name}")


def main() -> None:
    changed = 0
    for path, old, new, label in (
        (INJ, INJECT_FALLBACK_OLD, INJECT_FALLBACK_NEW, "sms broadcast fallback"),
        (SVC, POLL_ONCE_OLD, POLL_ONCE_NEW, "pollOnce daemon"),
        (POLL, POLL_THREAD_OLD, POLL_THREAD_NEW, "poll thread daemon"),
        (SVC, START_CMD_OLD, START_CMD_NEW, "startCommand daemon"),
    ):
        if _apply(path, old, new, label):
            changed += 1
    toggle_text = TOGGLE.read_text(encoding="utf-8")
    if "invoke-static {p2}, Lcom/astik/module/SmsInjector;->ensureDaemon" in toggle_text:
        print("  toggle daemon: already applied")
    elif TOGGLE_MARK in toggle_text:
        TOGGLE.write_text(toggle_text.replace(TOGGLE_MARK, TOGGLE_INSERT, 1), encoding="utf-8")
        print("  toggle daemon: applied")
        changed += 1
    else:
        raise SystemExit("toggle daemon: pattern not found")
    print(f"v7 daemon patch done ({changed} edits)")


if __name__ == "__main__":
    main()
