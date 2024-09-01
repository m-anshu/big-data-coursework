#!/usr/bin/env python3

import sys

current_name = None
total_strike_rate = 0
match_count = 0

for line in sys.stdin:
    line = line.strip()
    name, local_strike_rate = line.split(',')
    
    try:
        local_strike_rate = float(local_strike_rate)
        
        if current_name == name:
            total_strike_rate += local_strike_rate
            match_count += 1
        else:
            if current_name:
                average_strike_rate = round(total_strike_rate / match_count, 3)
                print(f"{current_name},{average_strike_rate}")
                
            current_name = name
            total_strike_rate = local_strike_rate
            match_count = 1
    
    except ValueError:
        continue

if current_name == name:
    average_strike_rate = round(total_strike_rate / match_count, 3)
    print(f"{current_name},{average_strike_rate}")
