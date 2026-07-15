.class Lcom/floatingmenu/MenuLoader$19;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/Runnable;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 1

    # invokes: Lcom/floatingmenu/MenuLoader;->applyPackageManagerHooks()V
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$4300()V

    # invokes: Lcom/floatingmenu/MenuLoader;->spoofBuildFields()V
    invoke-static {}, Lcom/floatingmenu/MenuLoader;->access$4400()V

    return-void
.end method
