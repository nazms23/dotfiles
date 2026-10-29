#!/bin/bash
# Wallpaper'dan accent renk cikarip tum uygulamalara uygular
# Kullanim: update-accent.sh [wallpaper_path]

# Wallpaper kaynagi: 1) arguman, 2) waypaper config, 3) symlink
if [ -n "$1" ]; then
    WALLPAPER="$1"
else
    WALLPAPER=$(grep "^wallpaper" ~/.config/waypaper/config.ini 2>/dev/null | head -1 | cut -d'=' -f2 | tr -d ' ' | sed "s|~|$HOME|")
    [ -z "$WALLPAPER" ] && WALLPAPER=$(readlink -f "$HOME/wallpaper.png")
fi

if [ ! -f "$WALLPAPER" ]; then
    notify-send "Accent" "Wallpaper bulunamadı: $WALLPAPER"
    exit 1
fi

# matugen ile renk cikar
JSON=$(matugen image "$WALLPAPER" --json hex --prefer saturation 2>/dev/null)

if [ -z "$JSON" ]; then
    notify-send "Accent" "matugen renk çıkaramadı"
    exit 1
fi

ACCENT=$(echo "$JSON" | python3 -c "import json,sys; print(json.load(sys.stdin)['colors']['primary']['dark']['color'])")
SECONDARY=$(echo "$JSON" | python3 -c "import json,sys; print(json.load(sys.stdin)['colors']['secondary']['dark']['color'])")

if ! ~/.config/hypr/accent-apply.sh "$ACCENT" "$SECONDARY"; then
    notify-send "Accent" "Geçersiz renk: $ACCENT"
    exit 1
fi

notify-send "Accent Renk" "Güncellendi: ${ACCENT}" -t 3000
