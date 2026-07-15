.class Lcom/floatingmenu/FloatingMenu$1$8;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/FloatingMenu$1;

.field final synthetic val$bodyLabel:Landroid/widget/TextView;

.field final synthetic val$injectBtn:Landroid/widget/Button;

.field final synthetic val$inputBody:Landroid/widget/EditText;

.field final synthetic val$inputSender:Landroid/widget/EditText;

.field final synthetic val$msgDivider:Landroid/view/View;

.field final synthetic val$senderLabel:Landroid/widget/TextView;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/view/View;Landroid/widget/TextView;Landroid/widget/EditText;Landroid/widget/TextView;Landroid/widget/EditText;Landroid/widget/Button;)V
    .registers 8

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$8;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iput-object p2, p0, Lcom/floatingmenu/FloatingMenu$1$8;->val$msgDivider:Landroid/view/View;

    iput-object p3, p0, Lcom/floatingmenu/FloatingMenu$1$8;->val$senderLabel:Landroid/widget/TextView;

    iput-object p4, p0, Lcom/floatingmenu/FloatingMenu$1$8;->val$inputSender:Landroid/widget/EditText;

    iput-object p5, p0, Lcom/floatingmenu/FloatingMenu$1$8;->val$bodyLabel:Landroid/widget/TextView;

    iput-object p6, p0, Lcom/floatingmenu/FloatingMenu$1$8;->val$inputBody:Landroid/widget/EditText;

    iput-object p7, p0, Lcom/floatingmenu/FloatingMenu$1$8;->val$injectBtn:Landroid/widget/Button;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .registers 4

    sput-boolean p2, Lcom/floatingmenu/FloatingMenu;->sHookIncoming:Z

    if-eqz p2, :cond_6

    const/4 p1, 0x0

    goto :goto_8

    :cond_6
    const/16 p1, 0x8

    :goto_8
    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$8;->val$msgDivider:Landroid/view/View;

    invoke-virtual {v0, p1}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$8;->val$senderLabel:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$8;->val$inputSender:Landroid/widget/EditText;

    invoke-virtual {v0, p1}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$8;->val$bodyLabel:Landroid/widget/TextView;

    invoke-virtual {v0, p1}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$8;->val$inputBody:Landroid/widget/EditText;

    invoke-virtual {v0, p1}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$8;->val$injectBtn:Landroid/widget/Button;

    invoke-virtual {v0, p1}, Landroid/view/View;->setVisibility(I)V

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$8;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iget-object p1, p1, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    if-eqz p2, :cond_2f

    const-string p2, "ON"

    goto :goto_31

    :cond_2f
    const-string p2, "OFF"

    :goto_31
    const-string v0, "Hook Incoming SMS: "

    invoke-virtual {v0, p2}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    # invokes: Lcom/floatingmenu/FloatingMenu;->showToast(Landroid/content/Context;Ljava/lang/String;)V
    invoke-static {p1, p2}, Lcom/floatingmenu/FloatingMenu;->access$200(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method
