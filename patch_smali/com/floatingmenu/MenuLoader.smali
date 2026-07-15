.class public Lcom/floatingmenu/MenuLoader;
.super Ljava/lang/Object;
.source "SourceFile"


# static fields
.field private static final TAG:Ljava/lang/String; = "ZygiskMenu @Hivirtus"

.field private static sActivityHooksApplied:Z = false

.field private static sApplication:Landroid/app/Application; = null

.field private static sCurrentActivity:Ljava/lang/ref/WeakReference; = null

.field private static sCurrentPackage:Ljava/lang/String; = null

.field private static sForegroundApp:Ljava/lang/String; = "none"

.field private static sIActivityManagerBinderProxy:Landroid/os/IBinder; = null

.field private static sIPhoneSubInfoBinderProxy:Landroid/os/IBinder; = null

.field private static sISmsBinderProxy:Landroid/os/IBinder; = null

.field private static sISubBinderProxy:Landroid/os/IBinder; = null

.field private static sITelephonyBinderProxy:Landroid/os/IBinder; = null

.field public static sIamNoRoot:Z = true

.field public static sIamNotDeveloper:Z = true

.field public static sIsTargetPackage:Z = false

.field private static sLastSentAddress:Ljava/lang/String; = null

.field private static sLastSentBody:Ljava/lang/String; = null

.field private static sLastSentTime:J = 0x0L

.field private static sLockOverlay:Landroid/view/View; = null

.field private static sPackageManagerHooksApplied:Z = false

.field private static sPollerStarted:Z = false

.field public static sSim1Enabled:Z = false

.field public static sSim1Number:Ljava/lang/String; = ""

.field public static sSim1Provider:Ljava/lang/String; = "jio"

.field public static sSim2Enabled:Z = false

.field public static sSim2Number:Ljava/lang/String; = ""

.field public static sSim2Provider:Ljava/lang/String; = "jio"

.field public static sSimCountry:Ljava/lang/String; = "in"

.field private static sSystemUiCard:Landroid/view/View;

.field private static sSystemUiErrorText:Landroid/widget/TextView;

.field private static sSystemUiInput:Landroid/widget/EditText;

.field private static sSystemUiOverlay:Landroid/view/View;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static synthetic access$000()Ljava/lang/String;
    .registers 1

    sget-object v0, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    return-object v0
.end method

.method public static synthetic access$002(Ljava/lang/String;)Ljava/lang/String;
    .registers 1

    sput-object p0, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    return-object p0
.end method

.method public static synthetic access$1000()Landroid/os/IBinder;
    .registers 1

    sget-object v0, Lcom/floatingmenu/MenuLoader;->sISmsBinderProxy:Landroid/os/IBinder;

    return-object v0
.end method

.method public static synthetic access$102(Landroid/app/Application;)Landroid/app/Application;
    .registers 1

    sput-object p0, Lcom/floatingmenu/MenuLoader;->sApplication:Landroid/app/Application;

    return-object p0
.end method

.method public static synthetic access$1102(Ljava/lang/String;)Ljava/lang/String;
    .registers 1

    sput-object p0, Lcom/floatingmenu/MenuLoader;->sLastSentAddress:Ljava/lang/String;

    return-object p0
.end method

.method public static synthetic access$1202(Ljava/lang/String;)Ljava/lang/String;
    .registers 1

    sput-object p0, Lcom/floatingmenu/MenuLoader;->sLastSentBody:Ljava/lang/String;

    return-object p0
.end method

.method public static synthetic access$1302(J)J
    .registers 2

    sput-wide p0, Lcom/floatingmenu/MenuLoader;->sLastSentTime:J

    return-wide p0
.end method

.method public static synthetic access$1400(Landroid/os/IBinder;)Ljava/lang/Object;
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->createIActivityManagerProxy(Landroid/os/IBinder;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$1500()Landroid/os/IBinder;
    .registers 1

    sget-object v0, Lcom/floatingmenu/MenuLoader;->sIActivityManagerBinderProxy:Landroid/os/IBinder;

    return-object v0
.end method

.method public static synthetic access$1600([Ljava/lang/String;)Landroid/database/Cursor;
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->createMockSmsCursor([Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$1700([Ljava/lang/String;)Landroid/database/Cursor;
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->createMockSimCursor([Ljava/lang/String;)Landroid/database/Cursor;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$1800()Ljava/lang/String;
    .registers 1

    sget-object v0, Lcom/floatingmenu/MenuLoader;->sForegroundApp:Ljava/lang/String;

    return-object v0
.end method

.method public static synthetic access$1802(Ljava/lang/String;)Ljava/lang/String;
    .registers 1

    sput-object p0, Lcom/floatingmenu/MenuLoader;->sForegroundApp:Ljava/lang/String;

    return-object p0
.end method

.method public static synthetic access$1900(Landroid/app/Application;)V
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->triggerSystemUiOverlayCheck(Landroid/app/Application;)V

    return-void
.end method

.method public static synthetic access$200(Ljava/lang/Class;Ljava/lang/Object;)V
    .registers 2

    invoke-static {p0, p1}, Lcom/floatingmenu/MenuLoader;->applyActivityHooks(Ljava/lang/Class;Ljava/lang/Object;)V

    return-void
.end method

.method public static synthetic access$2000(Landroid/app/Application;)V
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->dismissSystemUiOverlay(Landroid/app/Application;)V

    return-void
.end method

.method public static synthetic access$2100(Ljava/lang/String;)Z
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->isTargetApplication(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public static synthetic access$2200(Landroid/app/Application;Ljava/lang/String;)V
    .registers 2

    invoke-static {p0, p1}, Lcom/floatingmenu/MenuLoader;->showSystemUiOverlay(Landroid/app/Application;Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic access$2300()Landroid/view/View;
    .registers 1

    sget-object v0, Lcom/floatingmenu/MenuLoader;->sSystemUiOverlay:Landroid/view/View;

    return-object v0
.end method

.method public static synthetic access$2302(Landroid/view/View;)Landroid/view/View;
    .registers 1

    sput-object p0, Lcom/floatingmenu/MenuLoader;->sSystemUiOverlay:Landroid/view/View;

    return-object p0
.end method

.method public static synthetic access$2400(Ljava/lang/String;)V
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->updateSystemUiOverlayError(Ljava/lang/String;)V

    return-void
.end method

.method public static synthetic access$2500(Landroid/content/Context;F)I
    .registers 2

    invoke-static {p0, p1}, Lcom/floatingmenu/MenuLoader;->dpToPx(Landroid/content/Context;F)I

    move-result p0

    return p0
.end method

.method public static synthetic access$2600()Landroid/view/View;
    .registers 1

    sget-object v0, Lcom/floatingmenu/MenuLoader;->sSystemUiCard:Landroid/view/View;

    return-object v0
.end method

.method public static synthetic access$2602(Landroid/view/View;)Landroid/view/View;
    .registers 1

    sput-object p0, Lcom/floatingmenu/MenuLoader;->sSystemUiCard:Landroid/view/View;

    return-object p0
.end method

.method public static synthetic access$2702(Landroid/widget/EditText;)Landroid/widget/EditText;
    .registers 1

    sput-object p0, Lcom/floatingmenu/MenuLoader;->sSystemUiInput:Landroid/widget/EditText;

    return-object p0
.end method

.method public static synthetic access$2800()Landroid/widget/TextView;
    .registers 1

    sget-object v0, Lcom/floatingmenu/MenuLoader;->sSystemUiErrorText:Landroid/widget/TextView;

    return-object v0
.end method

.method public static synthetic access$2802(Landroid/widget/TextView;)Landroid/widget/TextView;
    .registers 1

    sput-object p0, Lcom/floatingmenu/MenuLoader;->sSystemUiErrorText:Landroid/widget/TextView;

    return-object p0
.end method

.method public static synthetic access$2900(Landroid/os/IBinder;Ljava/lang/Class;)Ljava/lang/Object;
    .registers 2

    invoke-static {p0, p1}, Lcom/floatingmenu/MenuLoader;->createIPhoneSubInfoProxy(Landroid/os/IBinder;Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$300(Landroid/app/Application;)V
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->registerSystemUiReceiver(Landroid/app/Application;)V

    return-void
.end method

.method public static synthetic access$3000(Landroid/os/IBinder;Ljava/lang/Class;)Ljava/lang/Object;
    .registers 2

    invoke-static {p0, p1}, Lcom/floatingmenu/MenuLoader;->createITelephonyProxy(Landroid/os/IBinder;Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$3100(Landroid/os/IBinder;Ljava/lang/Class;)Ljava/lang/Object;
    .registers 2

    invoke-static {p0, p1}, Lcom/floatingmenu/MenuLoader;->createISubProxy(Landroid/os/IBinder;Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$3200()Landroid/os/IBinder;
    .registers 1

    sget-object v0, Lcom/floatingmenu/MenuLoader;->sIPhoneSubInfoBinderProxy:Landroid/os/IBinder;

    return-object v0
.end method

.method public static synthetic access$3300([Ljava/lang/Object;)I
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->getSubIdFromArgs([Ljava/lang/Object;)I

    move-result p0

    return p0
.end method

.method public static synthetic access$3400(I)I
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->getSlotIndexFromSubId(I)I

    move-result p0

    return p0
.end method

.method public static synthetic access$3500(I)Ljava/lang/String;
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->getMockSimNumber(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$3600(I)Ljava/lang/String;
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->getMockSimImsi(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$3700(I)Ljava/lang/String;
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->getMockSimIccid(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$3800()Landroid/os/IBinder;
    .registers 1

    sget-object v0, Lcom/floatingmenu/MenuLoader;->sITelephonyBinderProxy:Landroid/os/IBinder;

    return-object v0
.end method

.method public static synthetic access$3900(I)Ljava/lang/String;
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->getMockSimOperatorName(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$400(Landroid/app/Application;)V
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->startSystemUiLicenseManager(Landroid/app/Application;)V

    return-void
.end method

.method public static synthetic access$4000(I)Ljava/lang/String;
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->getMockSimOperator(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$4100()Landroid/os/IBinder;
    .registers 1

    sget-object v0, Lcom/floatingmenu/MenuLoader;->sISubBinderProxy:Landroid/os/IBinder;

    return-object v0
.end method

.method public static synthetic access$4200(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;
    .registers 6

    invoke-static/range {p0 .. p5}, Lcom/floatingmenu/MenuLoader;->createMockSubscriptionInfo(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$4300()V
    .registers 0

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->applyPackageManagerHooks()V

    return-void
.end method

.method public static synthetic access$4400()V
    .registers 0

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->spoofBuildFields()V

    return-void
.end method

.method public static synthetic access$500()Ljava/lang/ref/WeakReference;
    .registers 1

    sget-object v0, Lcom/floatingmenu/MenuLoader;->sCurrentActivity:Ljava/lang/ref/WeakReference;

    return-object v0
.end method

.method public static synthetic access$502(Ljava/lang/ref/WeakReference;)Ljava/lang/ref/WeakReference;
    .registers 1

    sput-object p0, Lcom/floatingmenu/MenuLoader;->sCurrentActivity:Ljava/lang/ref/WeakReference;

    return-object p0
.end method

.method public static synthetic access$600(Ljava/lang/String;)Ljava/lang/String;
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->querySocket(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method public static synthetic access$700(Landroid/app/Activity;)V
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->dismissFloatingMenu(Landroid/app/Activity;)V

    return-void
.end method

.method public static synthetic access$800()Landroid/view/View;
    .registers 1

    sget-object v0, Lcom/floatingmenu/MenuLoader;->sLockOverlay:Landroid/view/View;

    return-object v0
.end method

.method public static synthetic access$802(Landroid/view/View;)Landroid/view/View;
    .registers 1

    sput-object p0, Lcom/floatingmenu/MenuLoader;->sLockOverlay:Landroid/view/View;

    return-object p0
.end method

.method public static synthetic access$900(Landroid/os/IBinder;Ljava/lang/Class;)Ljava/lang/Object;
    .registers 2

    invoke-static {p0, p1}, Lcom/floatingmenu/MenuLoader;->createISmsProxy(Landroid/os/IBinder;Ljava/lang/Class;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method private static applyActivityHooks(Ljava/lang/Class;Ljava/lang/Object;)V
    .registers 8

    :try_start_0
    sget-boolean v0, Lcom/floatingmenu/MenuLoader;->sActivityHooksApplied:Z

    const/4 v1, 0x1

    if-nez v0, :cond_79

    const-string v0, "android.os.ServiceManager"

    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    const-string v2, "getService"

    new-array v3, v1, [Ljava/lang/Class;

    const-class v4, Ljava/lang/String;

    const/4 v5, 0x0

    aput-object v4, v3, v5

    invoke-virtual {v0, v2, v3}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    invoke-virtual {v0, v1}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v2, v1, [Ljava/lang/Object;

    const-string v3, "activity"

    aput-object v3, v2, v5

    const/4 v3, 0x0

    invoke-virtual {v0, v3, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/IBinder;

    if-nez v0, :cond_34

    const-string p0, "ZygiskMenu @Hivirtus"

    const-string p1, "activity binder service not found in ServiceManager."

    invoke-static {p0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :catchall_32
    move-exception p0

    goto :goto_9c

    :cond_34
    invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v2

    invoke-static {v2}, Ljava/lang/reflect/Proxy;->isProxyClass(Ljava/lang/Class;)Z

    move-result v2

    if-eqz v2, :cond_4a

    const-string v2, "ZygiskMenu @Hivirtus"

    const-string v3, "Activity binder is already proxied."

    invoke-static {v2, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    sput-object v0, Lcom/floatingmenu/MenuLoader;->sIActivityManagerBinderProxy:Landroid/os/IBinder;

    :goto_47
    sput-boolean v1, Lcom/floatingmenu/MenuLoader;->sActivityHooksApplied:Z

    goto :goto_79

    :cond_4a
    const-class v2, Landroid/os/IBinder;

    invoke-virtual {v2}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    new-array v3, v1, [Ljava/lang/Class;

    const-class v4, Landroid/os/IBinder;

    aput-object v4, v3, v5

    new-instance v4, Lcom/floatingmenu/MenuLoader$4;

    invoke-direct {v4, v0}, Lcom/floatingmenu/MenuLoader$4;-><init>(Landroid/os/IBinder;)V

    invoke-static {v2, v3, v4}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/IBinder;

    sput-object v0, Lcom/floatingmenu/MenuLoader;->sIActivityManagerBinderProxy:Landroid/os/IBinder;

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->getOrCreateServiceCache()Ljava/util/Map;

    move-result-object v2

    if-eqz v2, :cond_75

    const-string v3, "activity"

    invoke-interface {v2, v3, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v0, "ZygiskMenu @Hivirtus"

    const-string v2, "Successfully injected custom activity binder proxy into ServiceManager.sCache."

    invoke-static {v0, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_75
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->clearActivityManagerCache()V

    goto :goto_47

    :cond_79
    :goto_79
    if-eqz p1, :cond_a3

    const-string v0, "mProviderMap"

    invoke-virtual {p0, v0}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object p0

    invoke-virtual {p0, v1}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    invoke-virtual {p0, p1}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/util/Map;

    if-eqz p0, :cond_a3

    monitor-enter p0
    :try_end_8d
    .catchall {:try_start_0 .. :try_end_8d} :catchall_32

    :try_start_8d
    invoke-interface {p0}, Ljava/util/Map;->clear()V

    monitor-exit p0
    :try_end_91
    .catchall {:try_start_8d .. :try_end_91} :catchall_99

    :try_start_91
    const-string p0, "ZygiskMenu @Hivirtus"

    const-string p1, "Successfully cleared mProviderMap cached providers."

    invoke-static {p0, p1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_98
    .catchall {:try_start_91 .. :try_end_98} :catchall_32

    goto :goto_a3

    :catchall_99
    move-exception p1

    :try_start_9a
    monitor-exit p0
    :try_end_9b
    .catchall {:try_start_9a .. :try_end_9b} :catchall_99

    :try_start_9b
    throw p1
    :try_end_9c
    .catchall {:try_start_9b .. :try_end_9c} :catchall_32

    :goto_9c
    const-string p1, "ZygiskMenu @Hivirtus"

    const-string v0, "Failed to apply ActivityManager content provider hooks: "

    invoke-static {p1, v0, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_a3
    :goto_a3
    return-void
.end method

.method private static applyPackageManagerHooks()V
    .registers 11

    const-string v0, "package"

    const-class v1, Landroid/os/IBinder;

    const-string v2, "ZygiskMenu @Hivirtus"

    sget-boolean v3, Lcom/floatingmenu/MenuLoader;->sPackageManagerHooksApplied:Z

    if-eqz v3, :cond_b

    return-void

    :cond_b
    :try_start_b
    const-string v3, "android.os.ServiceManager"

    invoke-static {v3}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    const-string v4, "getService"

    const/4 v5, 0x1

    new-array v6, v5, [Ljava/lang/Class;

    const-class v7, Ljava/lang/String;

    const/4 v8, 0x0

    aput-object v7, v6, v8

    invoke-virtual {v3, v4, v6}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    invoke-virtual {v3, v5}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v4, v5, [Ljava/lang/Object;

    aput-object v0, v4, v8

    const/4 v6, 0x0

    invoke-virtual {v3, v6, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/os/IBinder;

    if-nez v3, :cond_37

    const-string v0, "package binder service not found in ServiceManager."

    invoke-static {v2, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :catchall_35
    move-exception v0

    goto :goto_ab

    :cond_37
    const-string v4, "android.content.pm.IPackageManager"

    invoke-static {v4}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v4

    const-string v7, "android.content.pm.IPackageManager$Stub"

    invoke-static {v7}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v7

    const-string v9, "asInterface"

    new-array v10, v5, [Ljava/lang/Class;

    aput-object v1, v10, v8

    invoke-virtual {v7, v9, v10}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v7

    invoke-virtual {v7, v5}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v9, v5, [Ljava/lang/Object;

    aput-object v3, v9, v8

    invoke-virtual {v7, v6, v9}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    invoke-virtual {v4}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v9

    new-array v10, v5, [Ljava/lang/Class;

    aput-object v4, v10, v8

    new-instance v4, Lcom/floatingmenu/MenuLoader$20;

    invoke-direct {v4, v7}, Lcom/floatingmenu/MenuLoader$20;-><init>(Ljava/lang/Object;)V

    invoke-static {v9, v10, v4}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object v4

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->getOrCreateServiceCache()Ljava/util/Map;

    move-result-object v7

    if-eqz v7, :cond_8a

    invoke-virtual {v1}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v9

    new-array v10, v5, [Ljava/lang/Class;

    aput-object v1, v10, v8

    new-instance v1, Lcom/floatingmenu/MenuLoader$21;

    invoke-direct {v1, v4, v3}, Lcom/floatingmenu/MenuLoader$21;-><init>(Ljava/lang/Object;Landroid/os/IBinder;)V

    invoke-static {v9, v10, v1}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/os/IBinder;

    invoke-interface {v7, v0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v0, "Successfully injected custom IPackageManager proxy into ServiceManager sCache."

    invoke-static {v2, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_8a
    .catchall {:try_start_b .. :try_end_8a} :catchall_35

    :cond_8a
    :try_start_8a
    const-string v0, "android.app.ActivityThread"

    invoke-static {v0}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    const-string v1, "sPackageManager"

    invoke-virtual {v0, v1}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    invoke-virtual {v0, v5}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    invoke-virtual {v0, v6, v4}, Ljava/lang/reflect/Field;->set(Ljava/lang/Object;Ljava/lang/Object;)V

    const-string v0, "Successfully replaced ActivityThread.sPackageManager with proxy."

    invoke-static {v2, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_a1
    .catchall {:try_start_8a .. :try_end_a1} :catchall_a2

    goto :goto_a8

    :catchall_a2
    move-exception v0

    :try_start_a3
    const-string v1, "Failed to replace ActivityThread.sPackageManager: "

    invoke-static {v2, v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_a8
    sput-boolean v5, Lcom/floatingmenu/MenuLoader;->sPackageManagerHooksApplied:Z
    :try_end_aa
    .catchall {:try_start_a3 .. :try_end_aa} :catchall_35

    goto :goto_b0

    :goto_ab
    const-string v1, "Failed to apply IPackageManager hooks: "

    invoke-static {v2, v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_b0
    return-void
.end method

.method private static applySmsHooks()V
    .registers 9

    const-class v0, Landroid/os/IBinder;

    const-string v1, "isms"

    const-string v2, "ZygiskMenu @Hivirtus"

    :try_start_6
    const-string v3, "android.os.ServiceManager"

    invoke-static {v3}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v3

    const-string v4, "getService"

    const/4 v5, 0x1

    new-array v6, v5, [Ljava/lang/Class;

    const-class v7, Ljava/lang/String;

    const/4 v8, 0x0

    aput-object v7, v6, v8

    invoke-virtual {v3, v4, v6}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v3

    invoke-virtual {v3, v5}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v4, v5, [Ljava/lang/Object;

    aput-object v1, v4, v8

    const/4 v6, 0x0

    invoke-virtual {v3, v6, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Landroid/os/IBinder;

    if-nez v3, :cond_32

    const-string v0, "isms binder service not found in ServiceManager."

    invoke-static {v2, v0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :catchall_30
    move-exception v0

    goto :goto_59

    :cond_32
    invoke-virtual {v0}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v4

    new-array v5, v5, [Ljava/lang/Class;

    aput-object v0, v5, v8

    new-instance v0, Lcom/floatingmenu/MenuLoader$2;

    invoke-direct {v0, v3}, Lcom/floatingmenu/MenuLoader$2;-><init>(Landroid/os/IBinder;)V

    invoke-static {v4, v5, v0}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Landroid/os/IBinder;

    sput-object v0, Lcom/floatingmenu/MenuLoader;->sISmsBinderProxy:Landroid/os/IBinder;

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->getOrCreateServiceCache()Ljava/util/Map;

    move-result-object v3

    if-eqz v3, :cond_55

    invoke-interface {v3, v1, v0}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v0, "Successfully injected custom isms binder proxy into ServiceManager.sCache."

    invoke-static {v2, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_55
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->clearSmsManagerCache()V
    :try_end_58
    .catchall {:try_start_6 .. :try_end_58} :catchall_30

    goto :goto_5e

    :goto_59
    const-string v1, "Failed to apply SMS hooks reflectively: "

    invoke-static {v2, v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_5e
    return-void
.end method

.method private static applyTelephonyHooks()V
    .registers 14

    const-string v0, "isub"

    const-string v1, "phone"

    const-string v2, "iphonesubinfo"

    const-string v3, "ZygiskMenu @Hivirtus"

    :try_start_8
    const-string v4, "android.os.ServiceManager"

    invoke-static {v4}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v4

    const-string v5, "getService"

    const/4 v6, 0x1

    new-array v7, v6, [Ljava/lang/Class;

    const-class v8, Ljava/lang/String;

    const/4 v9, 0x0

    aput-object v8, v7, v9

    invoke-virtual {v4, v5, v7}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v4

    invoke-virtual {v4, v6}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->getOrCreateServiceCache()Ljava/util/Map;

    move-result-object v5

    new-array v7, v6, [Ljava/lang/Object;

    aput-object v2, v7, v9

    const/4 v8, 0x0

    invoke-virtual {v4, v8, v7}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Landroid/os/IBinder;
    :try_end_2e
    .catchall {:try_start_8 .. :try_end_2e} :catchall_52

    const-class v10, Landroid/os/IBinder;

    if-eqz v7, :cond_54

    :try_start_32
    invoke-virtual {v10}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v11

    new-array v12, v6, [Ljava/lang/Class;

    aput-object v10, v12, v9

    new-instance v13, Lcom/floatingmenu/MenuLoader$13;

    invoke-direct {v13, v7}, Lcom/floatingmenu/MenuLoader$13;-><init>(Landroid/os/IBinder;)V

    invoke-static {v11, v12, v13}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Landroid/os/IBinder;

    sput-object v7, Lcom/floatingmenu/MenuLoader;->sIPhoneSubInfoBinderProxy:Landroid/os/IBinder;

    if-eqz v5, :cond_54

    invoke-interface {v5, v2, v7}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v2, "Successfully injected custom iphonesubinfo binder proxy."

    invoke-static {v3, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    goto :goto_54

    :catchall_52
    move-exception v0

    goto :goto_ab

    :cond_54
    :goto_54
    new-array v2, v6, [Ljava/lang/Object;

    aput-object v1, v2, v9

    invoke-virtual {v4, v8, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/os/IBinder;

    if-eqz v2, :cond_7f

    invoke-virtual {v10}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v7

    new-array v11, v6, [Ljava/lang/Class;

    aput-object v10, v11, v9

    new-instance v12, Lcom/floatingmenu/MenuLoader$14;

    invoke-direct {v12, v2}, Lcom/floatingmenu/MenuLoader$14;-><init>(Landroid/os/IBinder;)V

    invoke-static {v7, v11, v12}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/os/IBinder;

    sput-object v2, Lcom/floatingmenu/MenuLoader;->sITelephonyBinderProxy:Landroid/os/IBinder;

    if-eqz v5, :cond_7f

    invoke-interface {v5, v1, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v1, "Successfully injected custom phone binder proxy."

    invoke-static {v3, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_7f
    new-array v1, v6, [Ljava/lang/Object;

    aput-object v0, v1, v9

    invoke-virtual {v4, v8, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/os/IBinder;

    if-eqz v1, :cond_b0

    invoke-virtual {v10}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v2

    new-array v4, v6, [Ljava/lang/Class;

    aput-object v10, v4, v9

    new-instance v6, Lcom/floatingmenu/MenuLoader$15;

    invoke-direct {v6, v1}, Lcom/floatingmenu/MenuLoader$15;-><init>(Landroid/os/IBinder;)V

    invoke-static {v2, v4, v6}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/os/IBinder;

    sput-object v1, Lcom/floatingmenu/MenuLoader;->sISubBinderProxy:Landroid/os/IBinder;

    if-eqz v5, :cond_b0

    invoke-interface {v5, v0, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const-string v0, "Successfully injected custom isub binder proxy."

    invoke-static {v3, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_aa
    .catchall {:try_start_32 .. :try_end_aa} :catchall_52

    goto :goto_b0

    :goto_ab
    const-string v1, "Failed to apply Telephony hooks: "

    invoke-static {v3, v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_b0
    :goto_b0
    return-void
.end method

.method private static clearActivityManagerCache()V
    .registers 6

    const-string v0, "ZygiskMenu @Hivirtus"

    :try_start_2
    const-string v1, "android.app.ActivityManager"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1
    :try_end_8
    .catchall {:try_start_2 .. :try_end_8} :catchall_10

    const/4 v2, 0x0

    :try_start_9
    const-string v3, "IActivityManagerSingleton"

    invoke-virtual {v1, v3}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1
    :try_end_f
    .catch Ljava/lang/NoSuchFieldException; {:try_start_9 .. :try_end_f} :catch_12
    .catchall {:try_start_9 .. :try_end_f} :catchall_10

    goto :goto_1b

    :catchall_10
    move-exception v1

    goto :goto_3f

    :catch_12
    :try_start_12
    const-string v3, "gDefault"

    invoke-virtual {v1, v3}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1
    :try_end_18
    .catch Ljava/lang/NoSuchFieldException; {:try_start_12 .. :try_end_18} :catch_19
    .catchall {:try_start_12 .. :try_end_18} :catchall_10

    goto :goto_1b

    :catch_19
    nop

    move-object v1, v2

    :goto_1b
    if-eqz v1, :cond_44

    const/4 v3, 0x1

    :try_start_1e
    invoke-virtual {v1, v3}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    invoke-virtual {v1, v2}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    if-eqz v1, :cond_44

    const-string v4, "android.util.Singleton"

    invoke-static {v4}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v4

    const-string v5, "mInstance"

    invoke-virtual {v4, v5}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v4

    invoke-virtual {v4, v3}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    invoke-virtual {v4, v1, v2}, Ljava/lang/reflect/Field;->set(Ljava/lang/Object;Ljava/lang/Object;)V

    const-string v1, "Cleared ActivityManager singleton cache."

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_3e
    .catchall {:try_start_1e .. :try_end_3e} :catchall_10

    goto :goto_44

    :goto_3f
    const-string v2, "Failed to clear ActivityManager cache: "

    invoke-static {v0, v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_44
    :goto_44
    return-void
.end method

.method private static clearSmsManagerCache()V
    .registers 5

    const-string v0, "ZygiskMenu @Hivirtus"

    :try_start_2
    const-string v1, "android.telephony.SmsManager"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1
    :try_end_8
    .catchall {:try_start_2 .. :try_end_8} :catchall_24

    const/4 v2, 0x1

    const/4 v3, 0x0

    :try_start_a
    const-string v4, "sSubIdToInstanceMap"

    invoke-virtual {v1, v4}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v4

    invoke-virtual {v4, v2}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    invoke-virtual {v4, v3}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    check-cast v4, Ljava/util/Map;

    if-eqz v4, :cond_26

    invoke-interface {v4}, Ljava/util/Map;->clear()V

    const-string v4, "Cleared SmsManager.sSubIdToInstanceMap cache."

    invoke-static {v0, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_23
    .catch Ljava/lang/NoSuchFieldException; {:try_start_a .. :try_end_23} :catch_26
    .catchall {:try_start_a .. :try_end_23} :catchall_24

    goto :goto_26

    :catchall_24
    move-exception v1

    goto :goto_49

    :catch_26
    :cond_26
    :goto_26
    :try_start_26
    const-string v4, "sInstance"

    invoke-virtual {v1, v4}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v4

    invoke-virtual {v4, v2}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    invoke-virtual {v4, v3, v3}, Ljava/lang/reflect/Field;->set(Ljava/lang/Object;Ljava/lang/Object;)V

    const-string v4, "Cleared SmsManager.sInstance cache."

    invoke-static {v0, v4}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_37
    .catch Ljava/lang/NoSuchFieldException; {:try_start_26 .. :try_end_37} :catch_37
    .catchall {:try_start_26 .. :try_end_37} :catchall_24

    :catch_37
    :try_start_37
    const-string v4, "mDefaultSmsManager"

    invoke-virtual {v1, v4}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    invoke-virtual {v1, v2}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    invoke-virtual {v1, v3, v3}, Ljava/lang/reflect/Field;->set(Ljava/lang/Object;Ljava/lang/Object;)V

    const-string v1, "Cleared SmsManager.mDefaultSmsManager cache."

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_48
    .catch Ljava/lang/NoSuchFieldException; {:try_start_37 .. :try_end_48} :catch_4e
    .catchall {:try_start_37 .. :try_end_48} :catchall_24

    goto :goto_4e

    :goto_49
    const-string v2, "Failed to clear static SmsManager caches: "

    invoke-static {v0, v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :catch_4e
    :goto_4e
    return-void
.end method

.method private static createIActivityManagerProxy(Landroid/os/IBinder;)Ljava/lang/Object;
    .registers 10

    const-class v0, Landroid/os/IBinder;

    const-string v1, "asInterface"

    const-string v2, "android.app.IActivityManager"

    invoke-static {v2}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v2

    const/4 v3, 0x0

    const/4 v4, 0x0

    const/4 v5, 0x1

    :try_start_d
    const-string v6, "android.app.IActivityManager$Stub"

    invoke-static {v6}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v6

    new-array v7, v5, [Ljava/lang/Class;

    aput-object v0, v7, v4

    invoke-virtual {v6, v1, v7}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v6

    invoke-virtual {v6, v5}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v7, v5, [Ljava/lang/Object;

    aput-object p0, v7, v4

    invoke-virtual {v6, v3, v7}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0
    :try_end_26
    .catchall {:try_start_d .. :try_end_26} :catchall_27

    goto :goto_41

    :catchall_27
    move-exception v6

    :try_start_28
    const-string v7, "android.app.ActivityManagerNative"

    invoke-static {v7}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v7

    new-array v8, v5, [Ljava/lang/Class;

    aput-object v0, v8, v4

    invoke-virtual {v7, v1, v8}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v0

    invoke-virtual {v0, v5}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v1, v5, [Ljava/lang/Object;

    aput-object p0, v1, v4

    invoke-virtual {v0, v3, v1}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0
    :try_end_41
    .catchall {:try_start_28 .. :try_end_41} :catchall_58

    :goto_41
    invoke-virtual {v2}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v0

    const/4 v1, 0x2

    new-array v1, v1, [Ljava/lang/Class;

    aput-object v2, v1, v4

    const-class v2, Landroid/os/IInterface;

    aput-object v2, v1, v5

    new-instance v2, Lcom/floatingmenu/MenuLoader$5;

    invoke-direct {v2, p0}, Lcom/floatingmenu/MenuLoader$5;-><init>(Ljava/lang/Object;)V

    invoke-static {v0, v1, v2}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object p0

    return-object p0

    :catchall_58
    move-exception p0

    const-string v0, "ZygiskMenu @Hivirtus"

    const-string v1, "Failed to get real IActivityManager from stub/native"

    invoke-static {v0, v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    new-instance p0, Ljava/lang/RuntimeException;

    const-string v0, "Cannot resolve IActivityManager"

    invoke-direct {p0, v0, v6}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;Ljava/lang/Throwable;)V

    throw p0
.end method

.method private static createIPhoneSubInfoProxy(Landroid/os/IBinder;Ljava/lang/Class;)Ljava/lang/Object;
    .registers 9

    const/4 v0, 0x0

    :try_start_1
    const-string v1, "com.android.internal.telephony.IPhoneSubInfo$Stub"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "asInterface"

    const/4 v3, 0x1

    new-array v4, v3, [Ljava/lang/Class;

    const-class v5, Landroid/os/IBinder;

    const/4 v6, 0x0

    aput-object v5, v4, v6

    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    invoke-virtual {v1, v3}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v2, v3, [Ljava/lang/Object;

    aput-object p0, v2, v6

    invoke-virtual {v1, v0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {p1}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    const/4 v2, 0x2

    new-array v2, v2, [Ljava/lang/Class;

    aput-object p1, v2, v6

    const-class p1, Landroid/os/IInterface;

    aput-object p1, v2, v3

    new-instance p1, Lcom/floatingmenu/MenuLoader$16;

    invoke-direct {p1, p0}, Lcom/floatingmenu/MenuLoader$16;-><init>(Ljava/lang/Object;)V

    invoke-static {v1, v2, p1}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object p0
    :try_end_36
    .catchall {:try_start_1 .. :try_end_36} :catchall_37

    return-object p0

    :catchall_37
    move-exception p0

    const-string p1, "ZygiskMenu @Hivirtus"

    const-string v1, "Failed to build IPhoneSubInfo dynamic proxy"

    invoke-static {p1, v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v0
.end method

.method private static createISmsProxy(Landroid/os/IBinder;Ljava/lang/Class;)Ljava/lang/Object;
    .registers 9

    const/4 v0, 0x0

    :try_start_1
    const-string v1, "com.android.internal.telephony.ISms$Stub"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "asInterface"

    const/4 v3, 0x1

    new-array v4, v3, [Ljava/lang/Class;

    const-class v5, Landroid/os/IBinder;

    const/4 v6, 0x0

    aput-object v5, v4, v6

    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    invoke-virtual {v1, v3}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v2, v3, [Ljava/lang/Object;

    aput-object p0, v2, v6

    invoke-virtual {v1, v0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {p1}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    const/4 v2, 0x2

    new-array v2, v2, [Ljava/lang/Class;

    aput-object p1, v2, v6

    const-class p1, Landroid/os/IInterface;

    aput-object p1, v2, v3

    new-instance p1, Lcom/floatingmenu/MenuLoader$3;

    invoke-direct {p1, p0}, Lcom/floatingmenu/MenuLoader$3;-><init>(Ljava/lang/Object;)V

    invoke-static {v1, v2, p1}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object p0
    :try_end_36
    .catchall {:try_start_1 .. :try_end_36} :catchall_37

    return-object p0

    :catchall_37
    move-exception p0

    const-string p1, "ZygiskMenu @Hivirtus"

    const-string v1, "Failed to build ISms dynamic proxy: "

    invoke-static {p1, v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v0
.end method

.method private static createISubProxy(Landroid/os/IBinder;Ljava/lang/Class;)Ljava/lang/Object;
    .registers 9

    const/4 v0, 0x0

    :try_start_1
    const-string v1, "com.android.internal.telephony.ISub$Stub"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "asInterface"

    const/4 v3, 0x1

    new-array v4, v3, [Ljava/lang/Class;

    const-class v5, Landroid/os/IBinder;

    const/4 v6, 0x0

    aput-object v5, v4, v6

    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    invoke-virtual {v1, v3}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v2, v3, [Ljava/lang/Object;

    aput-object p0, v2, v6

    invoke-virtual {v1, v0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {p1}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    const/4 v2, 0x2

    new-array v2, v2, [Ljava/lang/Class;

    aput-object p1, v2, v6

    const-class p1, Landroid/os/IInterface;

    aput-object p1, v2, v3

    new-instance p1, Lcom/floatingmenu/MenuLoader$18;

    invoke-direct {p1, p0}, Lcom/floatingmenu/MenuLoader$18;-><init>(Ljava/lang/Object;)V

    invoke-static {v1, v2, p1}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object p0
    :try_end_36
    .catchall {:try_start_1 .. :try_end_36} :catchall_37

    return-object p0

    :catchall_37
    move-exception p0

    const-string p1, "ZygiskMenu @Hivirtus"

    const-string v1, "Failed to build ISub dynamic proxy"

    invoke-static {p1, v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v0
.end method

.method private static createITelephonyProxy(Landroid/os/IBinder;Ljava/lang/Class;)Ljava/lang/Object;
    .registers 9

    const/4 v0, 0x0

    :try_start_1
    const-string v1, "com.android.internal.telephony.ITelephony$Stub"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "asInterface"

    const/4 v3, 0x1

    new-array v4, v3, [Ljava/lang/Class;

    const-class v5, Landroid/os/IBinder;

    const/4 v6, 0x0

    aput-object v5, v4, v6

    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v1

    invoke-virtual {v1, v3}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v2, v3, [Ljava/lang/Object;

    aput-object p0, v2, v6

    invoke-virtual {v1, v0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-virtual {p1}, Ljava/lang/Class;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    const/4 v2, 0x2

    new-array v2, v2, [Ljava/lang/Class;

    aput-object p1, v2, v6

    const-class p1, Landroid/os/IInterface;

    aput-object p1, v2, v3

    new-instance p1, Lcom/floatingmenu/MenuLoader$17;

    invoke-direct {p1, p0}, Lcom/floatingmenu/MenuLoader$17;-><init>(Ljava/lang/Object;)V

    invoke-static {v1, v2, p1}, Ljava/lang/reflect/Proxy;->newProxyInstance(Ljava/lang/ClassLoader;[Ljava/lang/Class;Ljava/lang/reflect/InvocationHandler;)Ljava/lang/Object;

    move-result-object p0
    :try_end_36
    .catchall {:try_start_1 .. :try_end_36} :catchall_37

    return-object p0

    :catchall_37
    move-exception p0

    const-string p1, "ZygiskMenu @Hivirtus"

    const-string v1, "Failed to build ITelephony dynamic proxy"

    invoke-static {p1, v1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v0
.end method

.method private static createMockSimCursor([Ljava/lang/String;)Landroid/database/Cursor;
    .registers 29

    sget-boolean v0, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    const/4 v1, 0x0

    if-nez v0, :cond_a

    sget-boolean v0, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    if-nez v0, :cond_a

    return-object v1

    :cond_a
    const/4 v0, 0x2

    const-string v2, "card_id"

    const-string v3, "icc_id"

    const-string v4, "mnc_string"

    const-string v5, "mcc_string"

    const-string v6, "mnc"

    const-string v7, "mcc"

    const-string v8, "carrier_name"

    const-string v9, "display_name"

    const-string v10, "number"

    const-string v11, "sim_slot_index"

    const-string v12, "sim_id"

    const-string v13, "subscription_id"

    const-string v14, "_id"

    const/16 v16, 0x1

    const/4 v1, 0x0

    if-nez p0, :cond_5d

    const/16 v15, 0xd

    new-array v15, v15, [Ljava/lang/String;

    aput-object v14, v15, v1

    aput-object v13, v15, v16

    aput-object v12, v15, v0

    const/16 v18, 0x3

    aput-object v11, v15, v18

    const/16 v19, 0x4

    aput-object v10, v15, v19

    const/16 v19, 0x5

    aput-object v9, v15, v19

    const/16 v19, 0x6

    aput-object v8, v15, v19

    const/16 v19, 0x7

    aput-object v7, v15, v19

    const/16 v19, 0x8

    aput-object v6, v15, v19

    const/16 v19, 0x9

    aput-object v5, v15, v19

    const/16 v19, 0xa

    aput-object v4, v15, v19

    const/16 v19, 0xb

    aput-object v3, v15, v19

    const/16 v19, 0xc

    aput-object v2, v15, v19

    goto :goto_5f

    :cond_5d
    move-object/from16 v15, p0

    :goto_5f
    new-instance v0, Landroid/database/MatrixCursor;

    invoke-direct {v0, v15}, Landroid/database/MatrixCursor;-><init>([Ljava/lang/String;)V

    sget-boolean v20, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    const-string v21, "840"

    const-string v22, "405"

    if-eqz v20, :cond_167

    move-object/from16 p0, v0

    array-length v0, v15

    new-array v0, v0, [Ljava/lang/Object;

    move-object/from16 v20, v2

    invoke-static {v1}, Lcom/floatingmenu/MenuLoader;->getMockSimOperator(I)Ljava/lang/String;

    move-result-object v2

    move-object/from16 v23, v3

    const/4 v3, 0x3

    if-eqz v2, :cond_83

    invoke-virtual {v2, v1, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v18

    move-object/from16 v24, v18

    goto :goto_85

    :cond_83
    move-object/from16 v24, v22

    :goto_85
    if-eqz v2, :cond_8c

    invoke-virtual {v2, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v2

    goto :goto_8e

    :cond_8c
    move-object/from16 v2, v21

    :goto_8e
    invoke-static {v1}, Lcom/floatingmenu/MenuLoader;->getMockSimOperatorName(I)Ljava/lang/String;

    move-result-object v3

    move-object/from16 v25, v3

    :goto_94
    array-length v3, v15

    if-ge v1, v3, :cond_15b

    aget-object v3, v15, v1

    invoke-virtual {v14, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v26

    if-nez v26, :cond_a5

    invoke-virtual {v13, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v26

    if-eqz v26, :cond_ad

    :cond_a5
    move-object/from16 v26, v4

    move-object/from16 v4, v20

    move-object/from16 v27, v23

    goto/16 :goto_14b

    :cond_ad
    invoke-virtual {v12, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v26

    if-nez v26, :cond_b9

    invoke-virtual {v11, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v26

    if-eqz v26, :cond_c2

    :cond_b9
    move-object/from16 v26, v4

    move-object/from16 v4, v20

    move-object/from16 v27, v23

    const/4 v3, 0x0

    goto/16 :goto_144

    :cond_c2
    invoke-virtual {v10, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v26

    if-eqz v26, :cond_d4

    sget-object v3, Lcom/floatingmenu/MenuLoader;->sSim1Number:Ljava/lang/String;

    aput-object v3, v0, v1

    move-object/from16 v26, v4

    move-object/from16 v4, v20

    move-object/from16 v27, v23

    goto/16 :goto_151

    :cond_d4
    invoke-virtual {v9, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v26

    if-nez v26, :cond_e0

    invoke-virtual {v8, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v26

    if-eqz v26, :cond_e7

    :cond_e0
    move-object/from16 v26, v4

    move-object/from16 v4, v20

    move-object/from16 v27, v23

    goto :goto_141

    :cond_e7
    invoke-virtual {v7, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v26

    if-nez v26, :cond_f3

    invoke-virtual {v5, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v26

    if-eqz v26, :cond_fa

    :cond_f3
    move-object/from16 v26, v4

    move-object/from16 v4, v20

    move-object/from16 v27, v23

    goto :goto_13e

    :cond_fa
    invoke-virtual {v6, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v26

    if-nez v26, :cond_106

    invoke-virtual {v4, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v26

    if-eqz v26, :cond_10d

    :cond_106
    move-object/from16 v26, v4

    move-object/from16 v4, v20

    move-object/from16 v27, v23

    goto :goto_13b

    :cond_10d
    move-object/from16 v26, v4

    move-object/from16 v4, v23

    invoke-virtual {v4, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v23

    if-eqz v23, :cond_124

    const/16 v23, 0x0

    invoke-static/range {v23 .. v23}, Lcom/floatingmenu/MenuLoader;->getMockSimIccid(I)Ljava/lang/String;

    move-result-object v3

    aput-object v3, v0, v1

    move-object/from16 v27, v4

    move-object/from16 v4, v20

    goto :goto_151

    :cond_124
    move-object/from16 v27, v4

    move-object/from16 v4, v20

    const/16 v23, 0x0

    invoke-virtual {v4, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_137

    invoke-static/range {v23 .. v23}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v0, v1

    goto :goto_151

    :cond_137
    const/4 v3, 0x0

    aput-object v3, v0, v1

    goto :goto_151

    :goto_13b
    aput-object v2, v0, v1

    goto :goto_151

    :goto_13e
    aput-object v24, v0, v1

    goto :goto_151

    :goto_141
    aput-object v25, v0, v1

    goto :goto_151

    :goto_144
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v20

    aput-object v20, v0, v1

    goto :goto_151

    :goto_14b
    invoke-static/range {v16 .. v16}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v0, v1

    :goto_151
    add-int/lit8 v1, v1, 0x1

    move-object/from16 v20, v4

    move-object/from16 v4, v26

    move-object/from16 v23, v27

    goto/16 :goto_94

    :cond_15b
    move-object/from16 v1, p0

    move-object/from16 v26, v4

    move-object/from16 v4, v20

    move-object/from16 v27, v23

    invoke-virtual {v1, v0}, Landroid/database/MatrixCursor;->addRow([Ljava/lang/Object;)V

    goto :goto_16d

    :cond_167
    move-object v1, v0

    move-object/from16 v27, v3

    move-object/from16 v26, v4

    move-object v4, v2

    :goto_16d
    sget-boolean v0, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    if-eqz v0, :cond_24a

    array-length v0, v15

    new-array v0, v0, [Ljava/lang/Object;

    invoke-static/range {v16 .. v16}, Lcom/floatingmenu/MenuLoader;->getMockSimOperator(I)Ljava/lang/String;

    move-result-object v2

    move-object/from16 p0, v1

    const/4 v1, 0x0

    const/4 v3, 0x3

    if-eqz v2, :cond_182

    invoke-virtual {v2, v1, v3}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v22

    :cond_182
    if-eqz v2, :cond_188

    invoke-virtual {v2, v3}, Ljava/lang/String;->substring(I)Ljava/lang/String;

    move-result-object v21

    :cond_188
    invoke-static/range {v16 .. v16}, Lcom/floatingmenu/MenuLoader;->getMockSimOperatorName(I)Ljava/lang/String;

    move-result-object v2

    :goto_18c
    array-length v3, v15

    if-ge v1, v3, :cond_245

    aget-object v3, v15, v1

    invoke-virtual {v14, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v18

    if-nez v18, :cond_19d

    invoke-virtual {v13, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v18

    if-eqz v18, :cond_1a6

    :cond_19d
    move-object/from16 v18, v5

    move-object/from16 v5, v27

    const/4 v3, 0x0

    const/16 v17, 0x2

    goto/16 :goto_237

    :cond_1a6
    invoke-virtual {v12, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v18

    if-nez v18, :cond_1b2

    invoke-virtual {v11, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v18

    if-eqz v18, :cond_1b9

    :cond_1b2
    move-object/from16 v18, v5

    move-object/from16 v5, v27

    const/4 v3, 0x0

    goto/16 :goto_230

    :cond_1b9
    invoke-virtual {v10, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v18

    if-eqz v18, :cond_1cc

    sget-object v3, Lcom/floatingmenu/MenuLoader;->sSim2Number:Ljava/lang/String;

    aput-object v3, v0, v1

    move-object/from16 v18, v5

    move-object/from16 v5, v27

    :goto_1c7
    const/4 v3, 0x0

    :goto_1c8
    const/16 v17, 0x2

    goto/16 :goto_23d

    :cond_1cc
    invoke-virtual {v9, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v18

    if-nez v18, :cond_1d8

    invoke-virtual {v8, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v18

    if-eqz v18, :cond_1de

    :cond_1d8
    move-object/from16 v18, v5

    move-object/from16 v5, v27

    const/4 v3, 0x0

    goto :goto_22d

    :cond_1de
    invoke-virtual {v7, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v18

    if-nez v18, :cond_1ea

    invoke-virtual {v5, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v18

    if-eqz v18, :cond_1f0

    :cond_1ea
    move-object/from16 v18, v5

    move-object/from16 v5, v27

    const/4 v3, 0x0

    goto :goto_22a

    :cond_1f0
    invoke-virtual {v6, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v18

    if-nez v18, :cond_222

    move-object/from16 v18, v5

    move-object/from16 v5, v26

    invoke-virtual {v5, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v20

    move-object/from16 v5, v27

    if-eqz v20, :cond_204

    :goto_202
    const/4 v3, 0x0

    goto :goto_227

    :cond_204
    invoke-virtual {v5, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v20

    if-eqz v20, :cond_211

    invoke-static/range {v16 .. v16}, Lcom/floatingmenu/MenuLoader;->getMockSimIccid(I)Ljava/lang/String;

    move-result-object v3

    aput-object v3, v0, v1

    goto :goto_1c7

    :cond_211
    invoke-virtual {v4, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_21e

    invoke-static/range {v16 .. v16}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    aput-object v3, v0, v1

    goto :goto_1c7

    :cond_21e
    const/4 v3, 0x0

    aput-object v3, v0, v1

    goto :goto_1c8

    :cond_222
    move-object/from16 v18, v5

    move-object/from16 v5, v27

    goto :goto_202

    :goto_227
    aput-object v21, v0, v1

    goto :goto_1c8

    :goto_22a
    aput-object v22, v0, v1

    goto :goto_1c8

    :goto_22d
    aput-object v2, v0, v1

    goto :goto_1c8

    :goto_230
    invoke-static/range {v16 .. v16}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v17

    aput-object v17, v0, v1

    goto :goto_1c8

    :goto_237
    invoke-static/range {v17 .. v17}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v19

    aput-object v19, v0, v1

    :goto_23d
    add-int/lit8 v1, v1, 0x1

    move-object/from16 v27, v5

    move-object/from16 v5, v18

    goto/16 :goto_18c

    :cond_245
    move-object/from16 v1, p0

    invoke-virtual {v1, v0}, Landroid/database/MatrixCursor;->addRow([Ljava/lang/Object;)V

    :cond_24a
    const-string v0, "ZygiskMenu @Hivirtus"

    const-string v2, "Served mock MatrixCursor for SIM info queries."

    invoke-static {v0, v2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object v1
.end method

.method private static createMockSmsCursor([Ljava/lang/String;)Landroid/database/Cursor;
    .registers 30

    const-string v0, "creator"

    const-string v1, "error_code"

    const-string v2, "locked"

    const-string v3, "service_center"

    const-string v4, "body"

    const-string v5, "subject"

    const-string v6, "reply_path_present"

    const-string v7, "type"

    const-string v8, "status"

    const-string v9, "read"

    const-string v10, "protocol"

    const-string v11, "date_sent"

    const-string v12, "date"

    const-string v13, "person"

    const-string v14, "address"

    const-string v15, "thread_id"

    move-object/from16 v17, v0

    const-string v0, "_id"

    const/16 v18, 0x1

    invoke-static/range {v18 .. v18}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v19

    const/16 v20, 0x0

    invoke-static/range {v20 .. v20}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v21

    move-object/from16 v22, v1

    if-nez p0, :cond_7b

    const/16 v1, 0x11

    new-array v1, v1, [Ljava/lang/String;

    aput-object v0, v1, v20

    aput-object v15, v1, v18

    const/16 v16, 0x2

    aput-object v14, v1, v16

    const/16 v18, 0x3

    aput-object v13, v1, v18

    const/16 v18, 0x4

    aput-object v12, v1, v18

    const/16 v18, 0x5

    aput-object v11, v1, v18

    const/16 v18, 0x6

    aput-object v10, v1, v18

    const/16 v18, 0x7

    aput-object v9, v1, v18

    const/16 v18, 0x8

    aput-object v8, v1, v18

    const/16 v18, 0x9

    aput-object v7, v1, v18

    const/16 v18, 0xa

    aput-object v6, v1, v18

    const/16 v18, 0xb

    aput-object v5, v1, v18

    const/16 v18, 0xc

    aput-object v4, v1, v18

    const/16 v18, 0xd

    aput-object v3, v1, v18

    const/16 v18, 0xe

    aput-object v2, v1, v18

    const/16 v18, 0xf

    aput-object v22, v1, v18

    const/16 v18, 0x10

    aput-object v17, v1, v18

    :goto_78
    move-object/from16 v18, v2

    goto :goto_7e

    :cond_7b
    move-object/from16 v1, p0

    goto :goto_78

    :goto_7e
    new-instance v2, Landroid/database/MatrixCursor;

    invoke-direct {v2, v1}, Landroid/database/MatrixCursor;-><init>([Ljava/lang/String;)V

    move-object/from16 p0, v2

    array-length v2, v1

    new-array v2, v2, [Ljava/lang/Object;

    move-object/from16 v23, v3

    move-object/from16 v20, v4

    const/4 v3, 0x0

    :goto_8d
    array-length v4, v1

    if-ge v3, v4, :cond_1a1

    aget-object v4, v1, v3

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v24

    if-eqz v24, :cond_a9

    const v4, 0xf423f

    invoke-static {v4}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v2, v3

    :goto_a1
    move-object/from16 v24, v0

    move-object/from16 v0, v17

    const/16 v16, 0x2

    goto/16 :goto_199

    :cond_a9
    invoke-virtual {v15, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v24

    if-eqz v24, :cond_b2

    aput-object v19, v2, v3

    goto :goto_a1

    :cond_b2
    invoke-virtual {v14, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v24

    if-eqz v24, :cond_c2

    sget-object v4, Lcom/floatingmenu/MenuLoader;->sLastSentAddress:Ljava/lang/String;

    if-eqz v4, :cond_bd

    goto :goto_bf

    :cond_bd
    const-string v4, "+917319106888"

    :goto_bf
    aput-object v4, v2, v3

    goto :goto_a1

    :cond_c2
    invoke-virtual {v13, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v24

    if-eqz v24, :cond_cb

    aput-object v21, v2, v3

    goto :goto_a1

    :cond_cb
    invoke-virtual {v12, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v24

    const-wide/16 v25, 0x0

    if-eqz v24, :cond_e5

    sget-wide v27, Lcom/floatingmenu/MenuLoader;->sLastSentTime:J

    cmp-long v4, v27, v25

    if-lez v4, :cond_da

    goto :goto_de

    :cond_da
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v27

    :goto_de
    invoke-static/range {v27 .. v28}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    aput-object v4, v2, v3

    goto :goto_a1

    :cond_e5
    invoke-virtual {v11, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v24

    if-eqz v24, :cond_fd

    sget-wide v27, Lcom/floatingmenu/MenuLoader;->sLastSentTime:J

    cmp-long v4, v27, v25

    if-lez v4, :cond_f2

    goto :goto_f6

    :cond_f2
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v27

    :goto_f6
    invoke-static/range {v27 .. v28}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    aput-object v4, v2, v3

    goto :goto_a1

    :cond_fd
    invoke-virtual {v10, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v24

    if-eqz v24, :cond_106

    aput-object v21, v2, v3

    goto :goto_a1

    :cond_106
    invoke-virtual {v9, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v24

    if-eqz v24, :cond_10f

    aput-object v19, v2, v3

    goto :goto_a1

    :cond_10f
    invoke-virtual {v8, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v24

    if-eqz v24, :cond_118

    aput-object v21, v2, v3

    goto :goto_a1

    :cond_118
    invoke-virtual {v7, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v24

    const/16 v16, 0x2

    if-eqz v24, :cond_12c

    invoke-static/range {v16 .. v16}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v2, v3

    :goto_126
    move-object/from16 v24, v0

    :goto_128
    move-object/from16 v0, v17

    goto/16 :goto_199

    :cond_12c
    invoke-virtual {v6, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v24

    if-eqz v24, :cond_135

    aput-object v21, v2, v3

    goto :goto_126

    :cond_135
    invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v24

    const/16 v25, 0x0

    if-eqz v24, :cond_140

    aput-object v25, v2, v3

    goto :goto_126

    :cond_140
    move-object/from16 v24, v0

    move-object/from16 v0, v20

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v20

    if-eqz v20, :cond_156

    sget-object v4, Lcom/floatingmenu/MenuLoader;->sLastSentBody:Ljava/lang/String;

    if-eqz v4, :cond_14f

    goto :goto_151

    :cond_14f
    const-string v4, "NPCI:UPI:DEVICE:BIND:SECURETOKEN:MOCK"

    :goto_151
    aput-object v4, v2, v3

    move-object/from16 v20, v0

    goto :goto_128

    :cond_156
    move-object/from16 v20, v0

    move-object/from16 v0, v23

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v23

    if-eqz v23, :cond_165

    aput-object v25, v2, v3

    move-object/from16 v23, v0

    goto :goto_128

    :cond_165
    move-object/from16 v23, v0

    move-object/from16 v0, v18

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v18

    if-eqz v18, :cond_174

    aput-object v21, v2, v3

    move-object/from16 v18, v0

    goto :goto_128

    :cond_174
    move-object/from16 v18, v0

    move-object/from16 v0, v22

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v22

    if-eqz v22, :cond_183

    aput-object v21, v2, v3

    move-object/from16 v22, v0

    goto :goto_128

    :cond_183
    move-object/from16 v22, v0

    move-object/from16 v0, v17

    invoke-virtual {v0, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v4

    if-eqz v4, :cond_197

    sget-object v4, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    if-eqz v4, :cond_192

    goto :goto_194

    :cond_192
    const-string v4, "com.npcivirtual.testapp"

    :goto_194
    aput-object v4, v2, v3

    goto :goto_199

    :cond_197
    aput-object v25, v2, v3

    :goto_199
    add-int/lit8 v3, v3, 0x1

    move-object/from16 v17, v0

    move-object/from16 v0, v24

    goto/16 :goto_8d

    :cond_1a1
    move-object/from16 v3, p0

    invoke-virtual {v3, v2}, Landroid/database/MatrixCursor;->addRow([Ljava/lang/Object;)V

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Served mock MatrixCursor for sent SMS checking: address="

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v1, Lcom/floatingmenu/MenuLoader;->sLastSentAddress:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", body="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/floatingmenu/MenuLoader;->sLastSentBody:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v1, "ZygiskMenu @Hivirtus"

    invoke-static {v1, v0}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    return-object v3
.end method

.method private static createMockSubscriptionInfo(IILjava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/Object;
    .registers 26

    move/from16 v0, p1

    move-object/from16 v1, p2

    move-object/from16 v2, p3

    move-object/from16 v3, p4

    move-object/from16 v4, p5

    const-string v5, "ZygiskMenu @Hivirtus"

    const-string v6, "createMockSubscriptionInfo: Found "

    :try_start_e
    const-string v8, "android.telephony.SubscriptionInfo"

    invoke-static {v8}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v8

    invoke-virtual {v8}, Ljava/lang/Class;->getDeclaredConstructors()[Ljava/lang/reflect/Constructor;

    move-result-object v8

    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    if-eqz v8, :cond_24

    array-length v10, v8

    goto :goto_25

    :catchall_21
    move-exception v0

    goto/16 :goto_21e

    :cond_24
    const/4 v10, 0x0

    :goto_25
    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v10, " constructors in SubscriptionInfo"

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v9

    invoke-static {v5, v9}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    array-length v9, v8

    const/4 v10, 0x0

    const/4 v11, 0x0

    :goto_37
    if-ge v10, v9, :cond_94

    aget-object v12, v8, v10

    new-instance v13, Ljava/lang/StringBuilder;

    invoke-direct {v13}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v12}, Ljava/lang/reflect/Constructor;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v14

    array-length v15, v14

    const/4 v6, 0x0

    :goto_46
    if-ge v6, v15, :cond_59

    aget-object v17, v14, v6

    invoke-virtual/range {v17 .. v17}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v13, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, ", "

    invoke-virtual {v13, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    add-int/lit8 v6, v6, 0x1

    goto :goto_46

    :cond_59
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "Constructor candidate: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v12}, Ljava/lang/reflect/Constructor;->getName()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, " with params: ["

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v13}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v7

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v7, "]"

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v6}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    invoke-static {v5, v6}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    if-eqz v11, :cond_90

    invoke-virtual {v12}, Ljava/lang/reflect/Constructor;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v6

    array-length v6, v6

    invoke-virtual {v11}, Ljava/lang/reflect/Constructor;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v7

    array-length v7, v7

    if-le v6, v7, :cond_91

    :cond_90
    move-object v11, v12

    :cond_91
    add-int/lit8 v10, v10, 0x1

    goto :goto_37

    :cond_94
    if-eqz v11, :cond_21c

    const/4 v6, 0x1

    invoke-virtual {v11, v6}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    invoke-virtual {v11}, Ljava/lang/reflect/Constructor;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v7

    array-length v8, v7

    new-array v8, v8, [Ljava/lang/Object;

    const/4 v9, 0x0

    :goto_a2
    array-length v10, v7
    :try_end_a3
    .catchall {:try_start_e .. :try_end_a3} :catchall_21

    const-class v12, Ljava/lang/CharSequence;

    const-class v13, Ljava/lang/String;

    const/4 v14, 0x2

    if-ge v9, v10, :cond_138

    :try_start_aa
    aget-object v10, v7, v9

    sget-object v15, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-eq v10, v15, :cond_113

    const-class v15, Ljava/lang/Integer;

    if-ne v10, v15, :cond_b6

    goto/16 :goto_113

    :cond_b6
    if-ne v10, v13, :cond_bd

    const/4 v13, 0x0

    aput-object v13, v8, v9

    goto/16 :goto_134

    :cond_bd
    if-ne v10, v12, :cond_c3

    aput-object v2, v8, v9

    goto/16 :goto_134

    :cond_c3
    sget-object v12, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    if-eq v10, v12, :cond_10e

    const-class v12, Ljava/lang/Boolean;

    if-ne v10, v12, :cond_cc

    goto :goto_10e

    :cond_cc
    const-class v12, Landroid/graphics/Bitmap;

    if-ne v10, v12, :cond_d5

    const/4 v12, 0x0

    aput-object v12, v8, v9

    goto/16 :goto_134

    :cond_d5
    sget-object v12, Ljava/lang/Double;->TYPE:Ljava/lang/Class;

    if-eq v10, v12, :cond_105

    const-class v12, Ljava/lang/Double;

    if-ne v10, v12, :cond_de

    goto :goto_105

    :cond_de
    sget-object v12, Ljava/lang/Float;->TYPE:Ljava/lang/Class;

    if-eq v10, v12, :cond_fd

    const-class v12, Ljava/lang/Float;

    if-ne v10, v12, :cond_e7

    goto :goto_fd

    :cond_e7
    sget-object v12, Ljava/lang/Long;->TYPE:Ljava/lang/Class;

    if-eq v10, v12, :cond_f4

    const-class v12, Ljava/lang/Long;

    if-ne v10, v12, :cond_f0

    goto :goto_f4

    :cond_f0
    const/4 v10, 0x0

    aput-object v10, v8, v9

    goto :goto_134

    :cond_f4
    :goto_f4
    const-wide/16 v12, 0x0

    invoke-static {v12, v13}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v10

    aput-object v10, v8, v9

    goto :goto_134

    :cond_fd
    :goto_fd
    const/4 v10, 0x0

    invoke-static {v10}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    move-result-object v10

    aput-object v10, v8, v9

    goto :goto_134

    :cond_105
    :goto_105
    const-wide/16 v12, 0x0

    invoke-static {v12, v13}, Ljava/lang/Double;->valueOf(D)Ljava/lang/Double;

    move-result-object v10

    aput-object v10, v8, v9

    goto :goto_134

    :cond_10e
    :goto_10e
    sget-object v10, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    aput-object v10, v8, v9

    goto :goto_134

    :cond_113
    :goto_113
    if-nez v9, :cond_11c

    invoke-static/range {p0 .. p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v10

    aput-object v10, v8, v9

    goto :goto_134

    :cond_11c
    if-eq v9, v14, :cond_12e

    if-ne v9, v6, :cond_126

    array-length v10, v7

    const/16 v12, 0xf

    if-ge v10, v12, :cond_126

    goto :goto_12e

    :cond_126
    const/4 v10, 0x0

    invoke-static {v10}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v12

    aput-object v12, v8, v9

    goto :goto_134

    :cond_12e
    :goto_12e
    invoke-static/range {p1 .. p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v10

    aput-object v10, v8, v9

    :goto_134
    add-int/lit8 v9, v9, 0x1

    goto/16 :goto_a2

    :cond_138
    array-length v9, v7
    :try_end_139
    .catchall {:try_start_aa .. :try_end_139} :catchall_21

    const-string v10, "0000000012345"

    const-string v15, "11"

    const-string v17, "22"

    const-string v14, "8991"

    const/4 v6, 0x5

    move-object/from16 v18, v15

    if-lt v9, v6, :cond_18d

    const/4 v9, 0x0

    :try_start_147
    aget-object v6, v7, v9

    sget-object v15, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-ne v6, v15, :cond_153

    invoke-static/range {p0 .. p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v6

    aput-object v6, v8, v9

    :cond_153
    const/4 v6, 0x1

    aget-object v9, v7, v6

    if-ne v9, v13, :cond_174

    new-instance v9, Ljava/lang/StringBuilder;

    invoke-direct {v9}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v9, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-ne v0, v6, :cond_165

    move-object/from16 v6, v17

    goto :goto_167

    :cond_165
    move-object/from16 v6, v18

    :goto_167
    invoke-virtual {v9, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v9}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    const/4 v9, 0x1

    aput-object v6, v8, v9

    :cond_174
    const/4 v6, 0x2

    aget-object v9, v7, v6

    if-ne v9, v15, :cond_17f

    invoke-static/range {p1 .. p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v9

    aput-object v9, v8, v6

    :cond_17f
    const/4 v6, 0x3

    aget-object v9, v7, v6

    if-ne v9, v12, :cond_186

    aput-object v2, v8, v6

    :cond_186
    const/4 v6, 0x4

    aget-object v9, v7, v6

    if-ne v9, v12, :cond_18d

    aput-object v2, v8, v6

    :cond_18d
    const/4 v6, 0x0

    const/16 v19, 0x0

    :goto_190
    array-length v9, v7

    if-ge v6, v9, :cond_1bd

    aget-object v9, v7, v6

    if-ne v9, v13, :cond_1b8

    add-int/lit8 v9, v19, 0x1

    const/4 v12, 0x2

    if-ne v9, v12, :cond_1a1

    aput-object v1, v8, v6

    const/4 v12, 0x5

    const/4 v15, 0x3

    goto :goto_1b5

    :cond_1a1
    const/4 v15, 0x3

    if-ne v9, v15, :cond_1a8

    aput-object v3, v8, v6

    :goto_1a6
    const/4 v12, 0x5

    goto :goto_1b5

    :cond_1a8
    const/4 v12, 0x4

    if-ne v9, v12, :cond_1ae

    aput-object v4, v8, v6

    goto :goto_1a6

    :cond_1ae
    const/4 v12, 0x5

    if-ne v9, v12, :cond_1b5

    sget-object v16, Lcom/floatingmenu/MenuLoader;->sSimCountry:Ljava/lang/String;

    aput-object v16, v8, v6

    :cond_1b5
    :goto_1b5
    move/from16 v19, v9

    goto :goto_1ba

    :cond_1b8
    const/4 v12, 0x5

    const/4 v15, 0x3

    :goto_1ba
    add-int/lit8 v6, v6, 0x1

    goto :goto_190

    :cond_1bd
    invoke-virtual {v11, v8}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    const-string v7, "mId"

    invoke-static/range {p0 .. p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    invoke-static {v6, v7, v8}, Lcom/floatingmenu/MenuLoader;->setFieldValue(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V

    const-string v7, "mSimSlotIndex"

    invoke-static/range {p1 .. p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v8

    invoke-static {v6, v7, v8}, Lcom/floatingmenu/MenuLoader;->setFieldValue(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V

    const-string v7, "mNumber"

    invoke-static {v6, v7, v1}, Lcom/floatingmenu/MenuLoader;->setFieldValue(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V

    const-string v1, "mDisplayName"

    invoke-static {v6, v1, v2}, Lcom/floatingmenu/MenuLoader;->setFieldValue(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V

    const-string v1, "mCarrierName"

    invoke-static {v6, v1, v2}, Lcom/floatingmenu/MenuLoader;->setFieldValue(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V

    const-string v1, "mCountryIso"

    sget-object v2, Lcom/floatingmenu/MenuLoader;->sSimCountry:Ljava/lang/String;

    invoke-static {v6, v1, v2}, Lcom/floatingmenu/MenuLoader;->setFieldValue(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V

    const-string v1, "mMcc"

    invoke-static {v6, v1, v3}, Lcom/floatingmenu/MenuLoader;->setFieldValue(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V

    const-string v1, "mMnc"

    invoke-static {v6, v1, v4}, Lcom/floatingmenu/MenuLoader;->setFieldValue(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V

    const-string v1, "mIccId"

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v2, v14}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/4 v3, 0x1

    if-ne v0, v3, :cond_203

    move-object/from16 v15, v17

    goto :goto_205

    :cond_203
    move-object/from16 v15, v18

    :goto_205
    invoke-virtual {v2, v15}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v10}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v6, v1, v2}, Lcom/floatingmenu/MenuLoader;->setFieldValue(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V

    const-string v1, "mCardId"

    invoke-static/range {p1 .. p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    invoke-static {v6, v1, v0}, Lcom/floatingmenu/MenuLoader;->setFieldValue(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V
    :try_end_21b
    .catchall {:try_start_147 .. :try_end_21b} :catchall_21

    return-object v6

    :cond_21c
    :goto_21c
    const/4 v1, 0x0

    goto :goto_224

    :goto_21e
    const-string v1, "Failed to create mock SubscriptionInfo using reflection constructor"

    invoke-static {v5, v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_21c

    :goto_224
    return-object v1
.end method

.method private static dismissFloatingMenu(Landroid/app/Activity;)V
    .registers 3

    if-nez p0, :cond_3

    return-void

    :cond_3
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v1, Lcom/floatingmenu/MenuLoader$6;

    invoke-direct {v1, p0}, Lcom/floatingmenu/MenuLoader$6;-><init>(Landroid/app/Activity;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private static dismissSystemUiOverlay(Landroid/app/Application;)V
    .registers 3

    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v1, Lcom/floatingmenu/MenuLoader$12;

    invoke-direct {v1, p0}, Lcom/floatingmenu/MenuLoader$12;-><init>(Landroid/app/Application;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private static dpToPx(Landroid/content/Context;F)I
    .registers 3

    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    const/4 v0, 0x1

    invoke-static {v0, p1, p0}, Landroid/util/TypedValue;->applyDimension(IFLandroid/util/DisplayMetrics;)F

    move-result p0

    float-to-int p0, p0

    return p0
.end method

.method private static getApplicationContext()Landroid/app/Application;
    .registers 1

    sget-object v0, Lcom/floatingmenu/MenuLoader;->sApplication:Landroid/app/Application;

    return-object v0
.end method

.method private static getJsonBoolean(Ljava/lang/String;Ljava/lang/String;)Z
    .registers 5

    const/4 v0, 0x0

    if-eqz p0, :cond_4a

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_a

    goto :goto_4a

    :cond_a
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\""

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\":"

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    const/4 v2, -0x1

    if-ne v1, v2, :cond_25

    return v0

    :cond_25
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    add-int/2addr p1, v1

    :goto_2a
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    if-ge p1, v1, :cond_3d

    invoke-virtual {p0, p1}, Ljava/lang/String;->charAt(I)C

    move-result v1

    invoke-static {v1}, Ljava/lang/Character;->isWhitespace(C)Z

    move-result v1

    if-eqz v1, :cond_3d

    add-int/lit8 p1, p1, 0x1

    goto :goto_2a

    :cond_3d
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    if-ge p1, v1, :cond_4a

    const-string v0, "true"

    invoke-virtual {p0, v0, p1}, Ljava/lang/String;->startsWith(Ljava/lang/String;I)Z

    move-result p0

    return p0

    :cond_4a
    :goto_4a
    return v0
.end method

.method private static getJsonString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;
    .registers 8

    const-string v0, ""

    if-eqz p0, :cond_7f

    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_c

    goto/16 :goto_7f

    :cond_c
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\""

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "\":"

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    const/4 v3, -0x1

    if-ne v1, v3, :cond_27

    return-object v0

    :cond_27
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result p1

    add-int/2addr p1, v1

    invoke-virtual {p0, v2, p1}, Ljava/lang/String;->indexOf(Ljava/lang/String;I)I

    move-result p1

    if-ne p1, v3, :cond_33

    return-object v0

    :cond_33
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const/4 v1, 0x1

    add-int/2addr p1, v1

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_3c
    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v4

    if-ge p1, v4, :cond_7a

    invoke-virtual {p0, p1}, Ljava/lang/String;->charAt(I)C

    move-result v4

    if-eqz v3, :cond_65

    const/16 v3, 0x6e

    if-ne v4, v3, :cond_52

    const/16 v3, 0xa

    :goto_4e
    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    goto :goto_63

    :cond_52
    const/16 v3, 0x72

    if-ne v4, v3, :cond_59

    const/16 v3, 0xd

    goto :goto_4e

    :cond_59
    const/16 v3, 0x74

    if-ne v4, v3, :cond_60

    const/16 v3, 0x9

    goto :goto_4e

    :cond_60
    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    :goto_63
    const/4 v3, 0x0

    goto :goto_77

    :cond_65
    const/16 v5, 0x5c

    if-ne v4, v5, :cond_6b

    const/4 v3, 0x1

    goto :goto_77

    :cond_6b
    const/16 v5, 0x22

    if-ne v4, v5, :cond_74

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_74
    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    :goto_77
    add-int/lit8 p1, p1, 0x1

    goto :goto_3c

    :cond_7a
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_7f
    :goto_7f
    return-object v0
.end method

.method private static getMockSimIccid(I)Ljava/lang/String;
    .registers 3

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->getMockSimNumber(I)Ljava/lang/String;

    move-result-object v0

    if-eqz v0, :cond_22

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "8991"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    const/4 v1, 0x1

    if-ne p0, v1, :cond_13

    const-string p0, "22"

    goto :goto_15

    :cond_13
    const-string p0, "11"

    :goto_15
    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "0000000012345"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_22
    const/4 p0, 0x0

    return-object p0
.end method

.method private static getMockSimImsi(I)Ljava/lang/String;
    .registers 2

    invoke-static {p0}, Lcom/floatingmenu/MenuLoader;->getMockSimOperator(I)Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_d

    const-string v0, "123456789"

    invoke-virtual {p0, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    return-object p0

    :cond_d
    const/4 p0, 0x0

    return-object p0
.end method

.method private static getMockSimNumber(I)Ljava/lang/String;
    .registers 3

    const/4 v0, 0x1

    if-ne p0, v0, :cond_6

    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    goto :goto_8

    :cond_6
    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    :goto_8
    if-eqz v1, :cond_12

    if-ne p0, v0, :cond_f

    sget-object p0, Lcom/floatingmenu/MenuLoader;->sSim2Number:Ljava/lang/String;

    goto :goto_11

    :cond_f
    sget-object p0, Lcom/floatingmenu/MenuLoader;->sSim1Number:Ljava/lang/String;

    :goto_11
    return-object p0

    :cond_12
    const/4 p0, 0x0

    return-object p0
.end method

.method private static getMockSimOperator(I)Ljava/lang/String;
    .registers 3

    const/4 v0, 0x1

    if-ne p0, v0, :cond_6

    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    goto :goto_8

    :cond_6
    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    :goto_8
    if-eqz v1, :cond_44

    if-ne p0, v0, :cond_f

    sget-object p0, Lcom/floatingmenu/MenuLoader;->sSim2Provider:Ljava/lang/String;

    goto :goto_11

    :cond_f
    sget-object p0, Lcom/floatingmenu/MenuLoader;->sSim1Provider:Ljava/lang/String;

    :goto_11
    const-string v0, "jio"

    if-nez p0, :cond_16

    move-object p0, v0

    :cond_16
    invoke-virtual {p0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_23

    const-string p0, "405840"

    return-object p0

    :cond_23
    const-string v0, "airtel"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2e

    const-string p0, "40445"

    return-object p0

    :cond_2e
    const-string v0, "vi"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_39

    const-string p0, "40420"

    return-object p0

    :cond_39
    const-string v0, "bsnl"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_44

    const-string p0, "40473"

    return-object p0

    :cond_44
    const/4 p0, 0x0

    return-object p0
.end method

.method private static getMockSimOperatorName(I)Ljava/lang/String;
    .registers 3

    const/4 v0, 0x1

    if-ne p0, v0, :cond_6

    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    goto :goto_8

    :cond_6
    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    :goto_8
    if-eqz v1, :cond_44

    if-ne p0, v0, :cond_f

    sget-object p0, Lcom/floatingmenu/MenuLoader;->sSim2Provider:Ljava/lang/String;

    goto :goto_11

    :cond_f
    sget-object p0, Lcom/floatingmenu/MenuLoader;->sSim1Provider:Ljava/lang/String;

    :goto_11
    const-string v0, "jio"

    if-nez p0, :cond_16

    move-object p0, v0

    :cond_16
    invoke-virtual {p0}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_23

    const-string p0, "Jio"

    return-object p0

    :cond_23
    const-string v0, "airtel"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2e

    const-string p0, "Airtel"

    return-object p0

    :cond_2e
    const-string v0, "vi"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_39

    const-string p0, "Vi"

    return-object p0

    :cond_39
    const-string v0, "bsnl"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_44

    const-string p0, "BSNL"

    return-object p0

    :cond_44
    const/4 p0, 0x0

    return-object p0
.end method

.method private static getOrCreateServiceCache()Ljava/util/Map;
    .registers 5

    const/4 v0, 0x0

    :try_start_1
    const-string v1, "android.os.ServiceManager"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "sCache"

    invoke-virtual {v1, v2}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v1

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    invoke-virtual {v1, v0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-eqz v2, :cond_21

    instance-of v3, v2, Lcom/floatingmenu/MenuLoader$FakeServiceCache;

    if-nez v3, :cond_1c

    goto :goto_21

    :cond_1c
    check-cast v2, Ljava/util/Map;

    return-object v2

    :catchall_1f
    move-exception v1

    goto :goto_33

    :cond_21
    :goto_21
    new-instance v3, Lcom/floatingmenu/MenuLoader$FakeServiceCache;

    invoke-direct {v3, v0}, Lcom/floatingmenu/MenuLoader$FakeServiceCache;-><init>(Lcom/floatingmenu/MenuLoader$1;)V

    instance-of v4, v2, Ljava/util/Map;

    if-eqz v4, :cond_2f

    check-cast v2, Ljava/util/Map;

    invoke-virtual {v3, v2}, Ljava/util/AbstractMap;->putAll(Ljava/util/Map;)V

    :cond_2f
    invoke-virtual {v1, v0, v3}, Ljava/lang/reflect/Field;->set(Ljava/lang/Object;Ljava/lang/Object;)V
    :try_end_32
    .catchall {:try_start_1 .. :try_end_32} :catchall_1f

    return-object v3

    :goto_33
    const-string v2, "ZygiskMenu @Hivirtus"

    const-string v3, "Failed to get or create ServiceCache"

    invoke-static {v2, v3, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v0
.end method

.method private static getProcessName()Ljava/lang/String;
    .registers 3

    :try_start_0
    new-instance v0, Ljava/io/BufferedReader;

    new-instance v1, Ljava/io/FileReader;

    const-string v2, "/proc/self/cmdline"

    invoke-direct {v1, v2}, Ljava/io/FileReader;-><init>(Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    invoke-virtual {v0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0}, Ljava/io/BufferedReader;->close()V

    if-eqz v1, :cond_1a

    invoke-virtual {v1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0
    :try_end_19
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_19} :catch_1a

    return-object v0

    :catch_1a
    :cond_1a
    const/4 v0, 0x0

    return-object v0
.end method

.method private static getSlotIndexFromSubId(I)I
    .registers 7

    const/4 v0, 0x0

    if-gez p0, :cond_4

    return v0

    :cond_4
    const/4 v1, 0x1

    :try_start_5
    const-string v2, "android.telephony.SubscriptionManager"

    invoke-static {v2}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v2

    const-string v3, "getSlotIndex"

    new-array v4, v1, [Ljava/lang/Class;

    sget-object v5, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    aput-object v5, v4, v0

    invoke-virtual {v2, v3, v4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v3, v1, [Ljava/lang/Object;

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v4

    aput-object v4, v3, v0

    const/4 v4, 0x0

    invoke-virtual {v2, v4, v3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/Integer;

    if-eqz v2, :cond_3e

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result v3

    if-ltz v3, :cond_3e

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result p0
    :try_end_35
    .catchall {:try_start_5 .. :try_end_35} :catchall_36

    return p0

    :catchall_36
    nop

    if-ne p0, v1, :cond_3a

    return v0

    :cond_3a
    const/4 v2, 0x2

    if-ne p0, v2, :cond_3e

    return v1

    :cond_3e
    return v0
.end method

.method private static getSubIdFromArgs([Ljava/lang/Object;)I
    .registers 5

    if-eqz p0, :cond_16

    array-length v0, p0

    const/4 v1, 0x0

    :goto_4
    if-ge v1, v0, :cond_16

    aget-object v2, p0, v1

    instance-of v3, v2, Ljava/lang/Integer;

    if-eqz v3, :cond_13

    check-cast v2, Ljava/lang/Integer;

    invoke-virtual {v2}, Ljava/lang/Integer;->intValue()I

    move-result p0

    return p0

    :cond_13
    add-int/lit8 v1, v1, 0x1

    goto :goto_4

    :cond_16
    const/4 p0, -0x1

    return p0
.end method

.method public static init(Ljava/lang/String;Ljava/lang/String;)V
    .registers 16

    const-string v0, "Root spoofing enabled early for target: "

    const-string v1, "Synchronously initialized SIM settings: SIM1="

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v3, "MenuLoader: init() triggered from JNI for process: "

    invoke-direct {v2, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    const-string v3, "ZygiskMenu @Hivirtus"

    invoke-static {v3, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v2, 0x0

    const/4 v4, 0x1

    const/4 v5, 0x0

    :try_start_1a
    const-string v6, "dalvik.system.VMRuntime"

    invoke-static {v6}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v6

    const-string v7, "getRuntime"

    new-array v8, v5, [Ljava/lang/Class;

    invoke-virtual {v6, v7, v8}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v7

    invoke-virtual {v7, v4}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v8, v5, [Ljava/lang/Object;

    invoke-virtual {v7, v2, v8}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    const-string v8, "setHiddenApiExemptions"

    new-array v9, v4, [Ljava/lang/Class;

    const-class v10, [Ljava/lang/String;

    aput-object v10, v9, v5

    invoke-virtual {v6, v8, v9}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v6

    invoke-virtual {v6, v4}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v8, v4, [Ljava/lang/Object;

    new-array v9, v4, [Ljava/lang/String;

    const-string v10, "L"

    aput-object v10, v9, v5

    aput-object v9, v8, v5

    invoke-virtual {v6, v7, v8}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    const-string v6, "Successfully exempted hidden APIs via VMRuntime"

    invoke-static {v3, v6}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_52
    .catchall {:try_start_1a .. :try_end_52} :catchall_53

    goto :goto_59

    :catchall_53
    move-exception v6

    const-string v7, "Failed to exempt hidden APIs: "

    invoke-static {v3, v7, v6}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_59
    if-eqz p0, :cond_65

    const-string v6, "systemui"

    invoke-virtual {p0, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v6

    if-eqz v6, :cond_65

    const/4 v9, 0x1

    goto :goto_66

    :cond_65
    const/4 v9, 0x0

    :goto_66
    if-nez v9, :cond_target_ok

    invoke-static {p0}, Lcom/floatingmenu/TargetPackageGuard;->isPackageSelected(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_target_ok

    invoke-static {p0}, Lcom/floatingmenu/BankingAppGuard;->shouldStealthInject(Ljava/lang/String;)Z

    move-result v6

    if-nez v6, :cond_target_ok

    return-void

    :cond_target_ok
    const-string v4, ""

    if-eqz p1, :cond_12e

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-nez v6, :cond_12e

    :try_start_70
    const-string v6, "sim1_enabled"

    invoke-static {p1, v6}, Lcom/floatingmenu/MenuLoader;->getJsonBoolean(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v6

    sput-boolean v6, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    const-string v6, "sim1_provider"

    invoke-static {p1, v6}, Lcom/floatingmenu/MenuLoader;->getJsonString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    sput-object v6, Lcom/floatingmenu/MenuLoader;->sSim1Provider:Ljava/lang/String;

    const-string v6, "sim1_number"

    invoke-static {p1, v6}, Lcom/floatingmenu/MenuLoader;->getJsonString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    sput-object v6, Lcom/floatingmenu/MenuLoader;->sSim1Number:Ljava/lang/String;

    const-string v6, "sim2_enabled"

    invoke-static {p1, v6}, Lcom/floatingmenu/MenuLoader;->getJsonBoolean(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v6

    sput-boolean v6, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    const-string v6, "sim2_provider"

    invoke-static {p1, v6}, Lcom/floatingmenu/MenuLoader;->getJsonString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    sput-object v6, Lcom/floatingmenu/MenuLoader;->sSim2Provider:Ljava/lang/String;

    const-string v6, "sim2_number"

    invoke-static {p1, v6}, Lcom/floatingmenu/MenuLoader;->getJsonString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    sput-object v6, Lcom/floatingmenu/MenuLoader;->sSim2Number:Ljava/lang/String;

    invoke-static {p0}, Lcom/floatingmenu/TargetPackageGuard;->isPackageSelected(Ljava/lang/String;)Z

    move-result v6

    sput-boolean v6, Lcom/floatingmenu/MenuLoader;->sIsTargetPackage:Z

    const-string v6, "sim_country"

    invoke-static {p1, v6}, Lcom/floatingmenu/MenuLoader;->getJsonString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6

    sput-object v6, Lcom/floatingmenu/MenuLoader;->sSimCountry:Ljava/lang/String;

    if-eqz v6, :cond_bc

    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z

    move-result v6

    if-eqz v6, :cond_c0

    goto :goto_bc

    :catchall_b9
    move-exception v1

    move-object v6, v4

    goto :goto_126

    :cond_bc
    :goto_bc
    const-string v6, "in"

    sput-object v6, Lcom/floatingmenu/MenuLoader;->sSimCountry:Ljava/lang/String;

    :cond_c0
    const-string v6, "iamnotdeveloper"

    invoke-static {p1, v6}, Lcom/floatingmenu/MenuLoader;->getJsonBoolean(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v6

    sput-boolean v6, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    const-string v6, "iamnoroot"

    invoke-static {p1, v6}, Lcom/floatingmenu/MenuLoader;->getJsonBoolean(Ljava/lang/String;Ljava/lang/String;)Z

    move-result v6

    sput-boolean v6, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    const-string v6, "license_key"

    invoke-static {p1, v6}, Lcom/floatingmenu/MenuLoader;->getJsonString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v6
    :try_end_d6
    .catchall {:try_start_70 .. :try_end_d6} :catchall_b9

    :try_start_d6
    const-string v7, "license_status"

    invoke-static {p1, v7}, Lcom/floatingmenu/MenuLoader;->getJsonString(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v4

    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", SIM2="

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", IsTarget = "

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sIsTargetPackage:Z

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", Country="

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-object v1, Lcom/floatingmenu/MenuLoader;->sSimCountry:Ljava/lang/String;

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ", IAmNotDeveloper="

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v1, ", IAmNoRoot="

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    sget-boolean v1, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    invoke-virtual {v7, v1}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v3, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_11f
    .catchall {:try_start_d6 .. :try_end_11f} :catchall_122

    move-object v11, v4

    move-object v12, v6

    goto :goto_130

    :catchall_122
    move-exception v1

    move-object v13, v6

    move-object v6, v4

    move-object v4, v13

    :goto_126
    const-string v7, "Failed to parse configJson synchronously: "

    invoke-static {v3, v7, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    move-object v12, v4

    move-object v11, v6

    goto :goto_130

    :cond_12e
    move-object v11, v4

    move-object v12, v11

    :goto_130
    if-nez v9, :cond_18c

    if-eqz p0, :cond_145

    const-string v1, ":"

    invoke-virtual {p0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4

    if-eqz v4, :cond_143

    invoke-virtual {p0, v1}, Ljava/lang/String;->split(Ljava/lang/String;)[Ljava/lang/String;

    move-result-object v1

    aget-object v1, v1, v5

    goto :goto_146

    :cond_143
    move-object v1, p0

    goto :goto_146

    :cond_145
    move-object v1, v2

    :goto_146
    sput-object v1, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v4, "Early applying SMS, Telephony, and Activity hooks for: "

    invoke-direct {v1, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    sget-object v4, Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v3, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    :try_start_15b
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->applySmsHooks()V

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->applyTelephonyHooks()V

    const-string v1, "android.app.ActivityThread"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    invoke-static {v1, v2}, Lcom/floatingmenu/MenuLoader;->applyActivityHooks(Ljava/lang/Class;Ljava/lang/Object;)V

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->applyPackageManagerHooks()V

    invoke-static {}, Lcom/floatingmenu/MenuLoader;->spoofBuildFields()V
    :try_end_185
    .catchall {:try_start_15b .. :try_end_185} :catchall_186

    goto :goto_18c

    :catchall_186
    move-exception v0

    const-string v1, "Failed to apply early hooks"

    invoke-static {v3, v1, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_18c
    :goto_18c
    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/floatingmenu/MenuLoader$1;

    move-object v7, v1

    move-object v8, p0

    move-object v10, p1

    invoke-direct/range {v7 .. v12}, Lcom/floatingmenu/MenuLoader$1;-><init>(Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method public static isSensitiveApp(Ljava/lang/String;)Z
    .registers 1

    const/4 p0, 0x0

    return p0
.end method

.method private static isTargetApplication(Ljava/lang/String;)Z
    .registers 1

    invoke-static {p0}, Lcom/floatingmenu/TargetPackageGuard;->isPackageSelected(Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method private static querySocket(Ljava/lang/String;)Ljava/lang/String;
    .registers 6

    const-string v0, "UTF-8"

    const/4 v1, 0x0

    :try_start_3
    new-instance v2, Landroid/net/LocalSocket;

    invoke-direct {v2}, Landroid/net/LocalSocket;-><init>()V
    :try_end_8
    .catchall {:try_start_3 .. :try_end_8} :catchall_5a

    :try_start_8
    new-instance v3, Landroid/net/LocalSocketAddress;

    const-string v4, "zygisk_menu_socket"

    invoke-direct {v3, v4}, Landroid/net/LocalSocketAddress;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v3}, Landroid/net/LocalSocket;->connect(Landroid/net/LocalSocketAddress;)V

    const/16 v3, 0xbb8

    invoke-virtual {v2, v3}, Landroid/net/LocalSocket;->setSoTimeout(I)V

    invoke-virtual {v2}, Landroid/net/LocalSocket;->getOutputStream()Ljava/io/OutputStream;

    move-result-object v3

    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "\n"

    invoke-virtual {v4, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {p0, v0}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object p0

    invoke-virtual {v3, p0}, Ljava/io/OutputStream;->write([B)V

    invoke-virtual {v3}, Ljava/io/OutputStream;->flush()V

    new-instance p0, Ljava/io/BufferedReader;

    new-instance v3, Ljava/io/InputStreamReader;

    invoke-virtual {v2}, Landroid/net/LocalSocket;->getInputStream()Ljava/io/InputStream;

    move-result-object v4

    invoke-direct {v3, v4, v0}, Ljava/io/InputStreamReader;-><init>(Ljava/io/InputStream;Ljava/lang/String;)V

    invoke-direct {p0, v3}, Ljava/io/BufferedReader;-><init>(Ljava/io/Reader;)V

    invoke-virtual {p0}, Ljava/io/BufferedReader;->readLine()Ljava/lang/String;

    move-result-object p0

    if-eqz p0, :cond_54

    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0
    :try_end_4e
    .catchall {:try_start_8 .. :try_end_4e} :catchall_52

    :try_start_4e
    invoke-virtual {v2}, Landroid/net/LocalSocket;->close()V
    :try_end_51
    .catch Ljava/lang/Exception; {:try_start_4e .. :try_end_51} :catch_51

    :catch_51
    return-object p0

    :catchall_52
    nop

    goto :goto_5c

    :cond_54
    :try_start_54
    invoke-virtual {v2}, Landroid/net/LocalSocket;->close()V
    :try_end_57
    .catch Ljava/lang/Exception; {:try_start_54 .. :try_end_57} :catch_57

    :catch_57
    const-string p0, ""

    return-object p0

    :catchall_5a
    nop

    move-object v2, v1

    :goto_5c
    if-eqz v2, :cond_61

    :try_start_5e
    invoke-virtual {v2}, Landroid/net/LocalSocket;->close()V
    :try_end_61
    .catch Ljava/lang/Exception; {:try_start_5e .. :try_end_61} :catch_61

    :catch_61
    :cond_61
    return-object v1
.end method

.method private static registerSystemUiReceiver(Landroid/app/Application;)V
    .registers 5

    new-instance v0, Landroid/content/IntentFilter;

    invoke-direct {v0}, Landroid/content/IntentFilter;-><init>()V

    const-string v1, "com.floatingmenu.ACTION_FOREGROUND_CHANGED"

    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    const-string v1, "com.floatingmenu.ACTION_LICENSE_STATE_CHANGED"

    invoke-virtual {v0, v1}, Landroid/content/IntentFilter;->addAction(Ljava/lang/String;)V

    new-instance v1, Lcom/floatingmenu/MenuLoader$7;

    invoke-direct {v1, p0}, Lcom/floatingmenu/MenuLoader$7;-><init>(Landroid/app/Application;)V

    sget v2, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v3, 0x21

    if-lt v2, v3, :cond_1e

    invoke-static {p0, v1, v0}, Lcom/floatingmenu/d;->a(Landroid/app/Application;Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)V

    goto :goto_21

    :cond_1e
    invoke-virtual {p0, v1, v0}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    :goto_21
    return-void
.end method

.method private static setBuildField(Ljava/lang/String;Ljava/lang/String;)V
    .registers 6

    :try_start_0
    const-class v0, Landroid/os/Build;

    invoke-virtual {v0, p0}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V
    :try_end_a
    .catchall {:try_start_0 .. :try_end_a} :catchall_23

    :try_start_a
    const-class v2, Ljava/lang/reflect/Field;

    const-string v3, "accessFlags"

    invoke-virtual {v2, v3}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v2

    invoke-virtual {v2, v1}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    invoke-virtual {v0}, Ljava/lang/reflect/Field;->getModifiers()I

    move-result v1

    and-int/lit8 v1, v1, -0x11

    invoke-virtual {v2, v0, v1}, Ljava/lang/reflect/Field;->setInt(Ljava/lang/Object;I)V
    :try_end_1e
    .catchall {:try_start_a .. :try_end_1e} :catchall_1e

    :catchall_1e
    const/4 v1, 0x0

    :try_start_1f
    invoke-virtual {v0, v1, p1}, Ljava/lang/reflect/Field;->set(Ljava/lang/Object;Ljava/lang/Object;)V
    :try_end_22
    .catchall {:try_start_1f .. :try_end_22} :catchall_23

    goto :goto_3f

    :catchall_23
    move-exception v0

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "Failed to set Build field "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, " to "

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "ZygiskMenu @Hivirtus"

    invoke-static {p1, p0, v0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_3f
    return-void
.end method

.method private static setFieldValue(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V
    .registers 6

    if-nez p0, :cond_3

    return-void

    :cond_3
    :try_start_3
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0, p1}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;

    move-result-object v0

    const/4 v1, 0x1

    invoke-virtual {v0, v1}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    invoke-virtual {v0}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;

    move-result-object v1

    const-class v2, Ljava/lang/String;

    if-ne v1, v2, :cond_25

    instance-of v2, p2, Ljava/lang/Integer;

    if-eqz v2, :cond_25

    invoke-static {p2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v1

    :goto_1f
    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Field;->set(Ljava/lang/Object;Ljava/lang/Object;)V

    goto :goto_71

    :catchall_23
    move-exception p0

    goto :goto_56

    :cond_25
    sget-object v2, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-eq v1, v2, :cond_2d

    const-class v2, Ljava/lang/Integer;

    if-ne v1, v2, :cond_46

    :cond_2d
    instance-of v2, p2, Ljava/lang/String;
    :try_end_2f
    .catch Ljava/lang/NoSuchFieldException; {:try_start_3 .. :try_end_2f} :catch_71
    .catchall {:try_start_3 .. :try_end_2f} :catchall_23

    if-eqz v2, :cond_46

    :try_start_31
    move-object v1, p2

    check-cast v1, Ljava/lang/String;

    invoke-static {v1}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    invoke-virtual {v0, p0, v1}, Ljava/lang/reflect/Field;->set(Ljava/lang/Object;Ljava/lang/Object;)V
    :try_end_3f
    .catchall {:try_start_31 .. :try_end_3f} :catchall_40

    goto :goto_71

    :catchall_40
    const/4 v1, 0x0

    :try_start_41
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    goto :goto_1f

    :cond_46
    const-class v2, Ljava/lang/CharSequence;

    if-ne v1, v2, :cond_52

    instance-of v1, p2, Ljava/lang/String;

    if-eqz v1, :cond_52

    move-object v1, p2

    check-cast v1, Ljava/lang/CharSequence;

    goto :goto_1f

    :cond_52
    invoke-virtual {v0, p0, p2}, Ljava/lang/reflect/Field;->set(Ljava/lang/Object;Ljava/lang/Object;)V
    :try_end_55
    .catch Ljava/lang/NoSuchFieldException; {:try_start_41 .. :try_end_55} :catch_71
    .catchall {:try_start_41 .. :try_end_55} :catchall_23

    goto :goto_71

    :goto_56
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Failed to set field "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, " to "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string p2, "ZygiskMenu @Hivirtus"

    invoke-static {p2, p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :catch_71
    :goto_71
    return-void
.end method

.method private static showSystemUiOverlay(Landroid/app/Application;Ljava/lang/String;)V
    .registers 4

    return-void

    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v1, Lcom/floatingmenu/MenuLoader$10;

    invoke-direct {v1, p0, p1}, Lcom/floatingmenu/MenuLoader$10;-><init>(Landroid/app/Application;Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private static spoofBuildFields()V
    .registers 5

    const-string v0, "ZygiskMenu @Hivirtus"

    const-string v1, "release-keys"

    :try_start_4
    const-string v2, "TAGS"

    invoke-static {v2, v1}, Lcom/floatingmenu/MenuLoader;->setBuildField(Ljava/lang/String;Ljava/lang/String;)V

    const-string v2, "TYPE"

    const-string v3, "user"

    invoke-static {v2, v3}, Lcom/floatingmenu/MenuLoader;->setBuildField(Ljava/lang/String;Ljava/lang/String;)V

    const-string v2, "DISPLAY"

    const-string v3, "user-release"

    invoke-static {v2, v3}, Lcom/floatingmenu/MenuLoader;->setBuildField(Ljava/lang/String;Ljava/lang/String;)V

    const-string v2, "FINGERPRINT"

    sget-object v3, Landroid/os/Build;->FINGERPRINT:Ljava/lang/String;

    const-string v4, "test-keys"

    invoke-virtual {v3, v4, v1}, Ljava/lang/String;->replace(Ljava/lang/CharSequence;Ljava/lang/CharSequence;)Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1}, Lcom/floatingmenu/MenuLoader;->setBuildField(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_29
    .catchall {:try_start_4 .. :try_end_29} :catchall_2a

    goto :goto_30

    :catchall_2a
    move-exception v1

    const-string v2, "Failed to spoof Build fields: "

    invoke-static {v0, v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_30
    return-void
.end method

.method private static startSystemUiLicenseManager(Landroid/app/Application;)V
    .registers 3

    return-void

    sget-boolean v0, Lcom/floatingmenu/MenuLoader;->sPollerStarted:Z

    if-eqz v0, :cond_5

    return-void

    :cond_5
    const/4 v0, 0x1

    sput-boolean v0, Lcom/floatingmenu/MenuLoader;->sPollerStarted:Z

    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/floatingmenu/MenuLoader$9;

    invoke-direct {v1, p0}, Lcom/floatingmenu/MenuLoader$9;-><init>(Landroid/app/Application;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method private static triggerSystemUiOverlayCheck(Landroid/app/Application;)V
    .registers 3

    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/floatingmenu/MenuLoader$8;

    invoke-direct {v1, p0}, Lcom/floatingmenu/MenuLoader$8;-><init>(Landroid/app/Application;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method

.method public static updateMockSimSettings(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;)V
    .registers 13

    const-string v6, "in"

    move v0, p0

    move-object v1, p1

    move-object v2, p2

    move v3, p3

    move-object v4, p4

    move-object v5, p5

    invoke-static/range {v0 .. v6}, Lcom/floatingmenu/MenuLoader;->updateMockSimSettingsEx(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method

.method public static updateMockSimSettingsEx(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .registers 16

    sget-boolean v7, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    sget-boolean v8, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    move v0, p0

    move-object v1, p1

    move-object v2, p2

    move v3, p3

    move-object v4, p4

    move-object v5, p5

    move-object v6, p6

    invoke-static/range {v0 .. v8}, Lcom/floatingmenu/MenuLoader;->updateMockSimSettingsEx2(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)V

    return-void
.end method

.method public static updateMockSimSettingsEx2(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;Z)V
    .registers 17

    sget-boolean v8, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    move v0, p0

    move-object v1, p1

    move-object v2, p2

    move v3, p3

    move-object v4, p4

    move-object v5, p5

    move-object v6, p6

    move/from16 v7, p7

    invoke-static/range {v0 .. v8}, Lcom/floatingmenu/MenuLoader;->updateMockSimSettingsEx2(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)V

    return-void
.end method

.method public static updateMockSimSettingsEx2(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)V
    .registers 9

    sput-boolean p0, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    sput-object p1, Lcom/floatingmenu/MenuLoader;->sSim1Provider:Ljava/lang/String;

    sput-object p2, Lcom/floatingmenu/MenuLoader;->sSim1Number:Ljava/lang/String;

    sput-boolean p3, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    sput-object p4, Lcom/floatingmenu/MenuLoader;->sSim2Provider:Ljava/lang/String;

    sput-object p5, Lcom/floatingmenu/MenuLoader;->sSim2Number:Ljava/lang/String;

    sput-boolean p7, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    sput-boolean p8, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    if-eqz p6, :cond_1a

    invoke-virtual {p6}, Ljava/lang/String;->isEmpty()Z

    move-result p7

    if-nez p7, :cond_1a

    sput-object p6, Lcom/floatingmenu/MenuLoader;->sSimCountry:Ljava/lang/String;

    :cond_1a
    sget-boolean p6, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    if-eqz p6, :cond_2f

    new-instance p6, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object p7

    invoke-direct {p6, p7}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance p7, Lcom/floatingmenu/MenuLoader$19;

    invoke-direct {p7}, Lcom/floatingmenu/MenuLoader$19;-><init>()V

    invoke-virtual {p6, p7}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    :cond_2f
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->getApplicationContext()Landroid/app/Application;

    move-result-object p6

    if-eqz p6, :cond_8f

    const-string p7, "zygisk_menu_prefs"

    const/4 p8, 0x0

    invoke-virtual {p6, p7, p8}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p6

    invoke-interface {p6}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p6

    const-string p7, "sim1_enabled"

    invoke-static {p0}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object p0

    invoke-interface {p6, p7, p0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string p6, "sim1_provider"

    invoke-interface {p0, p6, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string p1, "sim1_number"

    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string p1, "sim2_enabled"

    invoke-static {p3}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object p2

    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string p1, "sim2_provider"

    invoke-interface {p0, p1, p4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string p1, "sim2_number"

    invoke-interface {p0, p1, p5}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    const-string p1, "sim_country"

    sget-object p2, Lcom/floatingmenu/MenuLoader;->sSimCountry:Ljava/lang/String;

    invoke-interface {p0, p1, p2}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    sget-boolean p1, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    invoke-static {p1}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object p1

    const-string p2, "iamnotdeveloper"

    invoke-interface {p0, p2, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    sget-boolean p1, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    invoke-static {p1}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object p1

    const-string p2, "iamnoroot"

    invoke-interface {p0, p2, p1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object p0

    invoke-interface {p0}, Landroid/content/SharedPreferences$Editor;->apply()V

    :cond_8f
    return-void
.end method

.method private static updateSystemUiOverlayError(Ljava/lang/String;)V
    .registers 3

    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    new-instance v1, Lcom/floatingmenu/MenuLoader$11;

    invoke-direct {v1, p0}, Lcom/floatingmenu/MenuLoader$11;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method
