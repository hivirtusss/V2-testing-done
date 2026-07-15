.class Lcom/floatingmenu/MenuLoader$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic val$configJson:Ljava/lang/String;

.field final synthetic val$finalLicenseKey:Ljava/lang/String;

.field final synthetic val$finalLicenseStatus:Ljava/lang/String;

.field final synthetic val$isSystemUi:Z

.field final synthetic val$processName:Ljava/lang/String;


# direct methods
.method public constructor <init>(Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .registers 6

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$1;->val$processName:Ljava/lang/String;

    iput-boolean p2, p0, Lcom/floatingmenu/MenuLoader$1;->val$isSystemUi:Z

    iput-object p3, p0, Lcom/floatingmenu/MenuLoader$1;->val$configJson:Ljava/lang/String;

    iput-object p4, p0, Lcom/floatingmenu/MenuLoader$1;->val$finalLicenseStatus:Ljava/lang/String;

    iput-object p5, p0, Lcom/floatingmenu/MenuLoader$1;->val$finalLicenseKey:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 12

    const-string v0, "ZygiskMenu @Hivirtus"

    const-string v1, "Zygisk initialized in process: "

    :try_start_4
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$1;->val$processName:Ljava/lang/String;

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const-string v1, "android.app.ActivityThread"

    invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    const-string v2, "currentActivityThread"

    const/4 v3, 0x0

    new-array v4, v3, [Ljava/lang/Class;

    invoke-virtual {v1, v2, v4}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    const/4 v4, 0x1

    invoke-virtual {v2, v4}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    const/4 v5, 0x0

    move-object v7, v5

    const/4 v6, 0x0

    :goto_2b
    const-wide/16 v8, 0x32

    const/16 v10, 0xc8

    if-ge v6, v10, :cond_43

    new-array v7, v3, [Ljava/lang/Object;

    invoke-virtual {v2, v5, v7}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v7

    if-eqz v7, :cond_3a

    goto :goto_43

    :cond_3a
    invoke-static {v8, v9}, Ljava/lang/Thread;->sleep(J)V

    add-int/lit8 v6, v6, 0x1

    goto :goto_2b

    :catchall_40
    move-exception v1

    goto/16 :goto_167

    :cond_43
    :goto_43
    if-nez v7, :cond_4b

    const-string v1, "ActivityThread is null, aborting."

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_4b
    const-string v2, "currentApplication"

    new-array v6, v3, [Ljava/lang/Class;

    invoke-virtual {v1, v2, v6}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    invoke-virtual {v2, v4}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    move-object v6, v5

    const/4 v4, 0x0

    :goto_58
    if-ge v4, v10, :cond_6b

    new-array v6, v3, [Ljava/lang/Object;

    invoke-virtual {v2, v5, v6}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    check-cast v6, Landroid/app/Application;

    if-eqz v6, :cond_65

    goto :goto_6b

    :cond_65
    invoke-static {v8, v9}, Ljava/lang/Thread;->sleep(J)V

    add-int/lit8 v4, v4, 0x1

    goto :goto_58

    :cond_6b
    :goto_6b
    if-nez v6, :cond_89

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "Application is null for process "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v2, p0, Lcom/floatingmenu/MenuLoader$1;->val$processName:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, ", aborting."

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    :cond_89
    invoke-virtual {v6}, Landroid/content/Context;->getPackageName()Ljava/lang/String;

    move-result-object v2

    # setter for: Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;
    invoke-static {v2}, Lcom/floatingmenu/MenuLoader;->access$002(Ljava/lang/String;)Ljava/lang/String;

    # setter for: Lcom/floatingmenu/MenuLoader;->sApplication:Landroid/app/Application;
    invoke-static {v6}, Lcom/floatingmenu/MenuLoader;->access$102(Landroid/app/Application;)Landroid/app/Application;

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Application context found for package: "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    # getter for: Lcom/floatingmenu/MenuLoader;->sCurrentPackage:Ljava/lang/String;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$000()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, " (process: "

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object v4, p0, Lcom/floatingmenu/MenuLoader$1;->val$processName:Ljava/lang/String;

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, ")"

    invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    iget-boolean v2, p0, Lcom/floatingmenu/MenuLoader$1;->val$isSystemUi:Z

    if-nez v2, :cond_c6

    const-string v2, "Completing delayed Activity hooks (mProviderMap clearing)..."

    invoke-static {v0, v2}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    # invokes: Lcom/floatingmenu/MenuLoader;->applyActivityHooks(Ljava/lang/Class;Ljava/lang/Object;)V
    invoke-static {v1, v7}, Lcom/floatingmenu/MenuLoader;->access$200(Ljava/lang/Class;Ljava/lang/Object;)V

    :cond_c6
    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$1;->val$configJson:Ljava/lang/String;

    if-eqz v1, :cond_159

    invoke-virtual {v1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_159

    const-string v1, "zygisk_menu_prefs"

    invoke-virtual {v6, v1, v3}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    const-string v2, "active"

    iget-object v3, p0, Lcom/floatingmenu/MenuLoader$1;->val$finalLicenseStatus:Ljava/lang/String;

    invoke-virtual {v2, v3}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v2

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v3, "sim1_enabled"

    sget-boolean v4, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    invoke-static {v4}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v4

    invoke-interface {v1, v3, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v3, "sim1_provider"

    sget-object v4, Lcom/floatingmenu/MenuLoader;->sSim1Provider:Ljava/lang/String;

    invoke-interface {v1, v3, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v3, "sim1_number"

    sget-object v4, Lcom/floatingmenu/MenuLoader;->sSim1Number:Ljava/lang/String;

    invoke-interface {v1, v3, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v3, "sim2_enabled"

    sget-boolean v4, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    invoke-static {v4}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v4

    invoke-interface {v1, v3, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v3, "sim2_provider"

    sget-object v4, Lcom/floatingmenu/MenuLoader;->sSim2Provider:Ljava/lang/String;

    invoke-interface {v1, v3, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v3, "sim2_number"

    sget-object v4, Lcom/floatingmenu/MenuLoader;->sSim2Number:Ljava/lang/String;

    invoke-interface {v1, v3, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v3, "sim_country"

    sget-object v4, Lcom/floatingmenu/MenuLoader;->sSimCountry:Ljava/lang/String;

    invoke-interface {v1, v3, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v3, "iamnotdeveloper"

    sget-boolean v4, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    invoke-static {v4}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v4

    invoke-interface {v1, v3, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v3, "iamnoroot"

    sget-boolean v4, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    invoke-static {v4}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v4

    invoke-interface {v1, v3, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v3, "is_licensed"

    const/4 v2, 0x1

    invoke-interface {v1, v3, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "license_key"

    iget-object v3, p0, Lcom/floatingmenu/MenuLoader$1;->val$finalLicenseKey:Ljava/lang/String;

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "validation_status"

    iget-object v3, p0, Lcom/floatingmenu/MenuLoader$1;->val$finalLicenseStatus:Ljava/lang/String;

    invoke-interface {v1, v2, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    const-string v1, "Wrote config.json values to SharedPreferences on startup"

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    :cond_159
    new-instance v1, Lcom/floatingmenu/MenuLoader$1$1;

    invoke-direct {v1, p0}, Lcom/floatingmenu/MenuLoader$1$1;-><init>(Lcom/floatingmenu/MenuLoader$1;)V

    invoke-static {v6, v1}, Lcom/floatingmenu/b;->a(Landroid/app/Application;Landroid/app/Application$ActivityLifecycleCallbacks;)V

    const-string v1, "ActivityLifecycleCallbacks registered successfully."

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_166
    .catchall {:try_start_4 .. :try_end_166} :catchall_40

    goto :goto_16c

    :goto_167
    const-string v2, "Error in MenuLoader thread: "

    invoke-static {v0, v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_16c
    return-void
.end method
