#!/usr/bin/env python3
"""Background inject: foreground service on toggle, warm daemon, inject notification."""

from __future__ import annotations

from pathlib import Path

ROOT = Path(__file__).resolve().parent
SVC = ROOT / "virtus_decompiled/smali/com/astik/module/TelegramPollingService.smali"
TOGGLE = ROOT / "virtus_decompiled/smali/com/astik/module/MainActivity$3.smali"

REPLACEMENTS: list[tuple[Path, str, str]] = [
    (
        TOGGLE,
        "    invoke-virtual {p2, v0}, Lcom/astik/module/MainActivity;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;",
        "    invoke-virtual {p2, v0}, Lcom/astik/module/MainActivity;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;",
    ),
    (
        SVC,
        "    const/4 v2, 0x2\n\n    const-string v3, \"astik_module_channel\"",
        "    const/4 v2, 0x4\n\n    const-string v3, \"astik_module_channel\"",
    ),
    (
        SVC,
        """    invoke-direct {p0}, Lcom/astik/module/TelegramPollingService;->applyRootKeepAlive()V

    .line 92
    invoke-direct {p0}, Lcom/astik/module/TelegramPollingService;->scheduleKeepAlive()V

    return-void
.end method

.method public onDestroy()V""",
        """    invoke-static {p0}, Lcom/astik/module/SmsInjector;->ensureDaemon(Landroid/content/Context;)Z

    invoke-direct {p0}, Lcom/astik/module/TelegramPollingService;->applyRootKeepAlive()V

    .line 92
    invoke-direct {p0}, Lcom/astik/module/TelegramPollingService;->scheduleKeepAlive()V

    return-void
.end method

.method public onDestroy()V""",
    ),
    (
        SVC,
        """    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_1

    .line 382
    :cond_3""",
        """    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :try_start_inject_notify
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "\\u2709 "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ": "

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-direct {p0, v0}, Lcom/astik/module/TelegramPollingService;->buildNotification(Ljava/lang/String;)Landroid/app/Notification;

    move-result-object v0

    const-string v1, "notification"

    invoke-virtual {p0, v1}, Lcom/astik/module/TelegramPollingService;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/app/NotificationManager;

    if-eqz v1, :inject_notify_done

    const/16 v2, 0x3e7

    invoke-virtual {v1, v2, v0}, Landroid/app/NotificationManager;->notify(ILandroid/app/Notification;)V

    :inject_notify_done
    :try_end_inject_notify
    .catch Ljava/lang/Exception; {:try_start_inject_notify .. :try_end_inject_notify} :inject_notify_done

    goto :goto_1

    .line 382
    :cond_3""",
    ),
]


def main() -> None:
    changed = 0
    for path, old, new in REPLACEMENTS:
        if not path.is_file():
            raise SystemExit(f"Missing {path}")
        text = path.read_text(encoding="utf-8")
        if old not in text:
            if new.split("\n")[0] in text and "inject_notify_done" in text:
                continue
            raise SystemExit(f"Pattern not found in {path.name}")
        path.write_text(text.replace(old, new, 1), encoding="utf-8")
        changed += 1
    print(f"APK background inject patch applied ({changed} edits)")


if __name__ == "__main__":
    main()
