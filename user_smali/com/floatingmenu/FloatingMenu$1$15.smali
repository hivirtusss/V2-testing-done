.class Lcom/floatingmenu/FloatingMenu$1$15;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/FloatingMenu$1;

.field final synthetic val$showSystemTab:Ljava/lang/Runnable;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1;Ljava/lang/Runnable;)V
    .registers 3

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$15;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iput-object p2, p0, Lcom/floatingmenu/FloatingMenu$1$15;->val$showSystemTab:Ljava/lang/Runnable;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 2

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$15;->val$showSystemTab:Ljava/lang/Runnable;

    invoke-interface {p1}, Ljava/lang/Runnable;->run()V

    return-void
.end method
