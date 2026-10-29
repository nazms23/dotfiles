#!/bin/bash
# Accent renklerini tum uygulamalarin renk dosyalarina yazar ve reload eder.
# Kullanim: accent-apply.sh <#accent> <#accent2>
# Uretilen dosyalar dotfiles'ta DEGIL (~/.config altinda, git disi); config'ler bunlari import eder.
# Boylece symlink'ler sed -i ile kirilmaz.

ACCENT="$1"
ACCENT2="$2"

for c in "$ACCENT" "$ACCENT2"; do
    if [[ ! "$c" =~ ^#[0-9a-fA-F]{6}$ ]]; then
        echo "Gecersiz renk: '$c' (beklenen: #rrggbb)" >&2
        exit 1
    fi
done

A="${ACCENT:1}"
A2="${ACCENT2:1}"
R=$((16#${A:0:2})); G=$((16#${A:2:2})); B=$((16#${A:4:2}))

CFG="$HOME/.config"
mkdir -p "$CFG"/{hypr,waybar,swaync,wlogout,rofi,kitty} ~/.cache
echo "$ACCENT" > ~/.cache/current-accent.txt

# Hyprland (hyprland.lua: require("accent"))
cat > "$CFG/hypr/accent.lua" <<EOF
return { accent = "rgb($A)", accent2 = "rgb($A2)" }
EOF

# Shell script'ler (keybinds-help vb.)
cat > "$CFG/hypr/accent.env" <<EOF
ACCENT="$ACCENT"
ACCENT2="$ACCENT2"
EOF

# Hyprlock (hyprlang: source = ...)
cat > "$CFG/hypr/hyprlock-colors.conf" <<EOF
\$accent = rgb($A)
\$accent2 = rgb($A2)
EOF

# GTK CSS: waybar, swaync, wlogout, hyprswitch (@import "colors.css")
for f in "$CFG/waybar/colors.css" "$CFG/swaync/colors.css" "$CFG/wlogout/colors.css" "$CFG/hypr/hyprswitch-colors.css"; do
    cat > "$f" <<EOF
@define-color accent $ACCENT;
@define-color accent2 $ACCENT2;
EOF
done

# Kendi GTK4 uygulamalarimiz (hesap-makinesi...): libadwaita CSS degiskenleri, acik pencere dosyayi izleyip canli gunceller
mkdir -p "$CFG/accent"
cat > "$CFG/accent/colors.css" <<EOF
:root {
    --accent-bg-color: $ACCENT;
    --accent-color: $ACCENT;
    --accent-fg-color: #1e1e2e;
    --accent2-color: $ACCENT2;
}
EOF

# Rofi v2 (rgba ( R, G, B, % ) formati)
cat > "$CFG/rofi/colors.rasi" <<EOF
* {
    accent:          rgba ( $R, $G, $B, 100 % );
    border-clr:      rgba ( $R, $G, $B, 30 % );
    selected-bg:     rgba ( $R, $G, $B, 18 % );
}
EOF

# Kitty (kitty.conf sonunda include) - ANSI yesil (color2/10) bilerek dokunulmuyor
cat > "$CFG/kitty/colors-accent.conf" <<EOF
cursor                  $ACCENT
selection_background    $ACCENT
url_color               $ACCENT
active_tab_background   $ACCENT
mark2_background        $ACCENT
EOF

# Reload
pkill -SIGUSR2 -x waybar
swaync-client --reload-css >/dev/null 2>&1
pkill -SIGUSR1 -x kitty
hyprctl reload >/dev/null 2>&1
# hyprswitch CSS'i sadece init'te okuyor
if pgrep -x hyprswitch >/dev/null; then
    pkill -x hyprswitch
    setsid -f hyprswitch init --show-title --custom-css "$CFG/hypr/hyprswitch.css" >/dev/null 2>&1
fi
