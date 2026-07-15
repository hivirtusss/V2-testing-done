.class Lcom/floatingmenu/FloatingMenu$1$18;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/view/View$OnTouchListener;


# static fields
.field private static final CLICK_DRAG_TOLERANCE:I = 0xa


# instance fields
.field private initialTouchX:F

.field private initialTouchY:F

.field private initialX:F

.field private initialY:F

.field final synthetic this$0:Lcom/floatingmenu/FloatingMenu$1;

.field private touchTime:J

.field final synthetic val$floatingIcon:Landroid/widget/FrameLayout;

.field final synthetic val$menuCard:Landroid/widget/LinearLayout;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/FrameLayout;Landroid/widget/LinearLayout;)V
    .registers 4

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$18;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iput-object p2, p0, Lcom/floatingmenu/FloatingMenu$1$18;->val$floatingIcon:Landroid/widget/FrameLayout;

    iput-object p3, p0, Lcom/floatingmenu/FloatingMenu$1$18;->val$menuCard:Landroid/widget/LinearLayout;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .registers 9

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getAction()I

    move-result p1

    const/4 v0, 0x1

    if-eqz p1, :cond_67

    const/4 v1, 0x0

    if-eq p1, v0, :cond_2d

    const/4 v2, 0x2

    if-eq p1, v2, :cond_e

    return v1

    :cond_e
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F

    move-result p1

    iget v1, p0, Lcom/floatingmenu/FloatingMenu$1$18;->initialTouchX:F

    sub-float/2addr p1, v1

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F

    move-result p2

    iget v1, p0, Lcom/floatingmenu/FloatingMenu$1$18;->initialTouchY:F

    sub-float/2addr p2, v1

    iget-object v1, p0, Lcom/floatingmenu/FloatingMenu$1$18;->val$floatingIcon:Landroid/widget/FrameLayout;

    iget v2, p0, Lcom/floatingmenu/FloatingMenu$1$18;->initialX:F

    add-float/2addr v2, p1

    invoke-static {v1, v2}, Lcom/floatingmenu/c;->b(Landroid/widget/FrameLayout;F)V

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$18;->val$floatingIcon:Landroid/widget/FrameLayout;

    iget v1, p0, Lcom/floatingmenu/FloatingMenu$1$18;->initialY:F

    add-float/2addr v1, p2

    invoke-static {p1, v1}, Lcom/floatingmenu/c;->d(Landroid/widget/FrameLayout;F)V

    return v0

    :cond_2d
    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F

    move-result p1

    iget v2, p0, Lcom/floatingmenu/FloatingMenu$1$18;->initialTouchX:F

    sub-float/2addr p1, v2

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F

    move-result p2

    iget v2, p0, Lcom/floatingmenu/FloatingMenu$1$18;->initialTouchY:F

    sub-float/2addr p2, v2

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    iget-wide v4, p0, Lcom/floatingmenu/FloatingMenu$1$18;->touchTime:J

    sub-long/2addr v2, v4

    invoke-static {p1}, Ljava/lang/Math;->abs(F)F

    move-result p1

    const/high16 v4, 0x41200000    # 10.0f

    cmpg-float p1, p1, v4

    if-gez p1, :cond_66

    invoke-static {p2}, Ljava/lang/Math;->abs(F)F

    move-result p1

    cmpg-float p1, p1, v4

    if-gez p1, :cond_66

    const-wide/16 p1, 0x190

    cmp-long v4, v2, p1

    if-gez v4, :cond_66

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$18;->val$floatingIcon:Landroid/widget/FrameLayout;

    const/16 p2, 0x8

    invoke-virtual {p1, p2}, Landroid/view/View;->setVisibility(I)V

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$18;->val$menuCard:Landroid/widget/LinearLayout;

    invoke-virtual {p1, v1}, Landroid/view/View;->setVisibility(I)V

    :cond_66
    return v0

    :cond_67
    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$18;->val$floatingIcon:Landroid/widget/FrameLayout;

    invoke-static {p1}, Lcom/floatingmenu/c;->a(Landroid/widget/FrameLayout;)F

    move-result p1

    iput p1, p0, Lcom/floatingmenu/FloatingMenu$1$18;->initialX:F

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$18;->val$floatingIcon:Landroid/widget/FrameLayout;

    invoke-static {p1}, Lcom/floatingmenu/c;->c(Landroid/widget/FrameLayout;)F

    move-result p1

    iput p1, p0, Lcom/floatingmenu/FloatingMenu$1$18;->initialY:F

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawX()F

    move-result p1

    iput p1, p0, Lcom/floatingmenu/FloatingMenu$1$18;->initialTouchX:F

    invoke-virtual {p2}, Landroid/view/MotionEvent;->getRawY()F

    move-result p1

    iput p1, p0, Lcom/floatingmenu/FloatingMenu$1$18;->initialTouchY:F

    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide p1

    iput-wide p1, p0, Lcom/floatingmenu/FloatingMenu$1$18;->touchTime:J

    return v0
.end method
