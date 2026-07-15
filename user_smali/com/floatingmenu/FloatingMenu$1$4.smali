.class Lcom/floatingmenu/FloatingMenu$1$4;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/FloatingMenu$1;

.field final synthetic val$inputCountry:Landroid/widget/EditText;

.field final synthetic val$inputSim1Number:Landroid/widget/EditText;

.field final synthetic val$inputSim2Number:Landroid/widget/EditText;

.field final synthetic val$sim1Container:Landroid/widget/LinearLayout;

.field final synthetic val$sim1Provider:[Ljava/lang/String;

.field final synthetic val$sim1Selector:Landroid/widget/LinearLayout;

.field final synthetic val$sim2Container:Landroid/widget/LinearLayout;

.field final synthetic val$sim2Provider:[Ljava/lang/String;

.field final synthetic val$sim2Selector:Landroid/widget/LinearLayout;

.field final synthetic val$switchDev:Landroid/widget/Switch;

.field final synthetic val$switchNoRoot:Landroid/widget/Switch;

.field final synthetic val$switchSim1:Landroid/widget/Switch;

.field final synthetic val$switchSim2:Landroid/widget/Switch;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1;Landroid/widget/Switch;Landroid/widget/LinearLayout;[Ljava/lang/String;Landroid/widget/LinearLayout;Landroid/widget/EditText;Landroid/widget/Switch;Landroid/widget/LinearLayout;[Ljava/lang/String;Landroid/widget/LinearLayout;Landroid/widget/EditText;Landroid/widget/EditText;Landroid/widget/Switch;Landroid/widget/Switch;)V
    .registers 15

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$4;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iput-object p2, p0, Lcom/floatingmenu/FloatingMenu$1$4;->val$switchSim1:Landroid/widget/Switch;

    iput-object p3, p0, Lcom/floatingmenu/FloatingMenu$1$4;->val$sim1Container:Landroid/widget/LinearLayout;

    iput-object p4, p0, Lcom/floatingmenu/FloatingMenu$1$4;->val$sim1Provider:[Ljava/lang/String;

    iput-object p5, p0, Lcom/floatingmenu/FloatingMenu$1$4;->val$sim1Selector:Landroid/widget/LinearLayout;

    iput-object p6, p0, Lcom/floatingmenu/FloatingMenu$1$4;->val$inputSim1Number:Landroid/widget/EditText;

    iput-object p7, p0, Lcom/floatingmenu/FloatingMenu$1$4;->val$switchSim2:Landroid/widget/Switch;

    iput-object p8, p0, Lcom/floatingmenu/FloatingMenu$1$4;->val$sim2Container:Landroid/widget/LinearLayout;

    iput-object p9, p0, Lcom/floatingmenu/FloatingMenu$1$4;->val$sim2Provider:[Ljava/lang/String;

    iput-object p10, p0, Lcom/floatingmenu/FloatingMenu$1$4;->val$sim2Selector:Landroid/widget/LinearLayout;

    iput-object p11, p0, Lcom/floatingmenu/FloatingMenu$1$4;->val$inputSim2Number:Landroid/widget/EditText;

    iput-object p12, p0, Lcom/floatingmenu/FloatingMenu$1$4;->val$inputCountry:Landroid/widget/EditText;

    iput-object p13, p0, Lcom/floatingmenu/FloatingMenu$1$4;->val$switchDev:Landroid/widget/Switch;

    iput-object p14, p0, Lcom/floatingmenu/FloatingMenu$1$4;->val$switchNoRoot:Landroid/widget/Switch;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 4

    invoke-static {}, Lcom/floatingmenu/FloatingMenu;->loadSimSettingsEx()[Ljava/lang/String;

    move-result-object v0

    iget-object v1, p0, Lcom/floatingmenu/FloatingMenu$1$4;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    iget-object v1, v1, Lcom/floatingmenu/FloatingMenu$1;->val$activity:Landroid/app/Activity;

    new-instance v2, Lcom/floatingmenu/FloatingMenu$1$4$1;

    invoke-direct {v2, p0, v0}, Lcom/floatingmenu/FloatingMenu$1$4$1;-><init>(Lcom/floatingmenu/FloatingMenu$1$4;[Ljava/lang/String;)V

    invoke-virtual {v1, v2}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    return-void
.end method
