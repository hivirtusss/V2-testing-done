.class Lcom/floatingmenu/MenuLoader$11$1$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$1:Lcom/floatingmenu/MenuLoader$11$1;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/MenuLoader$11$1;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$11$1$1;->this$1:Lcom/floatingmenu/MenuLoader$11$1;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 2

    # getter for: Lcom/floatingmenu/MenuLoader;->sSystemUiCard:Landroid/view/View;
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$2600()Landroid/view/View;

    move-result-object v0

    invoke-static {v0}, Lcom/floatingmenu/g;->a(Landroid/view/View;)Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-static {v0}, Lcom/floatingmenu/g;->e(Landroid/view/ViewPropertyAnimator;)Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-static {v0}, Lcom/floatingmenu/g;->c(Landroid/view/ViewPropertyAnimator;)Landroid/view/ViewPropertyAnimator;

    move-result-object v0

    invoke-static {v0}, Lcom/floatingmenu/b;->b(Landroid/view/ViewPropertyAnimator;)V

    return-void
.end method
