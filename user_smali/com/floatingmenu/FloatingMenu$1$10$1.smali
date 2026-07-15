.class Lcom/floatingmenu/FloatingMenu$1$10$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$1:Lcom/floatingmenu/FloatingMenu$1$10;

.field final synthetic val$config:[Ljava/lang/String;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1$10;[Ljava/lang/String;)V
    .registers 3

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$10$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$10;

    iput-object p2, p0, Lcom/floatingmenu/FloatingMenu$1$10$1;->val$config:[Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$10$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$10;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$10;->val$inputTgToken:Landroid/widget/EditText;

    iget-object v1, p0, Lcom/floatingmenu/FloatingMenu$1$10$1;->val$config:[Ljava/lang/String;

    const/4 v2, 0x0

    aget-object v1, v1, v2

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$10$1;->this$1:Lcom/floatingmenu/FloatingMenu$1$10;

    iget-object v0, v0, Lcom/floatingmenu/FloatingMenu$1$10;->val$inputTgChatId:Landroid/widget/EditText;

    iget-object v1, p0, Lcom/floatingmenu/FloatingMenu$1$10$1;->val$config:[Ljava/lang/String;

    const/4 v2, 0x1

    aget-object v1, v1, v2

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void
.end method
