.class Lcom/virtus/module/MainActivity$1;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/virtus/module/MainActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/virtus/module/MainActivity;


# direct methods
.method constructor <init>(Lcom/virtus/module/MainActivity;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 59
    iput-object p1, p0, Lcom/virtus/module/MainActivity$1;->this$0:Lcom/virtus/module/MainActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 62
    iget-object v0, p0, Lcom/virtus/module/MainActivity$1;->this$0:Lcom/virtus/module/MainActivity;

    invoke-static {v0}, Lcom/virtus/module/MainActivity;->access$000(Lcom/virtus/module/MainActivity;)V

    .line 63
    iget-object v0, p0, Lcom/virtus/module/MainActivity$1;->this$0:Lcom/virtus/module/MainActivity;

    invoke-static {v0}, Lcom/virtus/module/MainActivity;->access$100(Lcom/virtus/module/MainActivity;)Landroid/os/Handler;

    move-result-object v0

    const-wide/16 v1, 0x3e8

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method
