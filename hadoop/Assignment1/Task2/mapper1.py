#!/usr/bin/env python3
import sys
for li in sys.stdin:
    li=li.strip()
    if not li:
        continue
    arr=li.split(' ')
    n=len(arr)
    if n==2:
        print(f"{li} "+"pred")
    else :
        print(f"{li} "+"0.0")
            

