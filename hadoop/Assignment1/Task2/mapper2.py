#!/usr/bin/env python3
import sys
for li in sys.stdin:
    li=li.strip()
    if not li:
        continue
    print(li)
