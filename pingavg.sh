#!/usr/bin/env bash

# pings Google DNS and writes a moving average to stdout, constantly replacing it with the magic of \r.

# awk script for moving average is a slightly modified version of this one: https://nwat.xyz/blog/2013/01/27/simple-moving-average-awk-script/

ping 8.8.8.8 | sed -unE -e 's/.*?time=([0-9.]+) ms/\1/gp' | stdbuf -o0 awk 'BEGIN { window = 5 } function sma(id, value) { sma_seen[id]++; mod = sma_seen[id] % window; if (sma_seen[id] <= window) sma_count[id]++; else sma_sum[id] -= sma_arr[id, mod]; sma_sum[id] += value;  sma_arr[id, mod] = value; return sma_sum[id] / sma_count[id]; }  { sma_val = sma(1, $1); printf("\rAverage time: %f", sma_val);}  END { printf("\n"); }'
