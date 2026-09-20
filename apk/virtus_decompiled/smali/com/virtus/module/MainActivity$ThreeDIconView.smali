.class Lcom/virtus/module/MainActivity$ThreeDIconView;
.super Landroid/view/View;
.source "MainActivity.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingClass;
    value = Lcom/virtus/module/MainActivity;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x2
    name = "ThreeDIconView"
.end annotation


# instance fields
.field private final glowPaint:Landroid/graphics/Paint;

.field private final gridPaint:Landroid/graphics/Paint;

.field private final h:Landroid/os/Handler;

.field private final paint:Landroid/graphics/Paint;

.field private rotX:F

.field private rotY:F

.field private running:Z

.field final synthetic this$0:Lcom/virtus/module/MainActivity;

.field private final tick:Ljava/lang/Runnable;


# direct methods
.method public constructor <init>(Lcom/virtus/module/MainActivity;Landroid/content/Context;)V
    .locals 0
    .annotation system Ldalvik/annotation/MethodParameters;
        accessFlags = {
            0x1010,
            0x0
        }
        names = {
            null,
            null
        }
    .end annotation

    .line 334
    iput-object p1, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->this$0:Lcom/virtus/module/MainActivity;

    invoke-direct {p0, p2}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 317
    new-instance p1, Landroid/graphics/Paint;

    const/4 p2, 0x1

    invoke-direct {p1, p2}, Landroid/graphics/Paint;-><init>(I)V

    iput-object p1, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->paint:Landroid/graphics/Paint;

    .line 318
    new-instance p1, Landroid/graphics/Paint;

    invoke-direct {p1, p2}, Landroid/graphics/Paint;-><init>(I)V

    iput-object p1, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->glowPaint:Landroid/graphics/Paint;

    .line 319
    new-instance p1, Landroid/graphics/Paint;

    invoke-direct {p1, p2}, Landroid/graphics/Paint;-><init>(I)V

    iput-object p1, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->gridPaint:Landroid/graphics/Paint;

    const p1, 0x3ecccccd    # 0.4f

    .line 320
    iput p1, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->rotX:F

    const p1, 0x3f4ccccd    # 0.8f

    iput p1, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->rotY:F

    const/4 p1, 0x0

    .line 321
    iput-boolean p1, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->running:Z

    .line 322
    new-instance p1, Landroid/os/Handler;

    invoke-direct {p1}, Landroid/os/Handler;-><init>()V

    iput-object p1, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->h:Landroid/os/Handler;

    .line 323
    new-instance p1, Lcom/virtus/module/MainActivity$ThreeDIconView$1;

    invoke-direct {p1, p0}, Lcom/virtus/module/MainActivity$ThreeDIconView$1;-><init>(Lcom/virtus/module/MainActivity$ThreeDIconView;)V

    iput-object p1, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->tick:Ljava/lang/Runnable;

    return-void
.end method

.method static synthetic access$1000(Lcom/virtus/module/MainActivity$ThreeDIconView;)Landroid/os/Handler;
    .locals 0

    .line 316
    iget-object p0, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->h:Landroid/os/Handler;

    return-object p0
.end method

.method static synthetic access$700(Lcom/virtus/module/MainActivity$ThreeDIconView;)Z
    .locals 0

    .line 316
    iget-boolean p0, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->running:Z

    return p0
.end method

.method static synthetic access$800(Lcom/virtus/module/MainActivity$ThreeDIconView;)F
    .locals 0

    .line 316
    iget p0, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->rotY:F

    return p0
.end method

.method static synthetic access$816(Lcom/virtus/module/MainActivity$ThreeDIconView;F)F
    .locals 1

    .line 316
    iget v0, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->rotY:F

    add-float/2addr v0, p1

    iput v0, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->rotY:F

    return v0
.end method

.method static synthetic access$902(Lcom/virtus/module/MainActivity$ThreeDIconView;F)F
    .locals 0

    .line 316
    iput p1, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->rotX:F

    return p1
.end method

.method private drawFace(Landroid/graphics/Canvas;[F[F[F[FLjava/lang/String;Ljava/lang/String;F)V
    .locals 11

    .line 408
    new-instance v0, Landroid/graphics/Paint;

    const/4 v1, 0x1

    invoke-direct {v0, v1}, Landroid/graphics/Paint;-><init>(I)V

    .line 409
    new-instance v2, Landroid/graphics/LinearGradient;

    const/4 v10, 0x0

    aget v3, p2, v10

    aget v4, p2, v1

    aget v5, p4, v10

    aget v6, p4, v1

    .line 410
    invoke-static/range {p6 .. p6}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v7

    invoke-static/range {p7 .. p7}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v8

    sget-object v9, Landroid/graphics/Shader$TileMode;->CLAMP:Landroid/graphics/Shader$TileMode;

    invoke-direct/range {v2 .. v9}, Landroid/graphics/LinearGradient;-><init>(FFFFIILandroid/graphics/Shader$TileMode;)V

    .line 409
    invoke-virtual {v0, v2}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    const/high16 v2, 0x437f0000    # 255.0f

    mul-float v2, v2, p8

    float-to-int v2, v2

    .line 411
    invoke-virtual {v0, v2}, Landroid/graphics/Paint;->setAlpha(I)V

    .line 412
    new-instance v2, Landroid/graphics/Path;

    invoke-direct {v2}, Landroid/graphics/Path;-><init>()V

    .line 413
    aget v3, p2, v10

    aget p2, p2, v1

    invoke-virtual {v2, v3, p2}, Landroid/graphics/Path;->moveTo(FF)V

    .line 414
    aget p2, p3, v10

    aget p3, p3, v1

    invoke-virtual {v2, p2, p3}, Landroid/graphics/Path;->lineTo(FF)V

    .line 415
    aget p2, p4, v10

    aget p3, p4, v1

    invoke-virtual {v2, p2, p3}, Landroid/graphics/Path;->lineTo(FF)V

    .line 416
    aget p2, p5, v10

    aget p3, p5, v1

    invoke-virtual {v2, p2, p3}, Landroid/graphics/Path;->lineTo(FF)V

    .line 417
    invoke-virtual {v2}, Landroid/graphics/Path;->close()V

    .line 418
    invoke-virtual {p1, v2, v0}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    const/4 p2, 0x0

    .line 419
    invoke-virtual {v0, p2}, Landroid/graphics/Paint;->setShader(Landroid/graphics/Shader;)Landroid/graphics/Shader;

    .line 420
    sget-object p2, Landroid/graphics/Paint$Style;->STROKE:Landroid/graphics/Paint$Style;

    invoke-virtual {v0, p2}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 421
    iget-object p2, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->this$0:Lcom/virtus/module/MainActivity;

    invoke-static {p2, v1}, Lcom/virtus/module/MainActivity;->access$1100(Lcom/virtus/module/MainActivity;I)I

    move-result p2

    int-to-float p2, p2

    invoke-virtual {v0, p2}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 422
    const-string p2, "#FFFFFF"

    invoke-static {p2}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result p2

    invoke-virtual {v0, p2}, Landroid/graphics/Paint;->setColor(I)V

    const/16 p2, 0x46

    .line 423
    invoke-virtual {v0, p2}, Landroid/graphics/Paint;->setAlpha(I)V

    .line 424
    invoke-virtual {p1, v2, v0}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    return-void
.end method


# virtual methods
.method protected onDraw(Landroid/graphics/Canvas;)V
    .locals 27

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    .line 344
    invoke-super/range {p0 .. p1}, Landroid/view/View;->onDraw(Landroid/graphics/Canvas;)V

    .line 345
    invoke-virtual {v0}, Lcom/virtus/module/MainActivity$ThreeDIconView;->getWidth()I

    move-result v2

    int-to-float v2, v2

    const/high16 v3, 0x40000000    # 2.0f

    div-float v9, v2, v3

    invoke-virtual {v0}, Lcom/virtus/module/MainActivity$ThreeDIconView;->getHeight()I

    move-result v2

    int-to-float v2, v2

    div-float v10, v2, v3

    .line 346
    invoke-virtual {v0}, Lcom/virtus/module/MainActivity$ThreeDIconView;->getWidth()I

    move-result v2

    int-to-float v2, v2

    const v3, 0x3eae147b    # 0.34f

    mul-float v11, v2, v3

    .line 349
    iget-object v2, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->glowPaint:Landroid/graphics/Paint;

    sget-object v3, Landroid/graphics/Paint$Style;->STROKE:Landroid/graphics/Paint$Style;

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 350
    iget-object v2, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->glowPaint:Landroid/graphics/Paint;

    iget-object v3, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->this$0:Lcom/virtus/module/MainActivity;

    const/4 v12, 0x2

    invoke-static {v3, v12}, Lcom/virtus/module/MainActivity;->access$1100(Lcom/virtus/module/MainActivity;I)I

    move-result v3

    int-to-float v3, v3

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setStrokeWidth(F)V

    .line 351
    iget-object v2, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->glowPaint:Landroid/graphics/Paint;

    const-string v13, "#2196F3"

    invoke-static {v13}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setColor(I)V

    .line 352
    iget-object v2, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->glowPaint:Landroid/graphics/Paint;

    new-instance v3, Landroid/graphics/BlurMaskFilter;

    iget-object v4, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->this$0:Lcom/virtus/module/MainActivity;

    const/16 v5, 0xe

    invoke-static {v4, v5}, Lcom/virtus/module/MainActivity;->access$1100(Lcom/virtus/module/MainActivity;I)I

    move-result v4

    int-to-float v4, v4

    sget-object v5, Landroid/graphics/BlurMaskFilter$Blur;->NORMAL:Landroid/graphics/BlurMaskFilter$Blur;

    invoke-direct {v3, v4, v5}, Landroid/graphics/BlurMaskFilter;-><init>(FLandroid/graphics/BlurMaskFilter$Blur;)V

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setMaskFilter(Landroid/graphics/MaskFilter;)Landroid/graphics/MaskFilter;

    const v2, 0x3f9c28f6    # 1.22f

    mul-float v2, v2, v11

    .line 353
    iget-object v3, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->glowPaint:Landroid/graphics/Paint;

    invoke-virtual {v1, v9, v10, v2, v3}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    .line 356
    iget v2, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->rotY:F

    float-to-double v2, v2

    invoke-static {v2, v3}, Ljava/lang/Math;->cos(D)D

    move-result-wide v2

    double-to-float v2, v2

    iget v3, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->rotY:F

    float-to-double v3, v3

    invoke-static {v3, v4}, Ljava/lang/Math;->sin(D)D

    move-result-wide v3

    double-to-float v3, v3

    .line 357
    iget v4, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->rotX:F

    float-to-double v4, v4

    invoke-static {v4, v5}, Ljava/lang/Math;->cos(D)D

    move-result-wide v4

    double-to-float v4, v4

    iget v5, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->rotX:F

    float-to-double v5, v5

    invoke-static {v5, v6}, Ljava/lang/Math;->sin(D)D

    move-result-wide v5

    double-to-float v5, v5

    const/4 v14, 0x3

    .line 360
    new-array v6, v14, [F

    fill-array-data v6, :array_0

    new-array v7, v14, [F

    fill-array-data v7, :array_1

    new-array v8, v14, [F

    fill-array-data v8, :array_2

    new-array v15, v14, [F

    fill-array-data v15, :array_3

    const/16 v16, 0x2

    new-array v12, v14, [F

    fill-array-data v12, :array_4

    new-array v0, v14, [F

    fill-array-data v0, :array_5

    move-object/from16 v17, v0

    new-array v0, v14, [F

    fill-array-data v0, :array_6

    move-object/from16 v18, v0

    new-array v0, v14, [F

    fill-array-data v0, :array_7

    const/16 v19, 0x3

    const/16 v14, 0x8

    move-object/from16 v20, v0

    new-array v0, v14, [[F

    const/16 v21, 0x0

    aput-object v6, v0, v21

    const/16 v22, 0x1

    aput-object v7, v0, v22

    aput-object v8, v0, v16

    aput-object v15, v0, v19

    const/4 v15, 0x4

    aput-object v12, v0, v15

    const/4 v12, 0x5

    aput-object v17, v0, v12

    const/16 v17, 0x6

    aput-object v18, v0, v17

    const/16 v18, 0x7

    aput-object v20, v0, v18

    const/4 v6, 0x2

    .line 364
    new-array v7, v6, [I

    aput v6, v7, v22

    aput v14, v7, v21

    sget-object v8, Ljava/lang/Float;->TYPE:Ljava/lang/Class;

    invoke-static {v8, v7}, Ljava/lang/reflect/Array;->newInstance(Ljava/lang/Class;[I)Ljava/lang/Object;

    move-result-object v7

    move-object/from16 v20, v7

    check-cast v20, [[F

    const/4 v7, 0x0

    :goto_0
    const/high16 v23, 0x3f000000    # 0.5f

    if-ge v7, v14, :cond_0

    .line 366
    aget-object v8, v0, v7

    const/16 v16, 0x2

    aget v6, v8, v21

    aget v24, v8, v22

    aget v8, v8, v16

    mul-float v25, v6, v2

    mul-float v26, v8, v3

    add-float v25, v25, v26

    neg-float v6, v6

    mul-float v6, v6, v3

    mul-float v8, v8, v2

    add-float/2addr v6, v8

    mul-float v8, v24, v4

    mul-float v26, v6, v5

    sub-float v8, v8, v26

    mul-float v24, v24, v5

    mul-float v6, v6, v4

    add-float v24, v24, v6

    mul-float v24, v24, v23

    const v6, 0x3fcccccd    # 1.6f

    add-float v24, v24, v6

    div-float v6, v6, v24

    .line 374
    aget-object v23, v20, v7

    mul-float v25, v25, v11

    mul-float v25, v25, v6

    add-float v25, v9, v25

    aput v25, v23, v21

    mul-float v8, v8, v11

    mul-float v8, v8, v6

    add-float/2addr v8, v10

    .line 375
    aput v8, v23, v22

    add-int/lit8 v7, v7, 0x1

    const/4 v6, 0x2

    goto :goto_0

    .line 379
    :cond_0
    aget-object v2, v20, v21

    aget-object v3, v20, v22

    const/16 v16, 0x2

    aget-object v4, v20, v16

    aget-object v5, v20, v19

    const-string v7, "#2196F3"

    const/high16 v8, 0x3f400000    # 0.75f

    const-string v6, "#0D47A1"

    move-object/from16 v0, p0

    invoke-direct/range {v0 .. v8}, Lcom/virtus/module/MainActivity$ThreeDIconView;->drawFace(Landroid/graphics/Canvas;[F[F[F[FLjava/lang/String;Ljava/lang/String;F)V

    .line 380
    aget-object v2, v20, v15

    aget-object v3, v20, v12

    aget-object v4, v20, v17

    aget-object v5, v20, v18

    const-string v7, "#1976D2"

    const v8, 0x3f0ccccd    # 0.55f

    const-string v6, "#0D47A1"

    move-object/from16 v1, p1

    invoke-direct/range {v0 .. v8}, Lcom/virtus/module/MainActivity$ThreeDIconView;->drawFace(Landroid/graphics/Canvas;[F[F[F[FLjava/lang/String;Ljava/lang/String;F)V

    .line 381
    aget-object v2, v20, v22

    aget-object v3, v20, v12

    aget-object v4, v20, v17

    const/16 v16, 0x2

    aget-object v5, v20, v16

    const-string v7, "#64B5F6"

    const v8, 0x3f4ccccd    # 0.8f

    const-string v6, "#2196F3"

    invoke-direct/range {v0 .. v8}, Lcom/virtus/module/MainActivity$ThreeDIconView;->drawFace(Landroid/graphics/Canvas;[F[F[F[FLjava/lang/String;Ljava/lang/String;F)V

    .line 382
    aget-object v2, v20, v21

    aget-object v3, v20, v15

    aget-object v4, v20, v18

    aget-object v5, v20, v19

    const-string v7, "#1976D2"

    const v8, 0x3f19999a    # 0.6f

    const-string v6, "#1565C0"

    invoke-direct/range {v0 .. v8}, Lcom/virtus/module/MainActivity$ThreeDIconView;->drawFace(Landroid/graphics/Canvas;[F[F[F[FLjava/lang/String;Ljava/lang/String;F)V

    .line 383
    aget-object v2, v20, v19

    const/16 v16, 0x2

    aget-object v3, v20, v16

    aget-object v4, v20, v17

    aget-object v5, v20, v18

    const-string v7, "#42A5F5"

    const v8, 0x3f266666    # 0.65f

    const-string v6, "#1E88E5"

    invoke-direct/range {v0 .. v8}, Lcom/virtus/module/MainActivity$ThreeDIconView;->drawFace(Landroid/graphics/Canvas;[F[F[F[FLjava/lang/String;Ljava/lang/String;F)V

    .line 384
    aget-object v2, v20, v21

    aget-object v3, v20, v22

    aget-object v4, v20, v12

    aget-object v5, v20, v15

    const-string v7, "#3949AB"

    const/high16 v8, 0x3f000000    # 0.5f

    const-string v6, "#1A237E"

    invoke-direct/range {v0 .. v8}, Lcom/virtus/module/MainActivity$ThreeDIconView;->drawFace(Landroid/graphics/Canvas;[F[F[F[FLjava/lang/String;Ljava/lang/String;F)V

    .line 387
    iget-object v2, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->paint:Landroid/graphics/Paint;

    sget-object v3, Landroid/graphics/Paint$Style;->FILL:Landroid/graphics/Paint$Style;

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setStyle(Landroid/graphics/Paint$Style;)V

    .line 388
    iget-object v2, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->paint:Landroid/graphics/Paint;

    const-string v3, "#FFFFFF"

    invoke-static {v3}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setColor(I)V

    .line 389
    iget-object v2, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->paint:Landroid/graphics/Paint;

    new-instance v3, Landroid/graphics/BlurMaskFilter;

    iget-object v4, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->this$0:Lcom/virtus/module/MainActivity;

    invoke-static {v4, v14}, Lcom/virtus/module/MainActivity;->access$1100(Lcom/virtus/module/MainActivity;I)I

    move-result v4

    int-to-float v4, v4

    sget-object v5, Landroid/graphics/BlurMaskFilter$Blur;->NORMAL:Landroid/graphics/BlurMaskFilter$Blur;

    invoke-direct {v3, v4, v5}, Landroid/graphics/BlurMaskFilter;-><init>(FLandroid/graphics/BlurMaskFilter$Blur;)V

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setMaskFilter(Landroid/graphics/MaskFilter;)Landroid/graphics/MaskFilter;

    .line 390
    new-instance v2, Landroid/graphics/RectF;

    mul-float v23, v23, v11

    sub-float v3, v9, v23

    const v4, 0x3eb33333    # 0.35f

    mul-float v4, v4, v11

    sub-float v4, v10, v4

    add-float v5, v9, v23

    const v6, 0x3e19999a    # 0.15f

    mul-float v6, v6, v11

    add-float v7, v10, v6

    invoke-direct {v2, v3, v4, v5, v7}, Landroid/graphics/RectF;-><init>(FFFF)V

    .line 391
    iget-object v3, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->this$0:Lcom/virtus/module/MainActivity;

    invoke-static {v3, v14}, Lcom/virtus/module/MainActivity;->access$1100(Lcom/virtus/module/MainActivity;I)I

    move-result v3

    int-to-float v3, v3

    iget-object v4, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->this$0:Lcom/virtus/module/MainActivity;

    invoke-static {v4, v14}, Lcom/virtus/module/MainActivity;->access$1100(Lcom/virtus/module/MainActivity;I)I

    move-result v4

    int-to-float v4, v4

    iget-object v5, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->paint:Landroid/graphics/Paint;

    invoke-virtual {v1, v2, v3, v4, v5}, Landroid/graphics/Canvas;->drawRoundRect(Landroid/graphics/RectF;FFLandroid/graphics/Paint;)V

    .line 392
    iget-object v2, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->paint:Landroid/graphics/Paint;

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setMaskFilter(Landroid/graphics/MaskFilter;)Landroid/graphics/MaskFilter;

    .line 393
    iget-object v2, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->paint:Landroid/graphics/Paint;

    invoke-static {v13}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v3

    invoke-virtual {v2, v3}, Landroid/graphics/Paint;->setColor(I)V

    .line 394
    new-instance v2, Landroid/graphics/Path;

    invoke-direct {v2}, Landroid/graphics/Path;-><init>()V

    sub-float v3, v9, v6

    .line 395
    invoke-virtual {v2, v3, v7}, Landroid/graphics/Path;->moveTo(FF)V

    const v3, 0x3dcccccd    # 0.1f

    mul-float v3, v3, v11

    add-float v4, v9, v3

    .line 396
    invoke-virtual {v2, v4, v7}, Landroid/graphics/Path;->lineTo(FF)V

    const v4, 0x3d4ccccd    # 0.05f

    mul-float v4, v4, v11

    sub-float v4, v9, v4

    const v5, 0x3ecccccd    # 0.4f

    mul-float v5, v5, v11

    add-float/2addr v5, v10

    .line 397
    invoke-virtual {v2, v4, v5}, Landroid/graphics/Path;->lineTo(FF)V

    .line 398
    invoke-virtual {v2}, Landroid/graphics/Path;->close()V

    .line 399
    iget-object v4, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->paint:Landroid/graphics/Paint;

    invoke-virtual {v1, v2, v4}, Landroid/graphics/Canvas;->drawPath(Landroid/graphics/Path;Landroid/graphics/Paint;)V

    .line 401
    iget-object v2, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->paint:Landroid/graphics/Paint;

    invoke-static {v13}, Landroid/graphics/Color;->parseColor(Ljava/lang/String;)I

    move-result v4

    invoke-virtual {v2, v4}, Landroid/graphics/Paint;->setColor(I)V

    const v2, 0x3e8f5c29    # 0.28f

    mul-float v11, v11, v2

    sub-float v2, v9, v11

    sub-float/2addr v10, v3

    .line 402
    iget-object v3, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->this$0:Lcom/virtus/module/MainActivity;

    const/4 v4, 0x3

    invoke-static {v3, v4}, Lcom/virtus/module/MainActivity;->access$1100(Lcom/virtus/module/MainActivity;I)I

    move-result v3

    int-to-float v3, v3

    iget-object v5, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->paint:Landroid/graphics/Paint;

    invoke-virtual {v1, v2, v10, v3, v5}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    .line 403
    iget-object v2, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->this$0:Lcom/virtus/module/MainActivity;

    invoke-static {v2, v4}, Lcom/virtus/module/MainActivity;->access$1100(Lcom/virtus/module/MainActivity;I)I

    move-result v2

    int-to-float v2, v2

    iget-object v3, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->paint:Landroid/graphics/Paint;

    invoke-virtual {v1, v9, v10, v2, v3}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    add-float/2addr v9, v11

    .line 404
    iget-object v2, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->this$0:Lcom/virtus/module/MainActivity;

    invoke-static {v2, v4}, Lcom/virtus/module/MainActivity;->access$1100(Lcom/virtus/module/MainActivity;I)I

    move-result v2

    int-to-float v2, v2

    iget-object v3, v0, Lcom/virtus/module/MainActivity$ThreeDIconView;->paint:Landroid/graphics/Paint;

    invoke-virtual {v1, v9, v10, v2, v3}, Landroid/graphics/Canvas;->drawCircle(FFFLandroid/graphics/Paint;)V

    return-void

    :array_0
    .array-data 4
        -0x40800000    # -1.0f
        -0x40800000    # -1.0f
        -0x40800000    # -1.0f
    .end array-data

    :array_1
    .array-data 4
        0x3f800000    # 1.0f
        -0x40800000    # -1.0f
        -0x40800000    # -1.0f
    .end array-data

    :array_2
    .array-data 4
        0x3f800000    # 1.0f
        0x3f800000    # 1.0f
        -0x40800000    # -1.0f
    .end array-data

    :array_3
    .array-data 4
        -0x40800000    # -1.0f
        0x3f800000    # 1.0f
        -0x40800000    # -1.0f
    .end array-data

    :array_4
    .array-data 4
        -0x40800000    # -1.0f
        -0x40800000    # -1.0f
        0x3f800000    # 1.0f
    .end array-data

    :array_5
    .array-data 4
        0x3f800000    # 1.0f
        -0x40800000    # -1.0f
        0x3f800000    # 1.0f
    .end array-data

    :array_6
    .array-data 4
        0x3f800000    # 1.0f
        0x3f800000    # 1.0f
        0x3f800000    # 1.0f
    .end array-data

    :array_7
    .array-data 4
        -0x40800000    # -1.0f
        0x3f800000    # 1.0f
        0x3f800000    # 1.0f
    .end array-data
.end method

.method public start()V
    .locals 4

    .line 337
    iget-boolean v0, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->running:Z

    if-eqz v0, :cond_0

    return-void

    :cond_0
    const/4 v0, 0x1

    .line 338
    iput-boolean v0, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->running:Z

    .line 339
    iget-object v0, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->h:Landroid/os/Handler;

    iget-object v1, p0, Lcom/virtus/module/MainActivity$ThreeDIconView;->tick:Ljava/lang/Runnable;

    const-wide/16 v2, 0x21

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method
