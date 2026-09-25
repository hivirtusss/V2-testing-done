#!/usr/bin/env python3
"""Final crash fix — Astik startService everywhere, no ServiceStarter on open."""

from pathlib import Path

ROOT = Path(__file__).resolve().parent / "virtus_decompiled/smali/com/virtus/module"
MAIN = ROOT / "MainActivity.smali"


def main() -> None:
    text = MAIN.read_text()
    text = text.replace(
        "invoke-static {v0, v1}, Lcom/virtus/module/ServiceStarter;->start(Landroid/content/Context;Landroid/content/Intent;)V",
        "invoke-virtual {v0, v1}, Lcom/virtus/module/MainActivity;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;",
    )
    text = text.replace(
        "invoke-static {p1, v1}, Lcom/virtus/module/ServiceStarter;->start(Landroid/content/Context;Landroid/content/Intent;)V",
        "invoke-virtual {p1, v1}, Lcom/virtus/module/MainActivity;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;",
    )
    MAIN.write_text(text)
    print("ServiceStarter removed — Astik startService only")


if __name__ == "__main__":
    main()
