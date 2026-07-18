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
    tesseract tesseract-data-osd tesseract-data-eng tesseract-data-jpn tesseract-data-jpn_vert tesseract-data-tur \
    playerctl brightnessctl \
    blueman pavucontrol \
    neovim \
    btop fastfetch yad \
    ydotool \
    steam spotify-launcher \
    nvidia-open-dkms nvidia-utils nvidia-prime \
    xdg-desktop-portal-hyprland \
    ttf-jetbrains-mono-nerd noto-fonts-emoji \
    zip unzip \
    github-cli \
    alsa-utils \
    earlyoom \
    nwg-look

echo ""
echo "=== AUR paketleri kuruluyor (yay) ==="
yay -S --needed \
    rofi-wayland \
    hyprswitch \
    waypaper \
    kando-bin \
    eww-git \
    rofi-calc \
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
echo "=== earlyoom config (RAM tukenince donma yerine sizan process'i oldur) ==="
sudo tee /etc/default/earlyoom >/dev/null <<'EOF'
EARLYOOM_ARGS="-r 3600 -m 10 -s 8 --prefer '(^|/)Discord$' --avoid '(^|/)(Hyprland|Xorg|Xwayland|systemd|sshd|wireplumber|pipewire|gamescope)$' -n"
EOF

echo ""
echo "=== Servisleri etkinlestir ==="
sudo systemctl enable sddm
sudo systemctl enable NetworkManager
systemctl --user enable ydotoold
sudo systemctl enable ratbagd
sudo systemctl enable --now earlyoom

echo ""
echo "Kurulum tamamlandi! Simdi symlink'leri olusturun: ./install.sh"
