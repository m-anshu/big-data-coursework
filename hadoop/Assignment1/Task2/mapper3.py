#!/usr/bin/env python3
import sys
for li in sys.stdin:
    li=li.strip()
    time,req,c,ep,sdown,pred,actual=li.split(' ')
    if ep=='user/profile':
        print(f"{c} {ep} {pred} {actual} 100")
    elif ep=='user/settings':
        print(f"{c} {ep} {pred} {actual} 200")
    elif ep=='order/history':
        print(f"{c} {ep} {pred} {actual} 300")
    elif ep=='order/checkout':
        print(f"{c} {ep} {pred} {actual} 400")
    elif ep=='product/details':
        print(f"{c} {ep} {pred} {actual} 500")
    elif ep=='product/search':
        print(f"{c} {ep} {pred} {actual} 600")
    elif ep=='cart/add':
        print(f"{c} {ep} {pred} {actual} 700")
    elif ep=='cart/remove':
        print(f"{c} {ep} {pred} {actual} 800")
    elif ep=='payment/submit':
        print(f"{c} {ep} {pred} {actual} 900")
    elif ep=='support/ticket':
        print(f"{c} {ep} {pred} {actual} 1000")
            

