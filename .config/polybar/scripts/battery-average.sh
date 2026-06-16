#/usr/bin/env bash

amount=$(ls /sys/class/power_supply | grep "BAT" | wc -l)
if [[ amount -eq 0 ]]; then
	echo "BATTERY NOT FOUND"
	exit 1
	fi

for (( i = 0 ; i < "$amount" ; i++)); do declare bat$i=$(cat /sys/class/power_supply/BAT$i/capacity); done
for (( i = 0 ; i < "$amount" ; i++)); do sum=$(( ($sum + $bat$i) ) )); done
average=$(( ($sum/$amount) ))

for (( i = 0 ; i < $amount ; i++)); do declare status$i=$(cat /sys/class/power_supply/BAT$i/status); done

NOTIFY_LOCK="/tmp/battery_notify.lock"
charging=0
for (( i = 0 ; i < $amount ; i++)); do 
    if [[ "$status$i" == "Charging" ]]; then
        charging=1
        fi
done
if [[ "$charging" == 0 ]] && [[ $average -le 20 ]]; then
     if [ ! -f "$NOTIFY_LOCK" ] || [ $(($(date +%s) - $(stat -c %Y "$NOTIFY_LOCK"))) -ge 300 ]; then
        notify-send -u critical -i battery-low \
            "⚠️ Low Battery Warning" \
            "Battery at $average%! Connect charger soon."
        touch "$NOTIFY_LOCK"
    fi
    elif [[ "$charging" == 1 ]]; then
    echo "Charging $average%"
else
    if [ $average -ge 20 ]; then
        echo "Discharging $average%"
    else
        echo "LOW $average% (LOW)"
    fi
fi