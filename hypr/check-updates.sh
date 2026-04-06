#!/bin/bash

pacman_updates=$(checkupdates 2>/dev/null | wc -l)
aur_updates=$(yay -Qua 2>/dev/null | wc -l)
total=$((pacman_updates + aur_updates))

if [ "$total" -gt 0 ]; then
    echo "{\"text\": \" $total\", \"tooltip\": \"Pacman: $pacman_updates\nAUR: $aur_updates\", \"class\": \"updates-available\"}"
else
    echo "{\"text\": \"\", \"tooltip\": \"Sistem guncel\", \"class\": \"updated\"}"
fi
