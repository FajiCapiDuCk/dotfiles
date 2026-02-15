#!/usr/bin/env bash

mic_status=$(pactl get-source-mute @DEFAULT_SOURCE@ | awk '{print $2}')

if [ "$mic_status" = "yes" ]; then
    pactl set-source-mute @DEFAULT_SOURCE@ 0
    notify-send "Microphone" "Unmuted" -i microphone-sensitivity-high-symbolic
else
    pactl set-source-mute @DEFAULT_SOURCE@ 1
    notify-send "Microphone" "Muted" -i microphone-sensitivity-muted-symbolic
fi
