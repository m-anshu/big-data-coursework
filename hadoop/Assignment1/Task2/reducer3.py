#!/usr/bin/env python3
import sys
prev_c=""
total_cost=0
suc=0
total_req=0
first=1
for li in sys.stdin:
    li=li.strip()
    c,ep,pred,actual,cost=li.split(' ')
    cost=int(cost)
    if first==1:
        prev_c=c
        first=0
    if c==prev_c:
        total_req+=1
        if actual==pred :
            suc+=1
        if actual=='200' :
            total_cost+=cost
        prev_c=c
    else:
        print(f"{prev_c} {suc}/{total_req} {total_cost}")
        prev_c=c
        total_cost=0
        suc=0
        total_req=0
        total_req+=1
        if actual==pred :
            suc+=1
        if actual=='200' :
            total_cost+=cost
        prev_c=c
print(f"{prev_c} {suc}/{total_req} {total_cost}")    
