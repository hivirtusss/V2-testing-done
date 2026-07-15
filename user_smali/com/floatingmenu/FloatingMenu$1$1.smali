.class Lcom/floatingmenu/FloatingMenu$1$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/FloatingMenu$1;

.field final synthetic val$sim1Container:Landroid/widget/LinearLayout;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/LinearLayout;)V
    .registers 3

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$1;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iput-object p2, p0, Lcom/floatingmenu/FloatingMenu$1$1;->val$sim1Container:Landroid/widget/LinearLayout;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .registers 3

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$1;->val$sim1Container:Landroid/widget/LinearLayout;

    if-eqz p2, :cond_6

    const/4 p2, 0x0

    goto :goto_8

    :cond_6
    const/16 p2, 0x8

    :goto_8
    invoke-virtual {p1, p2}, Landroid/view/View;->setVisibility(I)V

    return-void
.end method
