.class Lcom/floatingmenu/FloatingMenu$1$14;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/FloatingMenu$1;

.field final synthetic val$layoutMessage:Landroid/widget/LinearLayout;

.field final synthetic val$layoutSystem:Landroid/widget/LinearLayout;

.field final synthetic val$layoutTelegram:Landroid/widget/LinearLayout;

.field final synthetic val$tabMessage:Landroid/widget/Button;

.field final synthetic val$tabSelectedBg:Landroid/graphics/drawable/GradientDrawable;

.field final synthetic val$tabSystem:Landroid/widget/Button;

.field final synthetic val$tabTelegram:Landroid/widget/Button;

.field final synthetic val$tabUnselectedBg:Landroid/graphics/drawable/GradientDrawable;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;Landroid/widget/Button;Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;Landroid/widget/LinearLayout;Landroid/widget/LinearLayout;Landroid/widget/LinearLayout;)V
    .registers 10

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$14;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iput-object p2, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$tabSystem:Landroid/widget/Button;

    iput-object p3, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$tabUnselectedBg:Landroid/graphics/drawable/GradientDrawable;

    iput-object p4, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$tabMessage:Landroid/widget/Button;

    iput-object p5, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$tabTelegram:Landroid/widget/Button;

    iput-object p6, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$tabSelectedBg:Landroid/graphics/drawable/GradientDrawable;

    iput-object p7, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$layoutSystem:Landroid/widget/LinearLayout;

    iput-object p8, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$layoutMessage:Landroid/widget/LinearLayout;

    iput-object p9, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$layoutTelegram:Landroid/widget/LinearLayout;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$tabSystem:Landroid/widget/Button;

    iget-object v1, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$tabUnselectedBg:Landroid/graphics/drawable/GradientDrawable;

    invoke-static {v0, v1}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$tabMessage:Landroid/widget/Button;

    iget-object v1, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$tabUnselectedBg:Landroid/graphics/drawable/GradientDrawable;

    invoke-static {v0, v1}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$tabTelegram:Landroid/widget/Button;

    iget-object v1, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$tabSelectedBg:Landroid/graphics/drawable/GradientDrawable;

    invoke-static {v0, v1}, Lcom/floatingmenu/a;->c(Landroid/widget/Button;Landroid/graphics/drawable/GradientDrawable;)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$layoutSystem:Landroid/widget/LinearLayout;

    const/16 v1, 0x8

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$layoutMessage:Landroid/widget/LinearLayout;

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    iget-object v0, p0, Lcom/floatingmenu/FloatingMenu$1$14;->val$layoutTelegram:Landroid/widget/LinearLayout;

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/View;->setVisibility(I)V

    return-void
.end method
