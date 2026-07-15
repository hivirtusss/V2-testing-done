.class Lcom/floatingmenu/FloatingMenu$1$3$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$1:Lcom/floatingmenu/FloatingMenu$1$3;

.field final synthetic val$country:Ljava/lang/String;

.field final synthetic val$iamNoRoot:Z

.field final synthetic val$iamNotDev:Z

.field final synthetic val$s1e:Z

.field final synthetic val$s1n:Ljava/lang/String;

.field final synthetic val$s1p:Ljava/lang/String;

.field final synthetic val$s2e:Z

.field final synthetic val$s2n:Ljava/lang/String;

.field final synthetic val$s2p:Ljava/lang/String;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1$3;ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)V
    .registers 11

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$3;

    iput-boolean p2, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s1e:Z

    iput-object p3, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s1p:Ljava/lang/String;

    iput-object p4, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s1n:Ljava/lang/String;

    iput-boolean p5, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s2e:Z

    iput-object p6, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s2p:Ljava/lang/String;

    iput-object p7, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s2n:Ljava/lang/String;

    iput-object p8, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$country:Ljava/lang/String;

    iput-boolean p9, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$iamNotDev:Z

    iput-boolean p10, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$iamNoRoot:Z

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 10

    iget-boolean v0, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s1e:Z

    iget-object v1, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s1p:Ljava/lang/String;

    iget-object v2, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s1n:Ljava/lang/String;

    iget-boolean v3, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s2e:Z

    iget-object v4, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s2p:Ljava/lang/String;

    iget-object v5, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$s2n:Ljava/lang/String;

    iget-object v6, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$country:Ljava/lang/String;

    iget-boolean v7, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$iamNotDev:Z

    iget-boolean v8, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->val$iamNoRoot:Z

    invoke-static/range {v0 .. v8}, Lcom/floatingmenu/FloatingMenu;->saveSimSettingsEx(ZLjava/lang/String;Ljava/lang/String;ZLjava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZ)Z

    move-result v0

    iget-object v1, p0, Lcom/floatingmenu/FloatingMenu$1$3$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$3;

    iget-object v1, v1, Lcom/floatingmenu/FloatingMenu$1$3;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iget-object v1, v1, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    new-instance v2, Lcom/floatingmenu/FloatingMenu$1$3$1$1;

    invoke-direct {v2, p0, v0}, Lcom/floatingmenu/FloatingMenu$1$3$1$1;-><init>(Lcom/floatingmenu/FloatingMenu$1$3$1;Z)V

    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method
