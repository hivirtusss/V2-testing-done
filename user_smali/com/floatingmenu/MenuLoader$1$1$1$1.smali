.class Lcom/floatingmenu/MenuLoader$1$1$1$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$2:Lcom/floatingmenu/MenuLoader$1$1$1;

.field final synthetic val$globalKey:Ljava/lang/String;

.field final synthetic val$globalStatus:Ljava/lang/String;

.field final synthetic val$simSettings:Ljava/lang/String;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/MenuLoader$1$1$1;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .registers 5

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->this$2:Lcom/floatingmenu/MenuLoader$1$1$1;

    iput-object p2, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->val$simSettings:Ljava/lang/String;

    iput-object p3, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->val$globalKey:Ljava/lang/String;

    iput-object p4, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->val$globalStatus:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 12

    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->val$simSettings:Ljava/lang/String;

    const-string v1, "|"

    invoke-virtual {v0, v1}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eqz v0, :cond_c8

    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->val$simSettings:Ljava/lang/String;

    const-string v3, "\\|"

    const/4 v4, -0x1

    invoke-virtual {v0, v3, v4}, Ljava/lang/String;->split(Ljava/lang/String;I)[Ljava/lang/String;

    move-result-object v0

    array-length v3, v0

    const/4 v4, 0x6

    if-lt v3, v4, :cond_c8

    aget-object v3, v0, v2

    const-string v5, "true"

    invoke-virtual {v5, v3}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v3

    sput-boolean v3, Lcom/floatingmenu/MenuLoader;->sSim1Enabled:Z

    aget-object v3, v0, v1

    sput-object v3, Lcom/floatingmenu/MenuLoader;->sSim1Provider:Ljava/lang/String;

    const/4 v3, 0x2

    aget-object v6, v0, v3

    sput-object v6, Lcom/floatingmenu/MenuLoader;->sSim1Number:Ljava/lang/String;

    const/4 v6, 0x3

    aget-object v7, v0, v6

    invoke-virtual {v5, v7}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v7

    sput-boolean v7, Lcom/floatingmenu/MenuLoader;->sSim2Enabled:Z

    const/4 v7, 0x4

    aget-object v8, v0, v7

    sput-object v8, Lcom/floatingmenu/MenuLoader;->sSim2Provider:Ljava/lang/String;

    const/4 v8, 0x5

    aget-object v9, v0, v8

    sput-object v9, Lcom/floatingmenu/MenuLoader;->sSim2Number:Ljava/lang/String;

    array-length v9, v0

    const/4 v10, 0x7

    if-lt v9, v10, :cond_53

    aget-object v4, v0, v4

    sput-object v4, Lcom/floatingmenu/MenuLoader;->sSimCountry:Ljava/lang/String;

    if-eqz v4, :cond_4f

    invoke-virtual {v4}, Ljava/lang/String;->isEmpty()Z

    move-result v4

    if-eqz v4, :cond_53

    :cond_4f
    const-string v4, "in"

    sput-object v4, Lcom/floatingmenu/MenuLoader;->sSimCountry:Ljava/lang/String;

    :cond_53
    const/4 v4, 0x0

    sput-boolean v4, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    const/4 v4, 0x0

    sput-boolean v4, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    :cond_6d
    iget-object v4, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->this$2:Lcom/floatingmenu/MenuLoader$1$1$1;

    iget-object v4, v4, Lcom/floatingmenu/MenuLoader$1$1$1;->val$prefs:Landroid/content/SharedPreferences;

    invoke-interface {v4}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    const-string v5, "sim1_enabled"

    aget-object v9, v0, v2

    invoke-interface {v4, v5, v9}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    const-string v5, "sim1_provider"

    aget-object v9, v0, v1

    invoke-interface {v4, v5, v9}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v4

    const-string v5, "sim1_number"

    aget-object v3, v0, v3

    invoke-interface {v4, v5, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    const-string v4, "sim2_enabled"

    aget-object v5, v0, v6

    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    const-string v4, "sim2_provider"

    aget-object v5, v0, v7

    invoke-interface {v3, v4, v5}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v3

    const-string v4, "sim2_number"

    aget-object v0, v0, v8

    invoke-interface {v3, v4, v0}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v3, "sim_country"

    sget-object v4, Lcom/floatingmenu/MenuLoader;->sSimCountry:Ljava/lang/String;

    invoke-interface {v0, v3, v4}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    sget-boolean v3, Lcom/floatingmenu/MenuLoader;->sIamNotDeveloper:Z

    invoke-static {v3}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v3

    const-string v4, "iamnotdeveloper"

    invoke-interface {v0, v4, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    sget-boolean v3, Lcom/floatingmenu/MenuLoader;->sIamNoRoot:Z

    invoke-static {v3}, Ljava/lang/String;->valueOf(Z)Ljava/lang/String;

    move-result-object v3

    const-string v4, "iamnoroot"

    invoke-interface {v0, v4, v3}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    :cond_c8
    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->val$globalKey:Ljava/lang/String;

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    const-string v3, "validation_status"

    const-string v4, "license_key"

    const-string v5, "is_licensed"

    if-eqz v0, :cond_f9

    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->this$2:Lcom/floatingmenu/MenuLoader$1$1$1;

    iget-object v0, v0, Lcom/floatingmenu/MenuLoader$1$1$1;->val$prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0, v5, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, ""

    invoke-interface {v0, v4, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    const-string v1, "invalid"

    :goto_ea
    invoke-interface {v0, v3, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    sget-boolean v0, Lcom/floatingmenu/MenuLoader;->sIsTargetPackage:Z

    if-nez v0, :goto_147

    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->this$2:Lcom/floatingmenu/MenuLoader$1$1$1;

    iget-object v0, v0, Lcom/floatingmenu/MenuLoader$1$1$1;->val$activity:Landroid/app/Activity;

    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$700(Landroid/app/Activity;)V

    goto :goto_147

    :cond_f9
    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->val$globalStatus:Ljava/lang/String;

    const-string v6, "active"

    invoke-virtual {v6, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_132

    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->this$2:Lcom/floatingmenu/MenuLoader$1$1$1;

    iget-object v0, v0, Lcom/floatingmenu/MenuLoader$1$1$1;->val$prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0, v5, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    if-nez v0, :cond_126

    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->this$2:Lcom/floatingmenu/MenuLoader$1$1$1;

    iget-object v0, v0, Lcom/floatingmenu/MenuLoader$1$1$1;->val$prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0, v5, v1}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->val$globalKey:Ljava/lang/String;

    invoke-interface {v0, v4, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0, v3, v6}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0}, Landroid/content/SharedPreferences$Editor;->apply()V

    :cond_126
    sget-boolean v0, Lcom/floatingmenu/MenuLoader;->sIsTargetPackage:Z

    if-eqz v0, :cond_147

    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->this$2:Lcom/floatingmenu/MenuLoader$1$1$1;

    iget-object v0, v0, Lcom/floatingmenu/MenuLoader$1$1$1;->val$activity:Landroid/app/Activity;

    invoke-static {v0}, Lcom/floatingmenu/FloatingMenu;->show(Landroid/app/Activity;)V

    goto :goto_147

    :cond_132
    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->this$2:Lcom/floatingmenu/MenuLoader$1$1$1;

    iget-object v0, v0, Lcom/floatingmenu/MenuLoader$1$1$1;->val$prefs:Landroid/content/SharedPreferences;

    invoke-interface {v0}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    invoke-interface {v0, v5, v2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->val$globalKey:Ljava/lang/String;

    invoke-interface {v0, v4, v1}, Landroid/content/SharedPreferences$Editor;->putString(Ljava/lang/String;Ljava/lang/String;)Landroid/content/SharedPreferences$Editor;

    move-result-object v0

    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$1$1$1$1;->val$globalStatus:Ljava/lang/String;

    goto :goto_ea

    :cond_147
    :goto_147
    return-void
.end method
