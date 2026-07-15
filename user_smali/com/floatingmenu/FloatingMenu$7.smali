.class Lcom/floatingmenu/FloatingMenu$7;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field final synthetic val$buttons:[Landroid/widget/Button;

.field final synthetic val$index:I

.field final synthetic val$providers:[Ljava/lang/String;

.field final synthetic val$selectedBg:Landroid/graphics/drawable/GradientDrawable;

.field final synthetic val$selectedProvider:[Ljava/lang/String;

.field final synthetic val$unselectedBg:Landroid/graphics/drawable/GradientDrawable;


# direct methods
.method public constructor <init>([Ljava/lang/String;[Ljava/lang/String;I[Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;Landroid/graphics/drawable/GradientDrawable;)V
    .registers 7

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$7;->val$selectedProvider:[Ljava/lang/String;

    iput-object p2, p0, Lcom/floatingmenu/FloatingMenu$7;->val$providers:[Ljava/lang/String;

    iput p3, p0, Lcom/floatingmenu/FloatingMenu$7;->val$index:I

    iput-object p4, p0, Lcom/floatingmenu/FloatingMenu$7;->val$buttons:[Landroid/widget/Button;

    iput-object p5, p0, Lcom/floatingmenu/FloatingMenu$7;->val$selectedBg:Landroid/graphics/drawable/GradientDrawable;

    iput-object p6, p0, Lcom/floatingmenu/FloatingMenu$7;->val$unselectedBg:Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 4

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$7;->val$selectedProvider:[Ljava/lang/String;

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$7;->val$providers:[Ljava/lang/String;

    iget v1, p0, Lcom/floatingmenu/FloatingMenu$7;->val$index:I

    aget-object v0, v0, v1

    const/4 v1, 0x0

    aput-object v0, p1, v1

    :goto_b
    const/4 p1, 0x4

    if-ge v1, p1, :cond_21

    iget-object p1, p0, Lcom/floatingmenu/FloatingMenu$7;->val$buttons:[Landroid/widget/Button;

    aget-object p1, p1, v1

    iget v0, p0, Lcom/floatingmenu/FloatingMenu$7;->val$index:I

    if-ne v1, v0, :cond_19

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$7;->val$selectedBg:Landroid/graphics/drawable/GradientDrawable;

    goto :goto_1b

    :cond_19
    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$7;->val$unselectedBg:Landroid/graphics/drawable/GradientDrawable;

    :goto_1b
    invoke-static {p1, v0}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_b

    :cond_21
    return-void
.end method
