#!/bin/bash
# Oyun/performans modu ac/kapa: blur, animasyon, golge, bosluk kapanir.
# Durum dosyasi hyprland.lua'da okunur, boylece her reload'da korunur.
# Kullanim: gamemode.sh toggle | status

STATE="$HOME/.cache/hypr-gamemode"

case "$1" in
    toggle)
        if [ -f "$STATE" ]; then
            rm -f "$STATE"
            hyprctl reload >/dev/null
            notify-send -t 2000 "Oyun Modu" "Kapalı — efektler geri açıldı"
        else
            mkdir -p "$(dirname "$STATE")" && touch "$STATE"
            hyprctl reload >/dev/null
            notify-send -t 2000 "Oyun Modu" "Açık — blur, animasyon, gölge ve boşluklar kapalı"
        fi
        ;;
    status) [ -f "$STATE" ] && echo true || echo false ;;
    *) echo "Kullanim: $0 toggle|status" >&2; exit 1 ;;
esac
