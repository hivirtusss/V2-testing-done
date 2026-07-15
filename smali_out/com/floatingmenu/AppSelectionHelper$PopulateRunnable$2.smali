.class Lcom/floatingmenu/AppSelectionHelper$PopulateRunnable$2;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/AppSelectionHelper$PopulateRunnable;

.field final synthetic val$apps:Ljava/util/List;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/AppSelectionHelper$PopulateRunnable;Ljava/util/List;)V
    .registers 3

    iput-object p1, p0, Lcom/floatingmenu/AppSelectionHelper$PopulateRunnable$2;->this$0:Lcom/floatingmenu/AppSelectionHelper$PopulateRunnable;

    iput-object p2, p0, Lcom/floatingmenu/AppSelectionHelper$PopulateRunnable$2;->val$apps:Ljava/util/List;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 6

    sget-object v0, Lcom/floatingmenu/AppSelectionHelper;->sListContainer:Landroid/widget/LinearLayout;

    if-nez v0, :cond_0

    return-void

    :cond_0
    invoke-virtual {v0}, Landroid/view/ViewGroup;->removeAllViews()V

    iget-object v0, p0, Lcom/floatingmenu/AppSelectionHelper$PopulateRunnable$2;->val$apps:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_loop
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_end

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/content/pm/ApplicationInfo;

    iget-object v2, v1, Landroid/content/pm/ApplicationInfo;->packageName:Ljava/lang/String;

    if-eqz v2, :goto_loop

    const-string v3, "android"

    invoke-virtual {v3, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v3

    if-eqz v3, :cond_skip

    goto :goto_loop

    :cond_skip
    invoke-static {v2}, Lcom/floatingmenu/AppSelectionHelper;->isBlockedPackage(Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :goto_loop

    iget-object v3, p0, Lcom/floatingmenu/AppSelectionHelper$PopulateRunnable$2;->this$0:Lcom/floatingmenu/AppSelectionHelper$PopulateRunnable;

    iget-object v3, v3, Lcom/floatingmenu/AppSelectionHelper$PopulateRunnable;->val$context:Landroid/content/Context;

    invoke-static {v3, v1}, Lcom/floatingmenu/AppSelectionHelper;->buildAppRow(Landroid/content/Context;Landroid/content/pm/ApplicationInfo;)Landroid/widget/LinearLayout;

    move-result-object v1

    sget-object v2, Lcom/floatingmenu/AppSelectionHelper;->sListContainer:Landroid/widget/LinearLayout;

    invoke-virtual {v2, v1}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V

    goto :goto_loop

    :cond_end
    return-void
.end method
