# Dotfiles

Hyprland rice — Catppuccin Mocha (Green accent)

## Donanim

- **GPU:** NVIDIA RTX 4050 Laptop (oyunlar) + Intel UHD (genel kullanim)
- **Monitor:** HDMI 1920x1080@60Hz (sol) + Laptop 1920x1080@144Hz (sag)

## Icerikler

| Klasor | Aciklama |
|--------|----------|
| `hypr/` | Hyprland, hyprlock, hypridle, hyprswitch, scriptler |
| `waybar/` | Ust panel config + style |
| `rofi/` | Uygulama baslatici & guc menusu |
| `kitty/` | Terminal emulatoru |
| `swaync/` | Bildirim servisi |
| `fastfetch/` | Sistem bilgisi |
| `kvantum/` | Qt tema motoru (Catppuccin Mocha Green) |
| `kando/` | Radial pie menu |
| `waypaper/` | Duvar kagidi yoneticisi |
| `networkmanager-dmenu/` | Rofi ile WiFi yonetimi |
| `applications/` | Steam .desktop (NVIDIA Prime Render Offload) |
| `system/` | SDDM tema + mkinitcpio NVIDIA modulleri (referans) |
| `bashrc` | Shell config (fastfetch) |
| `mimeapps.list` | Varsayilan uygulama iliskilendirmeleri |

## Paketler

### Pacman

```bash
sudo pacman -S --needed \
    hyprland hyprlock hypridle waybar kitty swaync dolphin loupe sddm awww \
    kvantum grim slurp wl-clipboard cliphist playerctl brightnessctl \
    blueman pavucontrol btop fastfetch yad ydotool steam spotify-launcher \
    nvidia-open-dkms nvidia-utils xdg-desktop-portal-hyprland \
    ttf-jetbrains-mono-nerd noto-fonts-emoji zip unzip github-cli
```

### AUR (yay)

```bash
yay -S --needed \
    rofi-wayland hyprswitch waypaper kando-bin \
    catppuccin-cursors-mocha kvantum-theme-catppuccin-git \
    networkmanager-dmenu-git auto-cpufreq
```

### Diger

```bash
# Spicetify (Spotify tema motoru)
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
```

## Kurulum

```bash
# 1. Repoyu klonla
git clone https://github.com/nazms23/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Paketleri kur
chmod +x packages.sh && ./packages.sh

# 3. Symlink'leri olustur
chmod +x install.sh && ./install.sh
```

## Kisayollar

| Tus | Islem |
|-----|-------|
| `SUPER + Q` | Terminal (Kitty) |
| `SUPER + R` | Uygulama baslat (Rofi) |
| `SUPER + E` | Dosya yoneticisi |
| `SUPER + C` | Pencereyi kapat |
| `SUPER + F` | Tam ekran |
| `SUPER + T` | Float pencere |
| `SUPER + W` | Duvar kagidi degistir |
| `SUPER + D` | Kando pie menu |
| `SUPER + H` | Yardim menusu (5 sayfa) |
| `SUPER + M` | Guc menusu |
| `SUPER + L` | Ekrani kilitle |
| `SUPER + V` | Pano gecmisi |
| `SUPER + N` | Bildirim paneli |
| `SUPER + SHIFT + S` | Ekran goruntusu (alan sec) |
| `SUPER + F11` | WiFi yoneticisi |
| `ALT + TAB` | Pencere gecisi |
| `ALT + SHIFT` | TR/EN klavye degistir |
| `SUPER + 1-0` | Calisma alanlari |
| `SUPER + ALT + HJKL` | Fare emulasyonu (vim) |

## Ekran Goruntusu

<!-- TODO: Screenshot ekle -->
