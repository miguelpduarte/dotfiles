#!/usr/bin/env sh

less $1 | tail -n +2 | awk '{sum+=$NF} END{print "Average grade: ", sum/NR}'
