#!/usr/bin/env bash

current=$(brightnessctl get)
max=$(brightnessctl max)
percent=$((current * 100 / max))

case $1 in
    up)
        brightnessctl set +5%
        ;;
    down)
        brightnessctl set 5%-
        ;;
esac

current=$(brightnessctl get)
percent=$((current * 100 / max))

notify-send -t 1000 -h int:value:$percent "Brightness" "$percent%"
