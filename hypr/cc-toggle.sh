#!/bin/bash
# swaync kontrol merkezi toggle butonlari.
# swaync komutu /bin/sh -c "..." icine sariyor; config'te cift tirnak kullanilamaz,
# o yuzden tum mantik burada. Kullanim: cc-toggle.sh <wifi|bluetooth|nightlight|gamemode> <status|set>
# set: swaync'in verdigi SWAYNC_TOGGLE_STATE (true/false) durumuna getirir.

HYPR="$HOME/.config/hypr"
want="$SWAYNC_TOGGLE_STATE"

case "$1:$2" in
    wifi:status)       [ "$(nmcli radio wifi)" = enabled ] && echo true || echo false ;;
    wifi:set)          [ "$want" = true ] && nmcli radio wifi on || nmcli radio wifi off ;;

    bluetooth:status)  bluetoothctl show 2>/dev/null | grep -q "Powered: yes" && echo true || echo false ;;
    bluetooth:set)     [ "$want" = true ] && bluetoothctl power on >/dev/null || bluetoothctl power off >/dev/null ;;

    nightlight:status) "$HYPR/nightlight.sh" status ;;
    nightlight:set)    [ "$want" = true ] && "$HYPR/nightlight.sh" on || "$HYPR/nightlight.sh" off ;;

    gamemode:status)   "$HYPR/gamemode.sh" status ;;
    gamemode:set)      [ "$("$HYPR/gamemode.sh" status)" = "$want" ] || "$HYPR/gamemode.sh" toggle ;;

    *) echo "Kullanim: $0 <wifi|bluetooth|nightlight|gamemode> <status|set>" >&2; exit 1 ;;
esac
