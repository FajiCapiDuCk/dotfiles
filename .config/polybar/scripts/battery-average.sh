#/usr/bin/env bash

bat0=$(cat /sys/class/power_supply/BAT0/capacity 2>/dev/null || echo 0)
bat1=$(cat /sys/class/power_supply/BAT1/capacity 2>/dev/null || echo 0)

average=$(( ($bat0 + $bat1) / 2 ))

status=$(cat /sys/class/power_supply/BAT0/status 2>/dev/null)
status1=$(cat /sys/class/power_supply/BAT1/status 2>/dev/null)
NOTIFY_LOCK="/tmp/battery_notify.lock"

if [[ "$status" != "Charging"  && "$status1" != "Charging" ]] && [[ $average -le 20 ]]; then
    if [ ! -f "$NOTIFY_LOCK" ] || [ $(($(date +%s) - $(stat -c %Y "$NOTIFY_LOCK"))) -ge 600 ]; then
        notify-send -u critical -i battery-low \
            "⚠️ Low Battery Warning" \
            "Battery at $average%! Connect charger soon."
        touch "$NOTIFY_LOCK"
    fi
fi

if [[ "$status" = "Charging" || "$status1" = "Charging" ]]; then
    echo "Charging $average%"
else
    if [ $average -ge 80 ]; then
        echo "Discharging $average%"
    elif [ $average -ge 50 ]; then
        echo "Discharging $average%"
    elif [ $average -ge 20 ]; then
        echo "Discharging $average%"
    else
        echo "VERY LOW $average% (LOW)"
    fi
fi
