.class Lcom/floatingmenu/FloatingMenu$1$9;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/FloatingMenu$1;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$9;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .registers 4

    sput-boolean p2, Lcom/floatingmenu/FloatingMenu;->sHookOutgoing:Z

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$9;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iget-object p1, p1, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    if-eqz p2, :cond_b

    const-string p2, "ON"

    goto :goto_d

    :cond_b
    const-string p2, "OFF"

    :goto_d
    const-string v0, "Hook Outgoing SMS: "

    invoke-virtual {v0, p2}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p2

    # invokes: Lcom/floatingmenu/FloatingMenu;->showToast(Landroid/content/Context;Ljava/lang/String;)V
    invoke-static {p1, p2}, Lcom/floatingmenu/FloatingMenu;->access$200(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method
