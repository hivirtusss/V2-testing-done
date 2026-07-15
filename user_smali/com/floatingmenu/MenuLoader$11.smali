.class Lcom/floatingmenu/MenuLoader$11;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic val$status:Ljava/lang/String;


# direct methods
.method public constructor <init>(Ljava/lang/String;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$11;->val$status:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    # getter for: Lcom/floatingmenu/MenuLoader;->sSystemUiErrorText:Landroid/widget/TextView;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$2800()Landroid/widget/TextView;

    move-result-object v0

    if-nez v0, :cond_7

    return-void

    :cond_7
    const-string v0, "blocked"

    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$11;->val$status:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, "pending"

    if-eqz v0, :cond_16

    const-string v0, "License key is blocked!"

    goto :goto_64

    :cond_16
    const-string v0, "expired"

    iget-object v2, p0, Lcom/floatingmenu/MenuLoader$11;->val$status:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_23

    const-string v0, "License key has expired!"

    goto :goto_64

    :cond_23
    const-string v0, "device_mismatch"

    iget-object v2, p0, Lcom/floatingmenu/MenuLoader$11;->val$status:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_30

    const-string v0, "Key used on another device!"

    goto :goto_64

    :cond_30
    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$11;->val$status:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_3b

    const-string v0, "Verifying key..."

    goto :goto_64

    :cond_3b
    const-string v0, "timeout"

    iget-object v2, p0, Lcom/floatingmenu/MenuLoader$11;->val$status:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_48

    const-string v0, "Verification timeout! Try again."

    goto :goto_64

    :cond_48
    const-string v0, "invalid"

    iget-object v2, p0, Lcom/floatingmenu/MenuLoader$11;->val$status:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_55

    const-string v0, "Invalid license key!"

    goto :goto_64

    :cond_55
    const-string v0, "required"

    iget-object v2, p0, Lcom/floatingmenu/MenuLoader$11;->val$status:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_62

    const-string v0, "License key required!"

    goto :goto_64

    :cond_62
    const-string v0, ""

    :goto_64
    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v2

    if-nez v2, :cond_a4

    # getter for: Lcom/floatingmenu/MenuLoader;->sSystemUiErrorText:Landroid/widget/TextView;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$2800()Landroid/widget/TextView;

    move-result-object v2

    invoke-virtual {v2, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    # getter for: Lcom/floatingmenu/MenuLoader;->sSystemUiErrorText:Landroid/widget/TextView;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$2800()Landroid/widget/TextView;

    move-result-object v0

    const/4 v2, 0x0

    invoke-virtual {v0, v2}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$11;->val$status:Ljava/lang/String;

    invoke-virtual {v1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_ad

    # getter for: Lcom/floatingmenu/MenuLoader;->sSystemUiCard:Landroid/view/View;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$2600()Landroid/view/View;

    move-result-object v0

    if-eqz v0, :cond_ad

    # getter for: Lcom/floatingmenu/MenuLoader;->sSystemUiCard:Landroid/view/View;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$2600()Landroid/view/View;

    move-result-object v0

    invoke-static {v0}, Lcom/floatingmenu/g;->a(Landroid/view/View;)Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-static {v0}, Lcom/floatingmenu/g;->b(Landroid/view/ViewPropertyAnimator;)Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-static {v0}, Lcom/floatingmenu/g;->c(Landroid/view/ViewPropertyAnimator;)Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    new-instance v1, Lcom/floatingmenu/MenuLoader$11$1;

    invoke-direct {v1, p0}, Lcom/floatingmenu/MenuLoader$11$1;-><init>(Lcom/floatingmenu/MenuLoader$11;)V

    invoke-static {v0, v1}, Lcom/floatingmenu/a;->a(Landroid/view/ViewPropertyAnimator;Ljava/lang/Runnable;)Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-static {v0}, Lcom/floatingmenu/b;->b(Landroid/view/ViewPropertyAnimator;)V

    goto :goto_ad

    :cond_a4
    # getter for: Lcom/floatingmenu/MenuLoader;->sSystemUiErrorText:Landroid/widget/TextView;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$2800()Landroid/widget/TextView;

    move-result-object v0

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    :cond_ad
    :goto_ad
    return-void
.end method
