.class Lcom/floatingmenu/MenuLoader$8$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/MenuLoader$8;

.field final synthetic val$globalKey:Ljava/lang/String;

.field final synthetic val$globalStatus:Ljava/lang/String;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/MenuLoader$8;Ljava/lang/String;Ljava/lang/String;)V
    .registers 4

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$8$1;->this$0:Lcom/floatingmenu/MenuLoader$8;

    iput-object p2, p0, Lcom/floatingmenu/MenuLoader$8$1;->val$globalStatus:Ljava/lang/String;

    iput-object p3, p0, Lcom/floatingmenu/MenuLoader$8$1;->val$globalKey:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 2

    iget-object v0, p0, Lcom/floatingmenu/MenuLoader$8$1;->this$0:Lcom/floatingmenu/MenuLoader$8;

    iget-object v0, v0, Lcom/floatingmenu/MenuLoader$8;->val$app:Landroid/app/Application;

    # invokes: Lcom/floatingmenu/MenuLoader;->dismissSystemUiOverlay(Landroid/app/Application;)V
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$2000(Landroid/app/Application;)V

    return-void
.end method
