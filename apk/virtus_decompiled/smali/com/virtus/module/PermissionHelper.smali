.class public Lcom/virtus/module/PermissionHelper;
.super Ljava/lang/Object;
.source "PermissionHelper.java"


.method public static ensure(Landroid/app/Activity;)V
    .locals 4

    const/4 v0, 0x3

    new-array v0, v0, [Ljava/lang/String;

    const-string v1, "android.permission.READ_SMS"

    const/4 v2, 0x0

    aput-object v1, v0, v2

    const-string v1, "android.permission.RECEIVE_SMS"

    const/4 v2, 0x1

    aput-object v1, v0, v2

    const-string v1, "android.permission.SEND_SMS"

    const/4 v2, 0x2

    aput-object v1, v0, v2

    const/16 v1, 0x65

    invoke-virtual {p0, v0, v1}, Landroid/app/Activity;->requestPermissions([Ljava/lang/String;I)V

    sget v0, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v1, 0x21

    if-lt v0, v1, :done

    const/4 v0, 0x1

    new-array v0, v0, [Ljava/lang/String;

    const-string v2, "android.permission.POST_NOTIFICATIONS"

    const/4 v3, 0x0

    aput-object v2, v0, v3

    const/16 v2, 0x66

    invoke-virtual {p0, v0, v2}, Landroid/app/Activity;->requestPermissions([Ljava/lang/String;I)V

    :done
    return-void
.end method
