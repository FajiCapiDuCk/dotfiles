#!/usr/bin/env bash

temp=$(cat /sys/class/thermal/thermal_zone0/temp)
newtemp=$(( $temp/1000 ))
echo $newtemp°C