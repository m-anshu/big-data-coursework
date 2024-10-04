#!/usr/bin/env python3
import sys
curr_t=None
curr_c=set()
curr_eps={}

for li in sys.stdin:
    li=li.strip()
    if not li:
        continue
    time,req,c,ep,sdown,pred=li.split(' ')
    sdown=float(sdown)
    if curr_t!=time:
        curr_t=time
        curr_c.clear()
        curr_eps.clear()
    if ep in curr_eps:
        sdown=curr_eps[ep]
    if c in curr_c:
        continue
    if sdown>=3.0:
        curr_c.add(c)
        print(f"{time} {req} {c} {ep} {sdown} {pred} 500")
    else:
        curr_c.add(c)
        curr_eps[ep]=sdown+1.0
        print(f"{time} {req} {c} {ep} {sdown} {pred} 200")



    
