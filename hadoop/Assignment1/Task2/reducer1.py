#!/usr/bin/env python3
import sys
curr_id=None
curr_stat=None
for li in sys.stdin:
    li=li.strip()
    if not li:
        continue
    arr=li.split(' ')
    n=len(arr)
    if n==3:
        curr_id=arr[0]
        curr_stat=arr[1]
    else:
        if arr[0]==curr_id:
            print(arr[3]+" "+arr[0]+" "+arr[1]+" "+arr[2]+" "+arr[4]+" "+curr_stat)

