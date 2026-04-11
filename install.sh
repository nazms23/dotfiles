#!/bin/bash
# Dotfiles symlink kurulum scripti
# Kullanım: chmod +x install.sh && ./install.sh

DOTFILES="$HOME/dotfiles"

echo "=== Dizinler olusturuluyor ==="
mkdir -p ~/.config/{hypr,waybar,rofi,kitty,swaync,fastfetch,Kvantum,networkmanager-dmenu,kando,waypaper,eww/scripts,wlogout,btop/themes}
mkdir -p ~/.local/share/applications

echo "=== Symlink'ler olusturuluyor ==="

# Hyprland
for f in "$DOTFILES"/hypr/*; do
    ln -sf "$f" ~/.config/hypr/$(basename "$f")
done

# Waybar
for f in "$DOTFILES"/waybar/*; do
    ln -sf "$f" ~/.config/waybar/$(basename "$f")
done

# Rofi
for f in "$DOTFILES"/rofi/*; do
    ln -sf "$f" ~/.config/rofi/$(basename "$f")
done

# Kitty
ln -sf "$DOTFILES/kitty/kitty.conf" ~/.config/kitty/kitty.conf

# Swaync
for f in "$DOTFILES"/swaync/*; do
    ln -sf "$f" ~/.config/swaync/$(basename "$f")
done

# Fastfetch
ln -sf "$DOTFILES/fastfetch/config.jsonc" ~/.config/fastfetch/config.jsonc

# Kvantum
ln -sf "$DOTFILES/kvantum/kvantum.kvconfig" ~/.config/Kvantum/kvantum.kvconfig

# NetworkManager-dmenu
ln -sf "$DOTFILES/networkmanager-dmenu/config.ini" ~/.config/networkmanager-dmenu/config.ini

# Kando
ln -sf "$DOTFILES/kando/config.json" ~/.config/kando/config.json
ln -sf "$DOTFILES/kando/menus.json" ~/.config/kando/menus.json

# Waypaper
ln -sf "$DOTFILES/waypaper/config.ini" ~/.config/waypaper/config.ini

# EWW
ln -sf "$DOTFILES/eww/eww.yuck" ~/.config/eww/eww.yuck
ln -sf "$DOTFILES/eww/eww.scss" ~/.config/eww/eww.scss
for f in "$DOTFILES"/eww/scripts/*; do
    ln -sf "$f" ~/.config/eww/scripts/$(basename "$f")
done

# Wlogout
for f in "$DOTFILES"/wlogout/*; do
    ln -sf "$f" ~/.config/wlogout/$(basename "$f")
done

# Btop
ln -sf "$DOTFILES/btop/btop.conf" ~/.config/btop/btop.conf
for f in "$DOTFILES"/btop/themes/*; do
    ln -sf "$f" ~/.config/btop/themes/$(basename "$f")
done

# Steam (NVIDIA Prime)
ln -sf "$DOTFILES/applications/steam.desktop" ~/.local/share/applications/steam.desktop

# Bashrc
ln -sf "$DOTFILES/bashrc" ~/.bashrc

# Mimeapps
ln -sf "$DOTFILES/mimeapps.list" ~/.config/mimeapps.list

echo ""
echo "=== Sistem config'leri (sudo gerekli) ==="
echo "SDDM temasi icin:"
echo "  sudo mkdir -p /etc/sddm.conf.d"
echo "  sudo cp $DOTFILES/system/sddm-theme.conf /etc/sddm.conf.d/theme.conf"
echo ""
echo "NVIDIA mkinitcpio modulleri icin:"
cat "$DOTFILES/system/mkinitcpio-modules.txt"
echo "  Yukardaki satiri /etc/mkinitcpio.conf'a ekleyin ve 'sudo mkinitcpio -P' calistirin"
echo ""
echo "Kurulum tamamlandi! Hyprland'i yeniden baslatin."
