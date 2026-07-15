#!/usr/bin/env python3
"""Replace bubble logo base64 in FloatingMenu$1.smali with compact Virtus V logo."""
import re
import sys

path = sys.argv[1]
logo = open(sys.argv[2]).read().strip()
text = open(path).read()
new, n = re.subn(r'const-string v9, "iVBORw0KGgo[^"]+"', f'const-string v9, "{logo}"', text, count=1)
if n != 1:
    sys.exit(f"logo replace failed ({n})")
open(path, 'w').write(new)
print(f"logo patched ({len(logo)} chars)")
