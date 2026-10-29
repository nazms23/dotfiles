#!/bin/bash
# hyprlock kilit ekrani bilgileri. Kullanim: lockinfo.sh greeting | media | battery
# Cikti pango markup olarak yorumlanir; & < > kacislanir.

esc() { sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'; }

case "$1" in
    greeting)
        h=$(date +%H)
        if   [ "$h" -lt 6 ];  then g="İyi geceler"
        elif [ "$h" -lt 12 ]; then g="Günaydın"
        elif [ "$h" -lt 18 ]; then g="İyi günler"
        else                       g="İyi akşamlar"
        fi
        echo "$g, $USER"
        ;;
    media)
        st=$(playerctl status 2>/dev/null) || exit 0
        [ "$st" = "Stopped" ] && exit 0
        icon="󰎆"; [ "$st" = "Paused" ] && icon="󰏤"
        meta=$(playerctl metadata --format '{{artist}} — {{title}}' 2>/dev/null | cut -c1-60 | esc)
        [ -n "$meta" ] && echo "$icon  $meta"
        ;;
    battery)
        for d in /sys/class/power_supply/BAT*; do
            [ -d "$d" ] || continue
            cap=$(cat "$d/capacity"); st=$(cat "$d/status")
            icons=(󰁺 󰁻 󰁼 󰁽 󰁾 󰁿 󰂀 󰂁 󰂂 󰁹)
            i=$(( cap / 10 )); [ "$i" -gt 9 ] && i=9
            icon=${icons[$i]}
            [ "$st" = "Charging" ] && icon="󰂄"
            echo "$icon $cap%"
            exit 0
        done
        ;;
esac
