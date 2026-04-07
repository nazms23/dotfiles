#!/bin/bash
# Caps Lock / Num Lock OSD göstergesi

KEY="$1"

if [ "$KEY" = "caps" ]; then
    state=$(cat /sys/class/leds/input4::capslock/brightness)
    if [ "$state" = "1" ]; then
        notify-send -t 1500 -h string:x-canonical-private-synchronous:lockkey "CAPS LOCK" "Açık" -i dialog-warning
    else
        notify-send -t 1500 -h string:x-canonical-private-synchronous:lockkey "CAPS LOCK" "Kapalı" -i dialog-information
    fi
elif [ "$KEY" = "num" ]; then
    state=$(cat /sys/class/leds/input4::numlock/brightness)
    if [ "$state" = "1" ]; then
        notify-send -t 1500 -h string:x-canonical-private-synchronous:lockkey "NUM LOCK" "Açık" -i dialog-warning
    else
        notify-send -t 1500 -h string:x-canonical-private-synchronous:lockkey "NUM LOCK" "Kapalı" -i dialog-information
    fi
fi
