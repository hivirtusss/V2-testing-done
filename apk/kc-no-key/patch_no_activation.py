#!/usr/bin/env python3
"""Remove activation/key gate from KC GL (com.android.lc). Login: id + password only."""

from __future__ import annotations

import sys
from pathlib import Path

PKG = "io/android/lc"


def _replace(path: Path, old: str, new: str, label: str) -> bool:
    if not path.exists():
        print(f"skip missing: {path}")
        return False
    text = path.read_text(encoding="utf-8")
    if old not in text:
        print(f"warn: pattern not found for {label} in {path.name}")
        return False
    path.write_text(text.replace(old, new, 1), encoding="utf-8")
    print(f"patched: {label}")
    return True


def apply_no_activation(root: Path) -> None:
    login_layout = root / "res/layout/activity_login.xml"
    login_smali = root / f"smali/{PKG}/activity/LoginActivity.smali"
    start_smali = root / f"smali/{PKG}/StartGame.smali"
    vip_smali = root / f"smali/{PKG}/activity/PersonalActivity$8.smali"

    _replace(
        login_layout,
        'android:id="@id/recharge" android:layout_width="wrap_content" android:layout_height="wrap_content" android:layout_marginTop="5.0dip" android:text="@string/Activation" android:layout_alignParentStart="true"',
        'android:id="@id/recharge" android:layout_width="wrap_content" android:layout_height="wrap_content" android:layout_marginTop="5.0dip" android:text="@string/Activation" android:layout_alignParentStart="true" android:visibility="gone"',
        "hide activation button",
    )

    _replace(
        login_smali,
        """    const-string v0, "FUCKYOU"

    .line 423
    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_0""",
        """    const/4 v0, 0x1

    if-eqz v0, :cond_0""",
        "login always succeeds",
    )

    _replace(
        start_smali,
        """.method public synthetic lambda$onClick$0$StartGame(Lme/leefeng/promptlibrary/PromptDialog;)V
    .locals 7

    .line 51
    invoke-static {}, Lio/android/lc/SuperJNI;->isExpire()Ljava/lang/String;""",
        """.method public synthetic lambda$onClick$0$StartGame(Lme/leefeng/promptlibrary/PromptDialog;)V
    .locals 7

    .line 51
    invoke-virtual {p1}, Lme/leefeng/promptlibrary/PromptDialog;->dismiss()V

    invoke-direct {p0, p1}, Lio/android/lc/StartGame;->launchGame(Lme/leefeng/promptlibrary/PromptDialog;)V

    return-void

    invoke-static {}, Lio/android/lc/SuperJNI;->isExpire()Ljava/lang/String;""",
        "start cheat without key/expiry check",
    )

    _replace(
        vip_smali,
        """    cmp-long v1, v1, v6

    if-gez v1, :cond_1

    .line 683
    sget-object v0, Lio/android/lc/activity/PersonalActivity$CurrentViews;->vip_text:Landroid/widget/TextView;

    const-string v1, "Membership is not activated"

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    goto :goto_1

    .line 686
    :cond_1""",
        """    cmp-long v1, v1, v6

    goto :cond_1

    .line 686
    :cond_1""",
        "hide membership-not-activated label",
    )

    _replace(
        login_smali,
        """    iget-object p1, p0, Lio/android/lc/activity/LoginActivity;->recharge:Landroid/widget/TextView;

    new-instance v1, Lio/android/lc/activity/-$$Lambda$LoginActivity$Xb3nSAe7lRjRTgPg4NBoNkhUIKQ;

    invoke-direct {v1, p0}, Lio/android/lc/activity/-$$Lambda$LoginActivity$Xb3nSAe7lRjRTgPg4NBoNkhUIKQ;-><init>(Lio/android/lc/activity/LoginActivity;)V

    invoke-virtual {p1, v1}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V""",
        """    iget-object p1, p0, Lio/android/lc/activity/LoginActivity;->recharge:Landroid/widget/TextView;

    const/16 v1, 0x8

    invoke-virtual {p1, v1}, Landroid/widget/TextView;->setVisibility(I)V""",
        "disable activation click handler",
    )


def main() -> int:
    root = Path(sys.argv[1] if len(sys.argv) > 1 else ".")
    if not root.exists():
        print(f"Missing: {root}", file=sys.stderr)
        return 1
    apply_no_activation(root)
    print("KC GL no-activation patches applied.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
