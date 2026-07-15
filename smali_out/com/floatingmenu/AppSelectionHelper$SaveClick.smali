.class Lcom/floatingmenu/AppSelectionHelper$SaveClick;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field final val$context:Landroid/content/Context;


# direct methods
.method public constructor <init>(Landroid/content/Context;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/AppSelectionHelper$SaveClick;->val$context:Landroid/content/Context;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 2

    iget-object p1, p0, Lcom/floatingmenu/AppSelectionHelper$SaveClick;->val$context:Landroid/content/Context;

    invoke-static {p1}, Lcom/floatingmenu/AppSelectionHelper;->saveSelections(Landroid/content/Context;)V

    return-void
.end method
