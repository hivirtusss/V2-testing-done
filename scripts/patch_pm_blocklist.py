#!/usr/bin/env python3
"""Expand PM hide block list in MenuLoader$20."""
import sys
from pathlib import Path

path = Path(sys.argv[1])
text = path.read_text()

text = text.replace("const/16 p1, 0xc", "const/16 p1, 0x10", 1)

insert_after = '    const-string v1, "com.xposed.manager"\n\n    aput-object v1, p1, v0\n\n    invoke-static {p1}'
new_block = '''    const-string v1, "com.xposed.manager"

    aput-object v1, p1, v0

    const/16 v0, 0xc

    const-string v1, "com.vvb2060.kernelsu"

    aput-object v1, p1, v0

    const/16 v0, 0xd

    const-string v1, "com.sukisu.ultra"

    aput-object v1, p1, v0

    const/16 v0, 0xe

    const-string v1, "me.bmax.apatch"

    aput-object v1, p1, v0

    const/16 v0, 0xf

    const-string v1, "io.github.mmrl"

    aput-object v1, p1, v0

    invoke-static {p1}'''

if insert_after not in text:
    sys.exit("MenuLoader$20 block anchor not found")
text = text.replace(insert_after, new_block, 1)
path.write_text(text)
print("PM blocklist expanded")
