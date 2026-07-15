.class Lcom/floatingmenu/MenuLoader$10$5$1;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$1:Lcom/floatingmenu/MenuLoader$10$5;

.field final synthetic val$key:Ljava/lang/String;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/MenuLoader$10$5;Ljava/lang/String;)V
    .registers 3

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$10$5$1;->this$1:Lcom/floatingmenu/MenuLoader$10$5;

    iput-object p2, p0, Lcom/floatingmenu/MenuLoader$10$5$1;->val$key:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "SET_LICENSE|"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$10$5$1;->val$key:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    # invokes: Lcom/floatingmenu/MenuLoader;->querySocket(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$600(Ljava/lang/String;)Ljava/lang/String;

    const-string v0, "SET_LICENSE_STATUS|pending"

    # invokes: Lcom/floatingmenu/MenuLoader;->querySocket(Ljava/lang/String;)Ljava/lang/String;
    invoke-static {v0}, Lcom/floatingmenu/MenuLoader;->access$600(Ljava/lang/String;)Ljava/lang/String;

    return-void
.end method
