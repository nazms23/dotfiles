#!/bin/bash

WALLPAPER_DIR="$HOME/Wallpapers"

# Ensure directory exists
mkdir -p "$WALLPAPER_DIR"

# Check if there are any images
shopt -s nullglob
files=("$WALLPAPER_DIR"/*.{jpg,jpeg,png,webp,gif,bmp})
shopt -u nullglob

if [ ${#files[@]} -eq 0 ]; then
    notify-send "Duvar Kagidi" "Wallpapers klasorunde resim bulunamadi.\n$WALLPAPER_DIR"
    exit 1
fi

# Build rofi list with filenames
list=""
for f in "${files[@]}"; do
    list+="$(basename "$f")\n"
done

# Show picker
chosen=$(echo -e "$list" | rofi -dmenu -p " Duvar Kagidi Sec" -i -theme-str 'window {width: 400px;}')

if [ -n "$chosen" ]; then
    selected="$WALLPAPER_DIR/$chosen"
    if [ -f "$selected" ]; then
        awww img "$selected" --transition-type grow --transition-duration 1
        # Update symlink for persistence
        ln -sf "$selected" "$HOME/wallpaper.png"
        notify-send "Duvar Kagidi" "Degistirildi: $chosen"
    fi
fi
