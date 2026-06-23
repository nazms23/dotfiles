#!/bin/bash

CSS_FILE="/tmp/hypr-help-gtk.css"
cat > "$CSS_FILE" << 'CSSEOF'
* { font-family: "JetBrainsMono Nerd Font", monospace; }
window { background-color: #1e1e2e; border-radius: 16px; }
.dialog-text { color: #cdd6f4; font-size: 13px; }
button { background-color: #313244; color: #a5d396; border: 1px solid #45475a; border-radius: 8px; padding: 8px 20px; font-weight: bold; }
button:hover { background-color: #45475a; }
CSSEOF

S='<span foreground="#585b70">━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</span>'
K='foreground="#89b4fa"'
V='foreground="#cdd6f4"'
H='foreground="#94e2d5" weight="bold" size="large"'
A='foreground="#a5d396"'

PAGE1="<span font=\"16\" $A weight=\"bold\">SAYFA 1/5 — Genel ve Pencere</span>

$S

<span $H>Genel</span>
<span $K>SUPER + Q</span>              <span $V>Terminal ac (Kitty)</span>
<span $K>SUPER + R</span>              <span $V>Uygulama baslat (Rofi)</span>
<span $K>SUPER + E</span>              <span $V>Dosya yoneticisi</span>
<span $K>SUPER + M</span>              <span $V>Guc menusu (wlogout)</span>
<span $K>SUPER + H</span>              <span $V>Bu yardim penceresi</span>
<span $K>SUPER + W</span>              <span $V>Duvar kagidi degistir</span>

$S

<span $H>Pencere Yonetimi</span>
<span $K>SUPER + C</span>              <span $V>Pencereyi kapat</span>
<span $K>SUPER + F</span>              <span $V>Tam ekran</span>
<span $K>SUPER + T</span>              <span $V>Yuzdurulen pencere (float)</span>
<span $K>SUPER + P</span>              <span $V>Sahte karo modu</span>
<span $K>SUPER + J</span>              <span $V>Bolme yonunu degistir</span>
<span $K>SUPER + Yonler</span>         <span $V>Pencereler arasi odak degistir</span>

$S

<span $H>Pencere Boyutlandirma</span>
<span $K>SUPER + CTRL + Yonler</span>    <span $V>Klavyeyle boyut degistir</span>
<span $K>SUPER + Sol Tik</span>         <span $V>Pencereyi tasi (surukle)</span>
<span $K>SUPER + Sag Tik</span>         <span $V>Pencereyi boyutlandir</span>"

PAGE2="<span font=\"16\" $A weight=\"bold\">SAYFA 2/5 — Pencere Gecisi ve Alanlar</span>

$S

<span $H>Pencere Gecisi</span>
<span $K>ALT + TAB</span>              <span $V>Pencere secici (Windows tarzi)</span>
<span $K>ALT + SHIFT + TAB</span>      <span $V>Ters yonde pencere gec</span>
<span $K>ALT birak</span>              <span $V>Secili pencereye gec</span>

$S

<span $H>Calisma Alanlari</span>
<span $K>SUPER + 1-0</span>            <span $V>Calisma alanina gec (1-10)</span>
<span $K>SUPER + SHIFT + 1-0</span>    <span $V>Pencereyi alana tasi</span>
<span $K>SUPER + Fare Tekeri</span>    <span $V>Alanlar arasi kaydir</span>

$S

<span $H>Fare Emulasyonu (Klavye ile)</span>
<span $K>SUPER + ALT + H J K L</span>  <span $V>Fareyi tasi (vim tarzi)</span>
<span $K>SUPER + ALT + U</span>        <span $V>Sol tik</span>
<span $K>SUPER + ALT + Y</span>        <span $V>Sag tik</span>"

PAGE3="<span font=\"16\" $A weight=\"bold\">SAYFA 3/5 — Araclar</span>

$S

<span $H>Ekran ve Guvenlik</span>
<span $K>SUPER + L</span>              <span $V>Ekrani kilitle (Hyprlock)</span>
<span $K>SUPER + M</span>              <span $V>Wlogout (kapat/uyku/yeniden baslat)</span>

$S

<span $H>Pano ve Bildirimler</span>
<span $K>SUPER + V</span>              <span $V>Pano gecmisi (clipboard)</span>
<span $K>SUPER + N</span>              <span $V>Bildirim paneli (swaync)</span>

$S

<span $H>Ekran Goruntusu</span>
<span $K>SUPER + SHIFT + S</span>      <span $V>Alan secip panoya kopyala</span>
<span $K>Print</span>                  <span $V>Tam ekran kaydet (Screenshots/)</span>

$S

<span $H>Kando Pie Menu</span>
<span $K>SUPER + D</span>              <span $V>Kando radial menuyu ac</span>

$S

<span $H>Ag Yonetimi</span>
<span $K>SUPER + F11</span>            <span $V>WiFi yoneticisi (Rofi)</span>

$S

<span $H>EWW Widgetlar</span>
<span $K>SUPER + G</span>              <span $V>Masaustu widgeti goster/gizle</span>
<span $K>Waybar saat tikla</span>      <span $V>Takvim popup</span>
<span $K>Waybar disli tikla</span>     <span $V>Sistem popup (WiFi/BT/Ses/Parlaklik)</span>

$S

<span $H>Klavye ve Dil</span>
<span $K>ALT + SHIFT</span>            <span $V>Turkce / Ingilizce degistir</span>
<span $K>Waybar klavye ikonu</span>    <span $V>Tiklayarak dil degistir</span>"

PAGE4="<span font=\"16\" $A weight=\"bold\">SAYFA 4/5 — Medya ve Waybar</span>

$S

<span $H>Medya Kontrolleri (Waybar Ortasi)</span>
<span $K>Sarki adina tikla</span>      <span $V>Oynat / Duraklat</span>
<span $K>Sag tikla</span>              <span $V>Sonraki sarki</span>
<span $K>Onceki/Sonraki buton</span>   <span $V>Sarki degistir</span>
<span $K>Scroll</span>                 <span $V>Ses seviyesi</span>

$S

<span $H>Medya Tuslari (Klavye)</span>
<span $K>Ses +/-</span>                <span $V>Sistem sesini ayarla</span>
<span $K>Ses Kapat</span>              <span $V>Sesi sustur / ac</span>
<span $K>Parlaklik +/-</span>          <span $V>Ekran parlakligini ayarla</span>

$S

<span $H>Waybar Sag Taraf Modulleri</span>
<span $V>Bluetooth</span>     →  <span $K>Tiklayinca Blueman acar</span>
<span $V>WiFi</span>           →  <span $K>Tiklayinca ag ayarlari</span>
<span $V>Pil</span>            →  <span $K>Sarj durumu ve kalan sure</span>
<span $V>Ses</span>            →  <span $K>Sol tik: pavucontrol / Sag tik: sustur</span>
<span $V>Sistem</span>         →  <span $K>Tiklayinca btop acar</span>
<span $V>Klavye</span>         →  <span $K>Tiklayinca TR/EN degistirir</span>
<span $V>Tarih</span>          →  <span $K>Turkce tarih + takvim</span>
<span $V>Bildirim</span>       →  <span $K>Bildirim panelini acar</span>
<span $V>Guncellemeler</span>  →  <span $K>Tiklayinca sistem gunceller</span>"

PAGE5="<span font=\"16\" $A weight=\"bold\">SAYFA 5/5 — Kurulu Sistem</span>

$S

<span $H>Uygulamalar</span>
<span $V>Kitty</span>           →  <span $K>Terminal emulatoru</span>
<span $V>Brave</span>           →  <span $K>Web tarayicisi</span>
<span $V>Steam</span>           →  <span $K>Oyun platformu (NVIDIA GPU)</span>
<span $V>Spotify</span>         →  <span $K>Muzik (spicetify temali)</span>
<span $V>Dolphin</span>         →  <span $K>Dosya yoneticisi</span>
<span $V>Loupe</span>           →  <span $K>Resim goruntleyici</span>
<span $V>Kando</span>           →  <span $K>Radial pie menu</span>
<span $V>Kvantum</span>         →  <span $K>Qt tema motoru (Catppuccin)</span>
<span $V>EWW</span>             →  <span $K>Masaustu widget sistemi</span>
<span $V>SwayOSD</span>         →  <span $K>Ses/parlaklik ekran gostergesi</span>
<span $V>Btop</span>            →  <span $K>Sistem monitoru (Catppuccin temali)</span>
<span $V>Wlogout</span>         →  <span $K>Guc/cikis menusu</span>

$S

<span $H>Arka Plan Servisleri</span>
<span $V>Waybar</span>          →  <span $K>Ust panel</span>
<span $V>Swaync</span>          →  <span $K>Bildirim servisi</span>
<span $V>Hyprlock</span>        →  <span $K>Ekran kilidi</span>
<span $V>Hypridle</span>        →  <span $K>Bosta bekleme yonetimi</span>
<span $V>Hyprswitch</span>      →  <span $K>Alt+Tab pencere gecisi</span>
<span $V>AWWW</span>            →  <span $K>Duvar kagidi servisi</span>
<span $V>SDDM</span>            →  <span $K>Giris ekrani (Catppuccin)</span>
<span $V>Ydotool</span>         →  <span $K>Klavye ile fare emulasyonu</span>

$S

<span $H>Donanim</span>
<span $V>GPU</span>             →  <span $K>NVIDIA RTX 4050 (oyunlar) + Intel UHD</span>
<span $V>Tema</span>            →  <span $K>Catppuccin Mocha (tum sistem)</span>
<span $V>Monitor</span>         →  <span $K>HDMI (sol) + Laptop (sag)</span>"

show_page() {
    local page=$1
    local text
    case $page in
        1) text="$PAGE1" ;;
        2) text="$PAGE2" ;;
        3) text="$PAGE3" ;;
        4) text="$PAGE4" ;;
        5) text="$PAGE5" ;;
    esac

    result=$(yad --text="$text" \
        --title="" \
        --width=600 \
        --height=680 \
        --center \
        --text-align=left \
        --markup \
        --no-escape \
        --on-top \
        --undecorated \
        --borders=24 \
        --gtkrc="$CSS_FILE" \
        --button="Onceki:2" \
        --button="Sonraki:3" \
        --button="Kapat:0")
    echo $?
}

current_page=1
while true; do
    ret=$(show_page $current_page)
    case $ret in
        0) exit 0 ;;        # Kapat
        2)                   # Onceki
            if [ $current_page -gt 1 ]; then
                current_page=$((current_page - 1))
            fi
            ;;
        3)                   # Sonraki
            if [ $current_page -lt 5 ]; then
                current_page=$((current_page + 1))
            fi
            ;;
        *) exit 0 ;;        # ESC veya diger
    esac
done
