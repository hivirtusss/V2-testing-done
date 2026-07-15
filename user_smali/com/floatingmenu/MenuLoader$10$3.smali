.class Lcom/floatingmenu/MenuLoader$10$3;
.super Landroid/widget/FrameLayout;
.source "SourceFile"


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/MenuLoader$10;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/MenuLoader$10;Landroid/content/Context;)V
    .registers 3

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$10$3;->this$0:Lcom/floatingmenu/MenuLoader$10;

    invoke-direct {p0, p2}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    return-void
.end method


# virtual methods
.method public dispatchKeyEvent(Landroid/view/KeyEvent;)Z
    .registers 4

    invoke-virtual {p1}, Landroid/view/KeyEvent;->getKeyCode()I

    move-result v0

    const/4 v1, 0x4

    if-ne v0, v1, :cond_9

    const/4 p1, 0x1

    return p1

    :cond_9
    invoke-super {p0, p1}, Landroid/widget/FrameLayout;->dispatchKeyEvent(Landroid/view/KeyEvent;)Z

    move-result p1

    return p1
.end method
