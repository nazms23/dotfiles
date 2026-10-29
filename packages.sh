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
    nwg-look \
    pacman-contrib hyprsunset satty hyprshutdown tree-sitter-cli papirus-icon-theme \
    python-gobject gtk4 libadwaita

echo ""
echo "=== AUR paketleri kuruluyor (yay) ==="
yay -S --needed \
    rofi-wayland \
    matugen-bin \
    waypaper \
    kando-bin \
    rofi-calc \
    catppuccin-cursors-mocha \
    kvantum-theme-catppuccin-git \
    networkmanager-dmenu-git \
    auto-cpufreq \
    swayosd-git \
    catppuccin-gtk-theme-mocha \
    wlogout \
    libratbag piper \
    spicetify-bin

echo ""
echo "=== hyprswitch (yerel yamali PKGBUILD, Hyprland 0.57 uyumu) ==="
(cd "$(dirname "$(readlink -f "$0")")/pkgbuilds/hyprswitch" && makepkg -si --needed --noconfirm)

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
