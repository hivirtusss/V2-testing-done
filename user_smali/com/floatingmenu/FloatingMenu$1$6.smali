.class Lcom/floatingmenu/FloatingMenu$1$6;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Landroid/text/TextWatcher;


# instance fields
.field final synthetic this$0:Lcom/floatingmenu/FloatingMenu$1;


# direct methods
.method public constructor <init>(Lcom/floatingmenu/FloatingMenu$1;)V
    .registers 2

    iput-object p1, p0, Lcom/floatingmenu/FloatingMenu$1$6;->this$0:Lcom/floatingmenu/FloatingMenu$1;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public afterTextChanged(Landroid/text/Editable;)V
    .registers 2

    invoke-virtual {p1}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object p1

    # setter for: Lcom/floatingmenu/FloatingMenu;->sBodyText:Ljava/lang/String;
    invoke-static {p1}, Lcom/floatingmenu/FloatingMenu;->access$502(Ljava/lang/String;)Ljava/lang/String;

    return-void
.end method

.method public beforeTextChanged(Ljava/lang/CharSequence;III)V
    .registers 5

    return-void
.end method

.method public onTextChanged(Ljava/lang/CharSequence;III)V
    .registers 5

    return-void
.end method
