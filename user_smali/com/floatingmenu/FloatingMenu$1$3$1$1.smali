.class Lcom/floatingmenu/FloatingMenu$1$3$1$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$2:Lcom/floatingmenu/FloatingMenu$1$3$1;

.field final synthetic val$success:Z


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1$3$1;Z)V
    .registers 3

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$3$1$1;->this$2:Lcom/floatingmenu/FloatingMenu$1$3$1;

    iput-boolean p2, p0, Lcom/floatingmenu/FloatingMenu$1$3$1$1;->val$success:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 11

    iget-boolean v0, p0, Lcom/floatingmenu/FloatingMenu$1$3$1$1;->val$success:Z

    if-eqz v0, :cond_29

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$3$1$1;->this$2:Lcom/floatingmenu/FloatingMenu$1$3$1;

    iget-boolean v1, v0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s1e:Z

    iget-object v2, v0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s1p:Ljava/lang/String;

    iget-object v3, v0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s1n:Ljava/lang/String;

    iget-boolean v4, v0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s2e:Z

    iget-object v5, v0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s2p:Ljava/lang/String;

    iget-object v6, v0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s2n:Ljava/lang/String;

    iget-object v7, v0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$country:Ljava/lang/String;

    iget-boolean v8, v0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$iamNotDev:Z

    iget-boolean v9, v0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$iamNoRoot:Z

    invoke-static/range {v1 .. v9}, Lcom/floatingmenu/MenuLoader;->updateMockSimSettingsEx2(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$3$1$1;->this$2:Lcom/floatingmenu/FloatingMenu$1$3$1;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$3$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$3;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$3;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const-string v1, "SIM settings saved successfully!"

    :goto_25
    # invokes: Lcom/floatingmenu/FloatingMenu;->showToast(Landroid/content/Context;Ljava/lang/String;)V
    invoke-static {v0, v1}, Lcom/floatingmenu/FloatingMenu;->access$200(Landroid/content/Context;Ljava/lang/String;)V

    goto :goto_34

    :cond_29
    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$3$1$1;->this$2:Lcom/floatingmenu/FloatingMenu$1$3$1;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$3$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$3;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$3;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    const-string v1, "Failed to save SIM settings."

    goto :goto_25

    :goto_34
    return-void
.end method
