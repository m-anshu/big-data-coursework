#!/usr/bin/env python3
import sys
import json
for li in sys.stdin:
    li=li.strip()
    if li=="[":
    	continue
    elif li=="]":
        continue
    if li.endswith(","):
        li=li[:-1]
    unit=json.loads(li)
    cty=unit.get('city')
    ctgy=unit.get('categories',{})
    idstr = unit.get('store_id')
    sd=unit.get('sales_data',{})
    if not ctgy:
        continue
    res=0
    check2=0
    for ct,data in sd.items():
    	if ct in ctgy:
            check=1
            profit=data.get('revenue')
            loss=data.get('cogs')
            if profit==None or loss==None :
            	check=0
            	continue
            if check==1:
                check2=1
                res+=profit-loss
    if check2==1:
        print(f"{cty}\t{idstr}\t{res}")
            

