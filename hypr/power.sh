#!/bin/bash
# Oturumu kapat / yeniden baslat / kapat. wlogout ve powermenu.sh kullanir.
# hyprshutdown varsa uygulamalari once duzgunce kapatir (kaydedilmemis is kaybolmaz),
# yoksa dogrudan cikar.
# Kullanim: power.sh logout | reboot | poweroff

case "$1" in
    logout)   label="Oturum kapatılıyor...";     post="" ;;
    reboot)   label="Yeniden başlatılıyor...";   post="systemctl reboot" ;;
    poweroff) label="Kapatılıyor...";            post="systemctl poweroff" ;;
    *) echo "Kullanim: $0 logout|reboot|poweroff" >&2; exit 1 ;;
esac

if command -v hyprshutdown >/dev/null; then
    if [ -n "$post" ]; then
        hyprshutdown -t "$label" --post-cmd "$post"
    else
        hyprshutdown -t "$label"
    fi
elif [ -n "$post" ]; then
    $post
else
    hyprctl dispatch 'hl.dsp.exit()'
fi
