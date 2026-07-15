.class Lcom/floatingmenu/MenuLoader$10$4$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$1:Lcom/floatingmenu/MenuLoader$10$4;

.field final synthetic val$currentKey:Ljava/lang/String;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/MenuLoader$10$4;Ljava/lang/String;)V
    .registers 3

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$10$4$1;->this$1:Lcom/floatingmenu/MenuLoader$10$4;

    iput-object p2, p0, Lcom/floatingmenu/MenuLoader$10$4$1;->val$currentKey:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$10$4$1;->this$1:Lcom/floatingmenu/MenuLoader$10$4;

    iget-object v0, v0, Lcom/floatingmenu/MenuLoader$10$4;->val$input:Landroid/widget/EditText;

    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$10$4$1;->val$currentKey:Ljava/lang/String;

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method
