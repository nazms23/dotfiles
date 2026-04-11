#!/bin/bash
# Dotfiles paket kurulum scripti
# Kullanım: chmod +x packages.sh && ./packages.sh

echo "=== Pacman paketleri kuruluyor ==="
sudo pacman -S --needed \
    hyprland hyprlock hypridle \
    waybar kitty swaync dolphin loupe \
    sddm \
    awww \
    kvantum \
    grim slurp wl-clipboard cliphist \
    playerctl brightnessctl \
    blueman pavucontrol \
    btop fastfetch yad \
    ydotool \
    steam spotify-launcher \
    nvidia-open-dkms nvidia-utils \
    xdg-desktop-portal-hyprland \
    ttf-jetbrains-mono-nerd noto-fonts-emoji \
    zip unzip \
    github-cli \
    eww \
    nwg-look

echo ""
echo "=== AUR paketleri kuruluyor (yay) ==="
yay -S --needed \
    rofi-wayland \
    hyprswitch \
    waypaper \
    kando-bin \
    catppuccin-cursors-mocha \
    kvantum-theme-catppuccin-git \
    networkmanager-dmenu-git \
    auto-cpufreq \
    swayosd-git \
    catppuccin-gtk-theme-mocha \
    wlogout \
    libratbag piper

echo ""
echo "=== Spicetify kuruluyor ==="
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh

echo ""
echo "=== Hyprexpo plugin kur ==="
hyprpm update
hyprpm add https://github.com/hyprwm/hyprland-plugins
hyprpm enable hyprexpo
hyprpm reload

echo ""
echo "=== Servisleri etkinlestir ==="
sudo systemctl enable sddm
sudo systemctl enable NetworkManager
systemctl --user enable ydotoold
sudo systemctl enable ratbagd

echo ""
echo "Kurulum tamamlandi! Simdi symlink'leri olusturun: ./install.sh"
