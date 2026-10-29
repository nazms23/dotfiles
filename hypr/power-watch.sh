#!/bin/bash
# Sarj adaptoru takilip cikinca Hyprland config'ini yeniden yukler.
# hyprland.lua yuklenirken pil durumunu okuyup efektleri ayarlar (pilde kenarlik animasyonu kapali).
# Polling yok: udev power_supply olaylarini dinler.

ac_online() {
    for d in /sys/class/power_supply/*; do
        if [ "$(cat "$d/type" 2>/dev/null)" = "Mains" ]; then
            cat "$d/online"
            return
        fi
    done
    echo 1
}

last=$(ac_online)
udevadm monitor --udev --subsystem-match=power_supply 2>/dev/null | while read -r _; do
    now=$(ac_online)
    if [ "$now" != "$last" ]; then
        last=$now
        hyprctl reload >/dev/null
    fi
done
