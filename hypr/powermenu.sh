#!/bin/bash

options="Kilitle\nUyku\nOturumu Kapat\nYeniden Baslat\nKapat"

chosen=$(echo -e "$options" | rofi -dmenu -p "Guc Menusu" -i -theme ~/.config/rofi/powermenu.rasi)

case "$chosen" in
    Kilitle)            hyprlock ;;
    Uyku)               systemctl suspend ;;
    "Oturumu Kapat")    ~/.config/hypr/power.sh logout ;;
    "Yeniden Baslat")   ~/.config/hypr/power.sh reboot ;;
    Kapat)              ~/.config/hypr/power.sh poweroff ;;
esac
