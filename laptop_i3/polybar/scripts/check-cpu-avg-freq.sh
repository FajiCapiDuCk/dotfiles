#!/usr/bin/env bash

freq=$(cat /sys/bus/cpu/devices/cpu0/cpufreq/cpuinfo_avg_freq)
a=$(( $freq / 1000))
if [[ $a -lt 1000 ]] then
    echo $a MHz
    else
    result=$((a / 1000)).$(( (a % 1000) / 10 ))
    echo $result GHz
    fi
