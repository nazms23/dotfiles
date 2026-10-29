# Dotfiles

Hyprland rice — Catppuccin Mocha. Accent rengi duvar kağıdından otomatik (matugen), varsayılan Green.

## Donanim

- **GPU:** NVIDIA RTX 4050 Laptop (oyunlar) + Intel UHD (genel kullanim)
- **Monitor:** HDMI 1920x1080@60Hz (sol) + Laptop 1920x1080@144Hz (sag)

## Icerikler

| Klasor | Aciklama |
|--------|----------|
| `hypr/` | Hyprland (Lua config, 0.57+), hyprlock, hypridle, hyprswitch, scriptler |
| `waybar/` | Ust panel config + style |
| `rofi/` | Uygulama baslatici, guc menusu, kisayol yardimi |
| `kitty/` | Terminal emulatoru |
| `swaync/` | Bildirimler + kontrol merkezi (WiFi/BT/gece ışığı/oyun modu, ses, parlaklık, medya) |
| `fastfetch/` | Sistem bilgisi |
| `kvantum/` | Qt tema motoru (Catppuccin Mocha Green) |
| `kando/` | Radial pie menu |
| `waypaper/` | Duvar kagidi yoneticisi |
| `networkmanager-dmenu/` | Rofi ile WiFi yonetimi |
| `applications/` | Steam (NVIDIA Prime) ve Spotify (otomatik spicetify) .desktop |
| `pkgbuilds/` | Yerel yamali paketler (hyprswitch: Hyprland 0.57 uyumu) |
| `system/` | SDDM tema + mkinitcpio NVIDIA modulleri (referans) |
| `bashrc` | Shell config (fastfetch) |
| `mimeapps.list` | Varsayilan uygulama iliskilendirmeleri |

## Paketler

Tam liste ve kurulum sırası `packages.sh` içinde (pacman + AUR + yamalı hyprswitch PKGBUILD).

> Spotify güncellenip tema kaybolursa `~/.config/hypr/spotify.sh` açılışta otomatik `spicetify backup apply` yapar.
> Elle gerekirse: `spicetify backup apply` (eski yedek başka sürümdense `restore` KULLANMA).

## Accent renk sistemi

`update-accent.sh` (waypaper değişince) duvar kağıdından rengi matugen ile çıkarır,
`accent-apply.sh` her uygulama için küçük bir renk dosyası üretir (`waybar/colors.css`,
`rofi/colors.rasi`, `hypr/accent.lua`, `kitty/colors-accent.conf`...). Config'ler bunları
import eder; üretilen dosyalar git dışında, symlink'ler kırılmaz. `reset-accent.sh`: Catppuccin Green.

## Kendi uygulamalarım

Rice'a özel, sıfırdan yazılmış uygulamalar (Python + GTK4/libadwaita, Türkçe, GPL-3.0).
Accent rengi wallpaper'la canlı değişir. Her biri ayrı repo; `packages.sh` hepsini `~/Projects` altına indirip kurar.

| Uygulama | Repo | Durum |
|---|---|---|
| Hesap makinesi | [nazms23/hesap-makinesi](https://github.com/nazms23/hesap-makinesi) | ✅ |
| Görsel görüntüleyici | — | yapılıyor |
| Video oynatıcı | — | planlandı |
| Dosya yöneticisi | — | planlandı |

Accent rengi `hypr/accent-apply.sh` → `~/.config/accent/colors.css`; Hyprland pencere kuralları `hypr/hyprland.lua`'da.

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

Tam ve güncel liste: **`SUPER + H`** (hyprland.lua'daki bind açıklamalarından otomatik üretilir, aranabilir).
Yeni bind eklerken `description = "Kategori: Ne yapar"` yazmak yeterli.

| Tus | Islem |
|-----|-------|
| `SUPER + Q / R / E` | Terminal / uygulama başlatıcı / dosya yöneticisi |
| `SUPER + H` | Kısayol yardımı |
| `SUPER + N` | Kontrol merkezi |
| `SUPER + A` | Workspace genel bakış |
| `SUPER + S` / `SUPER + CTRL + S` | Scratchpad göster-gizle / pencereyi at-geri al |
| `SUPER + F1` | Oyun modu |
| `ALT + TAB` | Pencere geçişi |
| `SUPER + SHIFT + S` | Ekran görüntüsü (bildirimden Düzenle/Kaydet) |

## Ekran Goruntusu

<!-- TODO: Screenshot ekle -->
