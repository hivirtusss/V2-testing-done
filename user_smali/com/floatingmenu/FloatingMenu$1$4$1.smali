.class Lcom/floatingmenu/FloatingMenu$1$4$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$1:Lcom/floatingmenu/FloatingMenu$1$4;

.field final synthetic val$settings:[Ljava/lang/String;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1$4;[Ljava/lang/String;)V
    .registers 3

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$4;

    iput-object p2, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->val$settings:[Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 13

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->val$settings:[Ljava/lang/String;

    const/4 v1, 0x0

    aget-object v0, v0, v1

    const-string v2, "true"

    invoke-virtual {v2, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    iget-object v3, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->val$settings:[Ljava/lang/String;

    const/4 v4, 0x1

    aget-object v4, v3, v4

    const/4 v5, 0x2

    aget-object v5, v3, v5

    const/4 v6, 0x3

    aget-object v3, v3, v6

    invoke-virtual {v2, v3}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v3

    iget-object v6, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->val$settings:[Ljava/lang/String;

    const/4 v7, 0x4

    aget-object v7, v6, v7

    const/4 v8, 0x5

    aget-object v8, v6, v8

    array-length v9, v6

    const-string v10, "in"

    const/4 v11, 0x7

    if-lt v9, v11, :cond_2c

    const/4 v9, 0x6

    aget-object v6, v6, v9

    goto :goto_2d

    :cond_2c
    move-object v6, v10

    :goto_2d
    if-eqz v6, :cond_37

    invoke-virtual {v6}, Ljava/lang/String;->isEmpty()Z

    move-result v9

    if-eqz v9, :cond_36

    goto :goto_37

    :cond_36
    move-object v10, v6

    :cond_37
    :goto_37
    iget-object v6, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$4;

    iget-object v6, v6, Lcom/floatingmenu/FloatingMenu$1$4;->val$switchSim1:Landroid/widget/Switch;

    invoke-static {v6, v0}, Lcom/floatingmenu/b;->g(Landroid/widget/Switch;Z)V

    iget-object v6, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$4;

    iget-object v6, v6, Lcom/floatingmenu/FloatingMenu$1$4;->val$sim1Container:Landroid/widget/LinearLayout;

    const/16 v9, 0x8

    if-eqz v0, :cond_48

    const/4 v0, 0x0

    goto :goto_4a

    :cond_48
    const/16 v0, 0x8

    :goto_4a
    invoke-virtual {v6, v0}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$4;

    iget-object v6, v0, Lcom/floatingmenu/FloatingMenu$1$4;->val$sim1Provider:[Ljava/lang/String;

    aput-object v4, v6, v1

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$4;->val$sim1Selector:Landroid/widget/LinearLayout;

    # invokes: Lcom/floatingmenu/FloatingMenu;->updateSelector(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    invoke-static {v0, v4}, Lcom/floatingmenu/FloatingMenu;->access$300(Landroid/widget/LinearLayout;Ljava/lang/String;)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$4;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$4;->val$inputSim1Number:Landroid/widget/EditText;

    invoke-virtual {v0, v5}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$4;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$4;->val$switchSim2:Landroid/widget/Switch;

    invoke-static {v0, v3}, Lcom/floatingmenu/b;->g(Landroid/widget/Switch;Z)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$4;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$4;->val$sim2Container:Landroid/widget/LinearLayout;

    if-eqz v3, :cond_6e

    const/4 v3, 0x0

    goto :goto_70

    :cond_6e
    const/16 v3, 0x8

    :goto_70
    invoke-virtual {v0, v3}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$4;

    iget-object v3, v0, Lcom/floatingmenu/FloatingMenu$1$4;->val$sim2Provider:[Ljava/lang/String;

    aput-object v7, v3, v1

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$4;->val$sim2Selector:Landroid/widget/LinearLayout;

    # invokes: Lcom/floatingmenu/FloatingMenu;->updateSelector(Landroid/widget/LinearLayout;Ljava/lang/String;)V
    invoke-static {v0, v7}, Lcom/floatingmenu/FloatingMenu;->access$300(Landroid/widget/LinearLayout;Ljava/lang/String;)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$4;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$4;->val$inputSim2Number:Landroid/widget/EditText;

    invoke-virtual {v0, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$4;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$4;->val$inputCountry:Landroid/widget/EditText;

    invoke-virtual {v0, v10}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->val$settings:[Ljava/lang/String;

    array-length v3, v0

    if-lt v3, v9, :cond_98

    aget-object v0, v0, v11

    invoke-virtual {v2, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v0

    goto :goto_99

    :cond_98
    const/4 v0, 0x0

    :goto_99
    iget-object v3, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$4;

    iget-object v3, v3, Lcom/floatingmenu/FloatingMenu$1$4;->val$switchDev:Landroid/widget/Switch;

    invoke-static {v3, v0}, Lcom/floatingmenu/b;->g(Landroid/widget/Switch;Z)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->val$settings:[Ljava/lang/String;

    array-length v3, v0

    const/16 v4, 0x9

    if-lt v3, v4, :cond_ad

    aget-object v0, v0, v9

    invoke-virtual {v2, v0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v1

    :cond_ad
    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$4$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$4;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$4;->val$switchNoRoot:Landroid/widget/Switch;

    invoke-static {v0, v1}, Lcom/floatingmenu/b;->g(Landroid/widget/Switch;Z)V

    return-void
.end method
