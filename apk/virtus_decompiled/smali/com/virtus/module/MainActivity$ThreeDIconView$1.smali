.class Lcom/virtus/module/MainActivity$ThreeDIconView$1;
.super Ljava/lang/Object;
.source "MainActivity.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/virtus/module/MainActivity$ThreeDIconView;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$1:Lcom/virtus/module/MainActivity$ThreeDIconView;


# direct methods
.method constructor <init>(Lcom/virtus/module/MainActivity$ThreeDIconView;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x8010
        }
        names = {
            null
        }
    .end annotation

    .line 323
    iput-object p1, p0, Lcom/virtus/module/MainActivity$ThreeDIconView$1;->this$1:Lcom/virtus/module/MainActivity$ThreeDIconView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .locals 3

    .line 326
    iget-object v0, p0, Lcom/virtus/module/MainActivity$ThreeDIconView$1;->this$1:Lcom/virtus/module/MainActivity$ThreeDIconView;

    invoke-static {v0}, Lcom/virtus/module/MainActivity$ThreeDIconView;->access$700(Lcom/virtus/module/MainActivity$ThreeDIconView;)Z

    move-result v0

    if-nez v0, :cond_0

    return-void

    .line 327
    :cond_0
    iget-object v0, p0, Lcom/virtus/module/MainActivity$ThreeDIconView$1;->this$1:Lcom/virtus/module/MainActivity$ThreeDIconView;

    const v1, 0x3d3851ec    # 0.045f

    invoke-static {v0, v1}, Lcom/virtus/module/MainActivity$ThreeDIconView;->access$816(Lcom/virtus/module/MainActivity$ThreeDIconView;F)F

    .line 328
    iget-object v0, p0, Lcom/virtus/module/MainActivity$ThreeDIconView$1;->this$1:Lcom/virtus/module/MainActivity$ThreeDIconView;

    invoke-static {v0}, Lcom/virtus/module/MainActivity$ThreeDIconView;->access$800(Lcom/virtus/module/MainActivity$ThreeDIconView;)F

    move-result v1

    const/high16 v2, 0x3f000000    # 0.5f

    mul-float v1, v1, v2

    float-to-double v1, v1

    invoke-static {v1, v2}, Ljava/lang/Math;->sin(D)D

    move-result-wide v1

    double-to-float v1, v1

    const v2, 0x3e19999a    # 0.15f

    mul-float v1, v1, v2

    const v2, 0x3ecccccd    # 0.4f

    add-float/2addr v1, v2

    invoke-static {v0, v1}, Lcom/virtus/module/MainActivity$ThreeDIconView;->access$902(Lcom/virtus/module/MainActivity$ThreeDIconView;F)F

    .line 329
    iget-object v0, p0, Lcom/virtus/module/MainActivity$ThreeDIconView$1;->this$1:Lcom/virtus/module/MainActivity$ThreeDIconView;

    invoke-virtual {v0}, Lcom/virtus/module/MainActivity$ThreeDIconView;->invalidate()V

    .line 330
    iget-object v0, p0, Lcom/virtus/module/MainActivity$ThreeDIconView$1;->this$1:Lcom/virtus/module/MainActivity$ThreeDIconView;

    invoke-static {v0}, Lcom/virtus/module/MainActivity$ThreeDIconView;->access$1000(Lcom/virtus/module/MainActivity$ThreeDIconView;)Landroid/os/Handler;

    move-result-object v0

    const-wide/16 v1, 0x21

    invoke-virtual {v0, p0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method
