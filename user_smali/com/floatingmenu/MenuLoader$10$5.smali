.class Lcom/floatingmenu/MenuLoader$10$5;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/MenuLoader$10;

.field final synthetic val$errorText:Landroid/widget/TextView;

.field final synthetic val$input:Landroid/widget/EditText;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/MenuLoader$10;Landroid/widget/EditText;Landroid/widget/TextView;)V
    .registers 4

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$10$5;->this$0:Lcom/floatingmenu/MenuLoader$10;

    iput-object p2, p0, Lcom/floatingmenu/MenuLoader$10$5;->val$input:Landroid/widget/EditText;

    iput-object p3, p0, Lcom/floatingmenu/MenuLoader$10$5;->val$errorText:Landroid/widget/TextView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 5

    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$10$5;->val$input:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_22

    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$10$5;->val$errorText:Landroid/widget/TextView;

    const-string v0, "Enter a license key!"

    invoke-virtual {p1, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$10$5;->val$errorText:Landroid/widget/TextView;

    invoke-virtual {p1, v1}, Landroid/view/View;->setVisibility(I)V

    return-void

    :cond_22
    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$10$5;->val$errorText:Landroid/widget/TextView;

    const-string v2, "Verifying key..."

    invoke-virtual {v0, v2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$10$5;->val$errorText:Landroid/widget/TextView;

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    new-instance v0, Ljava/lang/Thread;

    new-instance v1, Lcom/floatingmenu/MenuLoader$10$5$1;

    invoke-direct {v1, p0, p1}, Lcom/floatingmenu/MenuLoader$10$5$1;-><init>(Lcom/floatingmenu/MenuLoader$10$5;Ljava/lang/String;)V

    invoke-direct {v0, v1}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v0}, Ljava/lang/Thread;->start()V

    return-void
.end method
