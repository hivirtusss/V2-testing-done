.class Lcom/floatingmenu/AppSelectionHelper$RowClick;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field final val$pkg:Ljava/lang/String;


# direct methods
.method public constructor <init>(Ljava/lang/String;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/AppSelectionHelper$RowClick;->val$pkg:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 2

    iget-object p1, p0, Lcom/floatingmenu/AppSelectionHelper$RowClick;->val$pkg:Ljava/lang/String;

    invoke-static {p1}, Lcom/floatingmenu/AppSelectionHelper;->togglePackage(Ljava/lang/String;)V

    return-void
.end method
