.class Lcom/floatingmenu/FloatingMenu$1$3;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/FloatingMenu$1;

.field final synthetic val$inputCountry:Landroid/widget/EditText;

.field final synthetic val$inputSim1Number:Landroid/widget/EditText;

.field final synthetic val$inputSim2Number:Landroid/widget/EditText;

.field final synthetic val$sim1Provider:[Ljava/lang/String;

.field final synthetic val$sim2Provider:[Ljava/lang/String;

.field final synthetic val$switchDev:Landroid/widget/Switch;

.field final synthetic val$switchNoRoot:Landroid/widget/Switch;

.field final synthetic val$switchSim1:Landroid/widget/Switch;

.field final synthetic val$switchSim2:Landroid/widget/Switch;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/Switch;[Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/Switch;[Ljava/lang/String;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/Switch;Landroid/widget/Switch;)V
    .registers 11

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$3;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iput-object p2, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$switchSim1:Landroid/widget/Switch;

    iput-object p3, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$sim1Provider:[Ljava/lang/String;

    iput-object p4, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$inputSim1Number:Landroid/widget/EditText;

    iput-object p5, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$switchSim2:Landroid/widget/Switch;

    iput-object p6, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$sim2Provider:[Ljava/lang/String;

    iput-object p7, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$inputSim2Number:Landroid/widget/EditText;

    iput-object p8, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$inputCountry:Landroid/widget/EditText;

    iput-object p9, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$switchDev:Landroid/widget/Switch;

    iput-object p10, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$switchNoRoot:Landroid/widget/Switch;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 14

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$switchSim1:Landroid/widget/Switch;

    invoke-static {p1}, Lcom/floatingmenu/b;->h(Landroid/widget/Switch;)Z

    move-result v2

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$sim1Provider:[Ljava/lang/String;

    const/4 v0, 0x0

    aget-object v3, p1, v0

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$inputSim1Number:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v4

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$switchSim2:Landroid/widget/Switch;

    invoke-static {p1}, Lcom/floatingmenu/b;->h(Landroid/widget/Switch;)Z

    move-result v5

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$sim2Provider:[Ljava/lang/String;

    aget-object v6, p1, v0

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$inputSim2Number:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v7

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$3;->val$inputCountry:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v8

    const/4 v9, 0x0

    const/4 v10, 0x0

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$3;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iget-object p1, p1, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const-string v0, "Saving SIM settings..."

    # invokes: Lcom/floatingmenu/FloatingMenu;->showToast(Landroid/content/Context;Ljava/lang/String;)V
    invoke-static {p1, v0}, Lcom/floatingmenu/FloatingMenu;->access$200(Landroid/content/Context;Ljava/lang/String;)V

    new-instance p1, Ljava/lang/Thread;

    new-instance v11, Lcom/floatingmenu/FloatingMenu$1$3$1;

    move-object v0, v11

    move-object v1, p0

    invoke-direct/range {v0 .. v10}, Lcom/floatingmenu/FloatingMenu$1$3$1;-><init>(Lcom/floatingmenu/FloatingMenu$1$3;ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)V

    invoke-direct {p1, v11}, Ljava/lang/Thread;-><init>(Ljava/lang/Runnable;)V

    invoke-virtual {p1}, Ljava/lang/Thread;->start()V

    return-void
.end method
