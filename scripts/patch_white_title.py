#!/usr/bin/env python3
"""Force menu header title to pure white."""
import sys

path = sys.argv[1]
text = open(path).read()

blocks = [
    (
        '    const-string v8, "Zygisk Mode Menu Virtus V3"\n\n'
        "    invoke-virtual {v5, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V\n\n"
        "    invoke-virtual {v5, v11}, Landroid/widget/TextView;->setTextColor(I)V",
        '    const-string v8, "Zygisk Mode Menu Virtus V3"\n\n'
        "    invoke-virtual {v5, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V\n\n"
        "    const/4 v8, -0x1\n\n"
        "    invoke-virtual {v5, v8}, Landroid/widget/TextView;->setTextColor(I)V",
    ),
    (
        '    const-string v8, "Zygisk Mod Menu By @Hivirtus"\n\n'
        "    invoke-virtual {v5, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V\n\n"
        "    invoke-virtual {v5, v11}, Landroid/widget/TextView;->setTextColor(I)V",
        '    const-string v8, "Zygisk Mode Menu Virtus V3"\n\n'
        "    invoke-virtual {v5, v8}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V\n\n"
        "    const/4 v8, -0x1\n\n"
        "    invoke-virtual {v5, v8}, Landroid/widget/TextView;->setTextColor(I)V",
    ),
]
for old, new in blocks:
    if old in text:
        text = text.replace(old, new, 1)
        open(path, "w").write(text)
        print("white menu title applied")
        sys.exit(0)
sys.exit("menu title color block not found")
