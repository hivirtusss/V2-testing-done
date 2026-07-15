.class Lcom/floatingmenu/FloatingMenu$1$10;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/FloatingMenu$1;

.field final synthetic val$inputTgChatId:Landroid/widget/EditText;

.field final synthetic val$inputTgToken:Landroid/widget/EditText;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/EditText;Landroid/widget/EditText;)V
    .registers 4

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$10;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iput-object p2, p0, Lcom/floatingmenu/FloatingMenu$1$10;->val$inputTgToken:Landroid/widget/EditText;

    iput-object p3, p0, Lcom/floatingmenu/FloatingMenu$1$10;->val$inputTgChatId:Landroid/widget/EditText;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    invoke-static {}, Lcom/floatingmenu/FloatingMenu;->loadTelegramConfig()[Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Lcom/floatingmenu/FloatingMenu$1$10;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iget-object v1, v1, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    new-instance v2, Lcom/floatingmenu/FloatingMenu$1$10$1;

    invoke-direct {v2, p0, v0}, Lcom/floatingmenu/FloatingMenu$1$10$1;-><init>(Lcom/floatingmenu/FloatingMenu$1$10;[Ljava/lang/String;)V

    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method
