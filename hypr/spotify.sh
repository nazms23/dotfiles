#!/bin/bash
# Spotify'i acar; spotify-launcher Spotify'i guncelleyip spicetify yamasini sildiyse
# temayi otomatik yeniden uygular (spicetify backup apply, Spotify'i yeniden baslatir).
# Desktop dosyasi (applications/spotify-launcher.desktop) ve Kando bunu kullanir.

APPS="$HOME/.local/share/spotify-launcher/install/usr/share/spotify/Apps"

# Zaten aciksa sadece one getir / URI'yi ilet
if pgrep -x spotify >/dev/null; then
    exec spotify-launcher "$@"
fi

spotify-launcher "$@" &

# spotify-launcher gerekirse once guncelliyor; Spotify penceresi acilana kadar bekle (max 60 sn)
for _ in $(seq 60); do
    pgrep -x spotify >/dev/null && break
    sleep 1
done
sleep 2

# Yamali Spotify'da xpui.spa yok (spicetify Apps/xpui klasorune acar). Varsa tema silinmis demektir.
if [ -f "$APPS/xpui.spa" ] && command -v spicetify >/dev/null; then
    notify-send -a Spotify -i spotify-launcher "Spotify güncellendi" "Tema yeniden uygulanıyor..."
    if spicetify backup apply >/dev/null 2>&1; then
        notify-send -a Spotify -i spotify-launcher "Spicetify" "Tema uygulandı"
    else
        notify-send -a Spotify -u critical -i spotify-launcher "Spicetify uygulanamadı" \
            "Bu Spotify sürümü için spicetify güncellemesi gerekebilir: yay -Syu, sonra spicetify backup apply"
    fi
fi
