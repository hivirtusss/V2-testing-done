.class Lcom/floatingmenu/FloatingMenu$1$11;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/FloatingMenu$1;

.field final synthetic val$inputTgChatId:Landroid/widget/EditText;

.field final synthetic val$inputTgToken:Landroid/widget/EditText;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/EditText;Landroid/widget/EditText;)V
    .registers 4

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$11;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iput-object p2, p0, Lcom/floatingmenu/FloatingMenu$1$11;->val$inputTgToken:Landroid/widget/EditText;

    iput-object p3, p0, Lcom/floatingmenu/FloatingMenu$1$11;->val$inputTgChatId:Landroid/widget/EditText;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 5

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$11;->val$inputTgToken:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$11;->val$inputTgChatId:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-nez v1, :cond_40

    invoke-virtual {v0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_29

    goto :goto_40

    :cond_29
    iget-object v1, p0, Lcom/floatingmenu/FloatingMenu$1$11;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iget-object v1, v1, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const-string v2, "Saving & Sending Test Message..."

    # invokes: Lcom/floatingmenu/FloatingMenu;->showToast(Landroid/content/Context;Ljava/lang/String;)V
    invoke-static {v1, v2}, Lcom/floatingmenu/FloatingMenu;->access$200(Landroid/content/Context;Ljava/lang/String;)V

    new-instance v1, Ljava/lang/Thread;

    new-instance v2, Lcom/floatingmenu/FloatingMenu$1$11$1;

    invoke-direct {v2, p0, p1, v0}, Lcom/floatingmenu/FloatingMenu$1$11$1;-><init>(Lcom/floatingmenu/FloatingMenu$1$11;Ljava/lang/String;Ljava/lang/String;)V

    invoke-direct {v1, v2}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {v1}, Ljava/lang/Thread;->start()V

    return-void

    :cond_40
    :goto_40
    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$11;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iget-object p1, p1, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const-string v0, "Please enter both Bot Token and Chat ID."

    # invokes: Lcom/floatingmenu/FloatingMenu;->showToast(Landroid/content/Context;Ljava/lang/String;)V
    invoke-static {p1, v0}, Lcom/floatingmenu/FloatingMenu;->access$200(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method
