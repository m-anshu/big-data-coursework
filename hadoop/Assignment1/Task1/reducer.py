#!/usr/bin/env python3
import sys
import json
ar={}
id_tracker=[]
for li in sys.stdin:
    li=li.strip()
    if not li:
        continue
    cty,idstr,lres = li.split("\t")
    lres=int(lres)
    if cty not in ar:
        ar[cty]={"profit_stores":0,"loss_stores": 0}
    if lres>0:
        ar[cty]["profit_stores"]+=1
    else:
        ar[cty]["loss_stores"]+=1
for cty,info in ar.items():
    result = {"city": cty,"profit_stores": info["profit_stores"],"loss_stores": info["loss_stores"]}
    print(json.dumps(result))
