.class Lcom/astik/module/MainActivity$3;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/astik/module/MainActivity;->onCreate(Landroid/os/Bundle;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/astik/module/MainActivity;


# direct methods
.method constructor <init>(Lcom/astik/module/MainActivity;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 176
    iput-object p1, p0, Lcom/astik/module/MainActivity$3;->this$0:Lcom/astik/module/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .locals 3

    .line 179
    iget-object p1, p0, Lcom/astik/module/MainActivity$3;->this$0:Lcom/astik/module/MainActivity;

    invoke-static {p1}, Lcom/astik/module/MainActivity;->access$300(Lcom/astik/module/MainActivity;)Z

    move-result p1

    if-eqz p1, :cond_0

    return-void

    .line 180
    :cond_0
    iget-object p1, p0, Lcom/astik/module/MainActivity$3;->this$0:Lcom/astik/module/MainActivity;

    invoke-static {p1}, Lcom/astik/module/MainActivity;->access$400(Lcom/astik/module/MainActivity;)Landroid/content/SharedPreferences;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    const-string v0, "service_on"

    invoke-interface {p1, v0, p2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    const/4 p1, 0x0

    if-eqz p2, :cond_1

    .line 182
    iget-object p2, p0, Lcom/astik/module/MainActivity$3;->this$0:Lcom/astik/module/MainActivity;

    new-instance v0, Landroid/content/Intent;

    iget-object v1, p0, Lcom/astik/module/MainActivity$3;->this$0:Lcom/astik/module/MainActivity;

    const-class v2, Lcom/astik/module/TelegramPollingService;

    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p2, v0}, Lcom/astik/module/MainActivity;->startForegroundService(Landroid/content/Intent;)Landroid/content/ComponentName;

    .line 183
    iget-object p2, p0, Lcom/astik/module/MainActivity$3;->this$0:Lcom/astik/module/MainActivity;

    const-string v0, "Service started \u2014 always alive"

    invoke-static {p2, v0, p1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    goto :goto_0

    .line 185
    :cond_1
    iget-object p2, p0, Lcom/astik/module/MainActivity$3;->this$0:Lcom/astik/module/MainActivity;

    new-instance v0, Landroid/content/Intent;

    iget-object v1, p0, Lcom/astik/module/MainActivity$3;->this$0:Lcom/astik/module/MainActivity;

    const-class v2, Lcom/astik/module/TelegramPollingService;

    invoke-direct {v0, v1, v2}, Landroid/content/Intent;-><init>(Landroid/content/Context;Ljava/lang/Class;)V

    invoke-virtual {p2, v0}, Lcom/astik/module/MainActivity;->stopService(Landroid/content/Intent;)Z

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

    const-string v0, "Service stopped"

    invoke-static {p2, v0, p1}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p1

    invoke-virtual {p1}, Landroid/widget/Toast;->show()V

    .line 188
    :goto_0
    iget-object p1, p0, Lcom/astik/module/MainActivity$3;->this$0:Lcom/astik/module/MainActivity;

    invoke-static {p1}, Lcom/astik/module/MainActivity;->access$500(Lcom/astik/module/MainActivity;)V

    return-void
.end method
