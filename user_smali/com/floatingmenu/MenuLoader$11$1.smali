.class Lcom/floatingmenu/MenuLoader$11$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/MenuLoader$11;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/MenuLoader$11;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$11$1;->this$0:Lcom/floatingmenu/MenuLoader$11;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    # getter for: Lcom/floatingmenu/MenuLoader;->sSystemUiCard:Landroid/view/View;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$2600()Landroid/view/View;

    move-result-object v0

    invoke-static {v0}, Lcom/floatingmenu/g;->a(Landroid/view/View;)Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-static {v0}, Lcom/floatingmenu/g;->d(Landroid/view/ViewPropertyAnimator;)Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-static {v0}, Lcom/floatingmenu/g;->c(Landroid/view/ViewPropertyAnimator;)Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    new-instance v1, Lcom/floatingmenu/MenuLoader$11$1$1;

    invoke-direct {v1, p0}, Lcom/floatingmenu/MenuLoader$11$1$1;-><init>(Lcom/floatingmenu/MenuLoader$11$1;)V

    invoke-static {v0, v1}, Lcom/floatingmenu/a;->a(Landroid/view/ViewPropertyAnimator;Ljava/lang/Runnable;)Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-static {v0}, Lcom/floatingmenu/b;->b(Landroid/view/ViewPropertyAnimator;)V

    return-void
.end method
