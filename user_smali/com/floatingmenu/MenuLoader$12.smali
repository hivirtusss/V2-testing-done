.class Lcom/floatingmenu/MenuLoader$12;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic val$app:Landroid/app/Application;


# direct methods
.method public constructor <init>(Landroid/app/Application;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$12;->val$app:Landroid/app/Application;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    const-string v0, "ZygiskMenu @Hivirtus"

    # getter for: Lcom/floatingmenu/MenuLoader;->sSystemUiOverlay:Landroid/view/View;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$2300()Landroid/view/View;

    move-result-object v1

    if-eqz v1, :cond_34

    :try_start_8
    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$12;->val$app:Landroid/app/Application;

    const-string v2, "window"

    invoke-virtual {v1, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/view/WindowManager;

    if-eqz v1, :cond_27

    # getter for: Lcom/floatingmenu/MenuLoader;->sSystemUiOverlay:Landroid/view/View;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$2300()Landroid/view/View;

    move-result-object v2

    invoke-interface {v1, v2}, Landroid/view/ViewManager;->removeView(Landroid/view/View;)V

    const-string v1, "SystemUI Overlay dismissed from WindowManager."

    invoke-static {v0, v1}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_20
    .catch Ljava/lang/Exception; {:try_start_8 .. :try_end_20} :catch_21

    goto :goto_27

    :catch_21
    move-exception v1

    const-string v2, "Error dismissing SystemUI overlay: "

    invoke-static {v0, v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_27
    :goto_27
    const/4 v0, 0x0

    # setter for: Lcom/floatingmenu/MenuLoader;->sSystemUiOverlay:Landroid/view/View;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$2302(Landroid/view/View;)Landroid/view/View;

    # setter for: Lcom/floatingmenu/MenuLoader;->sSystemUiErrorText:Landroid/widget/TextView;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$2802(Landroid/widget/TextView;)Landroid/widget/TextView;

    # setter for: Lcom/floatingmenu/MenuLoader;->sSystemUiInput:Landroid/widget/EditText;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$2702(Landroid/widget/EditText;)Landroid/widget/EditText;

    # setter for: Lcom/floatingmenu/MenuLoader;->sSystemUiCard:Landroid/view/View;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$2602(Landroid/view/View;)Landroid/view/View;

    :cond_34
    return-void
.end method
