.class Lcom/floatingmenu/MenuLoader$20;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/lang/reflect/InvocationHandler;


# instance fields
.field private final blockList:Ljava/util/List;

.field final synthetic val$realPm:Ljava/lang/Object;


# direct methods
.method public constructor <init>(Ljava/lang/Object;)V
    .registers 4

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$20;->val$realPm:Ljava/lang/Object;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/16 p1, 0xc

    new-array p1, p1, [Ljava/lang/String;

    const/4 v0, 0x0

    const-string v1, "com.topjohnwu.magisk"

    aput-object v1, p1, v0

    const/4 v0, 0x1

    const-string v1, "me.weishu.kernelsu"

    aput-object v1, p1, v0

    const/4 v0, 0x2

    const-string v1, "io.github.a15f.ksu"

    aput-object v1, p1, v0

    const/4 v0, 0x3

    const-string v1, "com.chelpus.lackypatcher"

    aput-object v1, p1, v0

    const/4 v0, 0x4

    const-string v1, "com.noshufou.android.su"

    aput-object v1, p1, v0

    const/4 v0, 0x5

    const-string v1, "com.thirdparty.superuser"

    aput-object v1, p1, v0

    const/4 v0, 0x6

    const-string v1, "eu.chainfire.supersu"

    aput-object v1, p1, v0

    const/4 v0, 0x7

    const-string v1, "com.koushikdutta.superuser"

    aput-object v1, p1, v0

    const/16 v0, 0x8

    const-string v1, "org.meowcat.edxposed.manager"

    aput-object v1, p1, v0

    const/16 v0, 0x9

    const-string v1, "org.lsposed.manager"

    aput-object v1, p1, v0

    const/16 v0, 0xa

    const-string v1, "com.saurik.substrate"

    aput-object v1, p1, v0

    const/16 v0, 0xb

    const-string v1, "com.xposed.manager"

    aput-object v1, p1, v0

    invoke-static {p1}, Ljava/util/Arrays;->asList([Ljava/lang/Object;)Ljava/util/List;

    move-result-object p1

    iput-object p1, p0, Lcom/floatingmenu/MenuLoader$20;->blockList:Ljava/util/List;

    return-void
.end method

.method private shouldBlock(Ljava/lang/String;)Z
    .registers 5

    const/4 v0, 0x0

    if-nez p1, :cond_4

    return v0

    :cond_4
    invoke-virtual {p1}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object p1

    iget-object v1, p0, Lcom/floatingmenu/MenuLoader$20;->blockList:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v1

    :cond_e
    invoke-interface {v1}, Ljava/util/Iterator;->hasNext()Z

    move-result v2

    if-eqz v2, :cond_22

    invoke-interface {v1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Ljava/lang/String;

    invoke-virtual {p1, v2}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v2

    if-eqz v2, :cond_e

    const/4 p1, 0x1

    return p1

    :cond_22
    return v0
.end method


# virtual methods
.method public invoke(Ljava/lang/Object;Ljava/lang/reflect/Method;[Ljava/lang/Object;)Ljava/lang/Object;
    .registers 11

    invoke-virtual {p2}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object p1

    const-string v0, "getPackageInfo"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-string v1, "IPackageManager: Blocking query for package: "

    const-string v2, "ZygiskMenu @Hivirtus"

    const/4 v3, 0x0

    if-nez v0, :cond_18f

    const-string v0, "getApplicationInfo"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_1b

    goto/16 :goto_18f

    :cond_1b
    const-string v0, "getPackageInfoAsUser"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_166

    const-string v0, "getApplicationInfoAsUser"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_2d

    goto/16 :goto_166

    :cond_2d
    const-string v0, "getInstalledPackages"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const-class v1, Ljava/util/List;

    const-string v2, "getList"

    const-string v4, "ParceledListSlice"

    const/4 v5, 0x1

    if-eqz v0, :cond_cd

    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$20;->val$realPm:Ljava/lang/Object;

    invoke-virtual {p2, p1, p3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    if-eqz p1, :cond_1b8

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_9f

    :try_start_52
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    new-array v4, v3, [Ljava/lang/Class;

    invoke-virtual {v0, v2, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    new-array v4, v3, [Ljava/lang/Object;

    invoke-virtual {v2, p1, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/List;

    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_6d
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_8b

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    instance-of v6, v4, Landroid/content/pm/PackageInfo;

    if-eqz v6, :cond_87

    move-object v6, v4

    check-cast v6, Landroid/content/pm/PackageInfo;

    iget-object v6, v6, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    invoke-direct {p0, v6}, Lcom/floatingmenu/MenuLoader$20;->shouldBlock(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_87

    goto :goto_6d

    :cond_87
    invoke-virtual {v2, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_6d

    :cond_8b
    new-array p1, v5, [Ljava/lang/Class;

    aput-object v1, p1, v3

    invoke-virtual {v0, p1}, Ljava/lang/Class;->getDeclaredConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object p1

    invoke-virtual {p1, v5}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v0, v5, [Ljava/lang/Object;

    aput-object v2, v0, v3

    invoke-virtual {p1, v0}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1
    :try_end_9e
    .catchall {:try_start_52 .. :try_end_9e} :catchall_1b8

    return-object p1

    :cond_9f
    instance-of v0, p1, Ljava/util/List;

    if-eqz v0, :cond_1b8

    check-cast p1, Ljava/util/List;

    new-instance p2, Ljava/util/ArrayList;

    invoke-direct {p2}, Ljava/util/ArrayList;-><init>()V

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_ae
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result p3

    if-eqz p3, :cond_cc

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p3

    instance-of v0, p3, Landroid/content/pm/PackageInfo;

    if-eqz v0, :cond_c8

    move-object v0, p3

    check-cast v0, Landroid/content/pm/PackageInfo;

    iget-object v0, v0, Landroid/content/pm/PackageInfo;->packageName:Ljava/lang/String;

    invoke-direct {p0, v0}, Lcom/floatingmenu/MenuLoader$20;->shouldBlock(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_c8

    goto :goto_ae

    :cond_c8
    invoke-virtual {p2, p3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_ae

    :cond_cc
    return-object p2

    :cond_cd
    const-string v0, "getInstalledApplications"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_1b8

    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$20;->val$realPm:Ljava/lang/Object;

    invoke-virtual {p2, p1, p3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    if-eqz p1, :cond_1b8

    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0, v4}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v0

    if-eqz v0, :cond_138

    :try_start_eb
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    new-array v4, v3, [Ljava/lang/Class;

    invoke-virtual {v0, v2, v4}, Ljava/lang/Class;->getMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;

    move-result-object v2

    new-array v4, v3, [Ljava/lang/Object;

    invoke-virtual {v2, p1, v4}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Ljava/util/List;

    new-instance v2, Ljava/util/ArrayList;

    invoke-direct {v2}, Ljava/util/ArrayList;-><init>()V

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_106
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result v4

    if-eqz v4, :cond_124

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v4

    instance-of v6, v4, Landroid/content/pm/ApplicationInfo;

    if-eqz v6, :cond_120

    move-object v6, v4

    check-cast v6, Landroid/content/pm/ApplicationInfo;

    iget-object v6, v6, Landroid/content/pm/ApplicationInfo;->packageName:Ljava/lang/String;

    invoke-direct {p0, v6}, Lcom/floatingmenu/MenuLoader$20;->shouldBlock(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_120

    goto :goto_106

    :cond_120
    invoke-virtual {v2, v4}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_106

    :cond_124
    new-array p1, v5, [Ljava/lang/Class;

    aput-object v1, p1, v3

    invoke-virtual {v0, p1}, Ljava/lang/Class;->getDeclaredConstructor([Ljava/lang/Class;)Ljava/lang/reflect/Constructor;

    move-result-object p1

    invoke-virtual {p1, v5}, Ljava/lang/reflect/AccessibleObject;->setAccessible(Z)V

    new-array v0, v5, [Ljava/lang/Object;

    aput-object v2, v0, v3

    invoke-virtual {p1, v0}, Ljava/lang/reflect/Constructor;->newInstance([Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1
    :try_end_137
    .catchall {:try_start_eb .. :try_end_137} :catchall_1b8

    return-object p1

    :cond_138
    instance-of v0, p1, Ljava/util/List;

    if-eqz v0, :cond_1b8

    check-cast p1, Ljava/util/List;

    new-instance p2, Ljava/util/ArrayList;

    invoke-direct {p2}, Ljava/util/ArrayList;-><init>()V

    invoke-interface {p1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p1

    :goto_147
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    move-result p3

    if-eqz p3, :cond_165

    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object p3

    instance-of v0, p3, Landroid/content/pm/ApplicationInfo;

    if-eqz v0, :cond_161

    move-object v0, p3

    check-cast v0, Landroid/content/pm/ApplicationInfo;

    iget-object v0, v0, Landroid/content/pm/ApplicationInfo;->packageName:Ljava/lang/String;

    invoke-direct {p0, v0}, Lcom/floatingmenu/MenuLoader$20;->shouldBlock(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_161

    goto :goto_147

    :cond_161
    invoke-virtual {p2, p3}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    goto :goto_147

    :cond_165
    return-object p2

    :cond_166
    :goto_166
    if-eqz p3, :cond_1b8

    array-length p1, p3

    if-lez p1, :cond_1b8

    aget-object p1, p3, v3

    instance-of v0, p1, Ljava/lang/String;

    if-eqz v0, :cond_1b8

    check-cast p1, Ljava/lang/String;

    invoke-direct {p0, p1}, Lcom/floatingmenu/MenuLoader$20;->shouldBlock(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_17a

    goto :goto_1b8

    :cond_17a
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {v2, p2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    new-instance p2, Landroid/content/pm/PackageManager$NameNotFoundException;

    invoke-direct {p2, p1}, Landroid/content/pm/PackageManager$NameNotFoundException;-><init>(Ljava/lang/String;)V

    throw p2

    :cond_18f
    :goto_18f
    if-eqz p3, :cond_1b8

    array-length p1, p3

    if-lez p1, :cond_1b8

    aget-object p1, p3, v3

    instance-of v0, p1, Ljava/lang/String;

    if-eqz v0, :cond_1b8

    check-cast p1, Ljava/lang/String;

    invoke-direct {p0, p1}, Lcom/floatingmenu/MenuLoader$20;->shouldBlock(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_1a3

    goto :goto_1b8

    :cond_1a3
    new-instance p2, Ljava/lang/StringBuilder;

    invoke-direct {p2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {v2, p2}, Landroid/util/Log;->d(Ljava/lang/String;Ljava/lang/String;)I

    new-instance p2, Landroid/content/pm/PackageManager$NameNotFoundException;

    invoke-direct {p2, p1}, Landroid/content/pm/PackageManager$NameNotFoundException;-><init>(Ljava/lang/String;)V

    throw p2

    :catchall_1b8
    :cond_1b8
    :goto_1b8
    :try_start_1b8
    iget-object p1, p0, Lcom/floatingmenu/MenuLoader$20;->val$realPm:Ljava/lang/Object;

    invoke-virtual {p2, p1, p3}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p1
    :try_end_1be
    .catch Ljava/lang/reflect/InvocationTargetException; {:try_start_1b8 .. :try_end_1be} :catch_1bf

    return-object p1

    :catch_1bf
    move-exception p1

    invoke-virtual {p1}, Ljava/lang/reflect/InvocationTargetException;->getTargetException()Ljava/lang/Throwable;

    move-result-object p1

    goto :goto_1c6

    :goto_1c5
    throw p1

    :goto_1c6
    goto :goto_1c5
.end method
