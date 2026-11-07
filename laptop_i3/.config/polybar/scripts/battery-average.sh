#!/usr/bin/env bash
shopt -s nullglob

batteries=(/sys/class/power_supply/BAT*)
amount=${#batteries[@]}

if [[ $amount -eq 0 ]]; then
    echo "BATTERY NOT FOUND"
    exit 1
fi

sum=0

for ((i = 0; i < amount; i++)); do
    cap=$(cat "/sys/class/power_supply/BAT$i/capacity")
    sum=$((sum + cap))
done

average=$((sum / amount))

charging=0

for ((i = 0; i < amount; i++)); do
    status=$(cat "/sys/class/power_supply/BAT$i/status")
    if [[ "$status" == "Charging" ]]; then
        charging=1
    fi
done

NOTIFY_LOCK="/tmp/battery_notify.lock"

if [[ "$charging" == 0 && "$average" -le 20 ]]; then
    if [[ ! -f "$NOTIFY_LOCK" || $(( $(date +%s) - $(stat -c %Y "$NOTIFY_LOCK") )) -ge 300 ]]; then
        notify-send -u critical -i battery-low \
            "⚠️ Low Battery Warning" \
            "Battery at $average%! Connect charger soon."
        touch "$NOTIFY_LOCK"
    fi
elif [[ "$charging" == 1 ]]; then
    echo "Charging $average%"
    fi
    if [[ "$average" -ge 20 ]]; then
        echo "Discharging $average%"
    else
        echo "LOW $average%"
    fi
