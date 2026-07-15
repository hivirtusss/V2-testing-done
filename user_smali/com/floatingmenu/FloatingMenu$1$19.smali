.class Lcom/floatingmenu/FloatingMenu$1$19;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/FloatingMenu$1;

.field final synthetic val$floatingIcon:Landroid/widget/FrameLayout;

.field final synthetic val$menuCard:Landroid/widget/LinearLayout;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/LinearLayout;Landroid/widget/FrameLayout;)V
    .registers 4

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$19;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iput-object p2, p0, Lcom/floatingmenu/FloatingMenu$1$19;->val$menuCard:Landroid/widget/LinearLayout;

    iput-object p3, p0, Lcom/floatingmenu/FloatingMenu$1$19;->val$floatingIcon:Landroid/widget/FrameLayout;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 3

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$19;->val$menuCard:Landroid/widget/LinearLayout;

    const/16 v0, 0x8

    invoke-virtual {p1, v0}, Landroid/view/View;->setVisibility(I)V

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$19;->val$floatingIcon:Landroid/widget/FrameLayout;

    const/4 v0, 0x0

    invoke-virtual {p1, v0}, Landroid/view/View;->setVisibility(I)V

    return-void
.end method
