#!/bin/bash
# Aktif monitörde EWW popup aç/kapa
# Kullanım: popup-toggle.sh <window-name> [close-other]

WINDOW="$1"
CLOSE_OTHER="$2"

# Tüm diğer popup'ları kapat
for popup in system-popup calendar-popup; do
    if [ "$popup" != "$WINDOW" ]; then
        eww close "$popup" 2>/dev/null
    fi
done

# Aktif monitör ID'sini al
MONITOR=$(hyprctl monitors -j | python3 -c "import sys,json; monitors=json.load(sys.stdin); print([m['id'] for m in monitors if m.get('focused')][0])" 2>/dev/null)

# Toggle
eww open --toggle "$WINDOW" --screen "${MONITOR:-0}"
