#!/bin/bash

options="Kilitle\nUyku\nOturumu Kapat\nYeniden Baslat\nKapat"

chosen=$(echo -e "$options" | rofi -dmenu -p "Guc Menusu" -i -theme ~/.config/rofi/powermenu.rasi)

case "$chosen" in
    Kilitle)            hyprlock ;;
    Uyku)               systemctl suspend ;;
    "Oturumu Kapat")    hyprctl dispatch exit ;;
    "Yeniden Baslat")   systemctl reboot ;;
    Kapat)              systemctl poweroff ;;
esac
