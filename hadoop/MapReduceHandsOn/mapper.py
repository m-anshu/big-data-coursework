#!/usr/bin/env python3
import sys

for line in sys.stdin:
    line = line.strip()
    parts = line.split(',')
    
    if len(parts) == 3:
        name, runs, balls = parts
        try:
            runs = int(runs)
            balls = int(balls)
            if balls != 0:
                local_strike_rate = round((runs / balls) * 100, 3)
            else:
                local_strike_rate = 0.000
            print(f"{name},{local_strike_rate}")
        except ValueError:
            continue
