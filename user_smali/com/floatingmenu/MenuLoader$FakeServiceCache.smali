.class Lcom/floatingmenu/MenuLoader$FakeServiceCache;
.super Ljava/util/HashMap;
.source "SourceFile"


# direct methods
.method private constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/util/HashMap;-><init>()V

    return-void
.end method

.method public synthetic constructor <init>(Lcom/floatingmenu/MenuLoader$1;)V
    .registers 2

    invoke-direct {p0}, Lcom/floatingmenu/MenuLoader$FakeServiceCache;-><init>()V

    return-void
.end method


# virtual methods
.method public isEmpty()Z
    .registers 6

    :try_start_0
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Thread;->getStackTrace()[Ljava/lang/StackTraceElement;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    :goto_a
    if-ge v2, v1, :cond_1f

    aget-object v3, v0, v2

    invoke-virtual {v3}, Ljava/lang/StackTraceElement;->getMethodName()Ljava/lang/String;

    move-result-object v3

    const-string v4, "initServiceCache"

    invoke-virtual {v3, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v3
    :try_end_18
    .catchall {:try_start_0 .. :try_end_18} :catchall_1f

    if-eqz v3, :cond_1c

    const/4 v0, 0x1

    return v0

    :cond_1c
    add-int/lit8 v2, v2, 0x1

    goto :goto_a

    :catchall_1f
    :cond_1f
    invoke-super {p0}, Ljava/util/HashMap;->isEmpty()Z

    move-result v0

    return v0
.end method

.method public size()I
    .registers 7

    :try_start_0
    invoke-static {}, Ljava/lang/Thread;->currentThread()Ljava/lang/Thread;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Thread;->getStackTrace()[Ljava/lang/StackTraceElement;

    move-result-object v0

    array-length v1, v0

    const/4 v2, 0x0

    const/4 v3, 0x0

    :goto_b
    if-ge v3, v1, :cond_1f

    aget-object v4, v0, v3

    invoke-virtual {v4}, Ljava/lang/StackTraceElement;->getMethodName()Ljava/lang/String;

    move-result-object v4

    const-string v5, "initServiceCache"

    invoke-virtual {v4, v5}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v4
    :try_end_19
    .catchall {:try_start_0 .. :try_end_19} :catchall_1f

    if-eqz v4, :cond_1c

    return v2

    :cond_1c
    add-int/lit8 v3, v3, 0x1

    goto :goto_b

    :catchall_1f
    :cond_1f
    invoke-super {p0}, Ljava/util/HashMap;->size()I

    move-result v0

    return v0
.end method
