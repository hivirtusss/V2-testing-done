.class Lcom/floatingmenu/FloatingMenu$1$11$1$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$2:Lcom/floatingmenu/FloatingMenu$1$11$1;

.field final synthetic val$success:Z


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1$11$1;Z)V
    .registers 3

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$11$1$1;->this$2:Lcom/floatingmenu/FloatingMenu$1$11$1;

    iput-boolean p2, p0, Lcom/floatingmenu/FloatingMenu$1$11$1$1;->val$success:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    iget-boolean v0, p0, Lcom/floatingmenu/FloatingMenu$1$11$1$1;->val$success:Z

    if-eqz v0, :cond_12

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$11$1$1;->this$2:Lcom/floatingmenu/FloatingMenu$1$11$1;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$11$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$11;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$11;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const-string v1, "Credentials saved and test message sent!"

    :goto_e
    # invokes: Lcom/floatingmenu/FloatingMenu;->showToast(Landroid/content/Context;Ljava/lang/String;)V
    invoke-static {v0, v1}, Lcom/floatingmenu/FloatingMenu;->access$200(Landroid/content/Context;Ljava/lang/String;)V

    goto :goto_1d

    :cond_12
    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$11$1$1;->this$2:Lcom/floatingmenu/FloatingMenu$1$11$1;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$11$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$11;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$11;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const-string v1, "Failed to save configuration via socket."

    goto :goto_e

    :goto_1d
    return-void
.end method
