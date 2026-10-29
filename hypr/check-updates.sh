#!/bin/bash
# Waybar guncelleme sayaci (custom/updates). checkupdates: pacman-contrib paketi.
# Kirilmaya acik paketler (Hyprland ekosistemi, kernel, NVIDIA...) varsa "risky" sinifi + tooltip uyarisi.

RISKY='^(hyprland|hyprutils|hyprlang|hyprgraphics|hyprcursor|hyprtoolkit|aquamarine|xdg-desktop-portal-hyprland|hyprswitch|linux|linux-headers|nvidia-open-dkms|nvidia-utils|lib32-nvidia-utils|mesa|glibc|systemd|kando-bin|spotify-launcher|spicetify-bin)$'

if ! command -v checkupdates >/dev/null; then
    echo '{"text": "", "tooltip": "checkupdates yok (pacman-contrib kur)", "class": "updated"}'
    exit 0
fi

PAC=$(checkupdates 2>/dev/null)
AUR=$(yay -Qua 2>/dev/null)
ALL=$(printf '%s\n%s\n' "$PAC" "$AUR" | grep -v '^\s*$')

n_pac=$(printf '%s' "$PAC" | grep -c .)
n_aur=$(printf '%s' "$AUR" | grep -c .)
total=$((n_pac + n_aur))

if [ "$total" -eq 0 ]; then
    echo '{"text": "", "tooltip": "Sistem güncel", "class": "updated"}'
    exit 0
fi

risky=$(printf '%s\n' "$ALL" | awk -v re="$RISKY" '$1 ~ re {print $1 " " $2 " → " $4}')

tooltip="Pacman: $n_pac · AUR: $n_aur"
class="updates"
icon="󰚰"
if [ -n "$risky" ]; then
    class="risky"
    icon="󰀦"
    tooltip="$tooltip\n\nDikkat, kırılmaya açık güncellemeler:\n$risky\n\nGüncellemeden önce sürüm notlarına bak."
fi
tooltip="$tooltip\n\nTık: güncelle (yay -Syu)"

python3 -I -c 'import json,sys; print(json.dumps({"text": sys.argv[1], "tooltip": sys.argv[2].replace("\\n", "\n"), "class": sys.argv[3]}, ensure_ascii=False))' \
    "$icon $total" "$tooltip" "$class"
