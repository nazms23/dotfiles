#!/usr/bin/env bash
# OCR - ekrandan metin tanima (Witch on the Holy Night vb. oyunlar icin)
# Secilen alandaki yaziyi tanir, panoya kopyalar ve bildirim gosterir.
#
# Kullanim:
#   ocr.sh           -> Ingilizce (varsayilan)
#   ocr.sh eng       -> Ingilizce
#   ocr.sh jpn       -> Japonca
#   ocr.sh tur       -> Turkce
#   ocr.sh eng+jpn   -> Birlikte
#   ocr.sh menu      -> Rofi ile dil sec

set -uo pipefail

OCR_LANG="${1:-eng}"

# Rofi ile dil secimi
if [ "$OCR_LANG" = "menu" ]; then
    CHOICE=$(printf "Ingilizce\nJaponca\nTurkce\nIngilizce + Japonca" \
        | rofi -dmenu -i -p "OCR dili")
    case "$CHOICE" in
        "Ingilizce")            OCR_LANG="eng" ;;
        "Japonca")              OCR_LANG="jpn" ;;
        "Turkce")               OCR_LANG="tur" ;;
        "Ingilizce + Japonca")  OCR_LANG="eng+jpn" ;;
        *) exit 0 ;;
    esac
fi

# Gerekli araclar var mi?
for bin in slurp grim tesseract wl-copy; do
    command -v "$bin" >/dev/null 2>&1 || {
        notify-send -a "OCR" "OCR hatasi" "Eksik arac: $bin"
        exit 1
    }
done

TMP=$(mktemp /tmp/ocr-XXXXXX.png)
trap 'rm -f "$TMP"' EXIT

# Alan sec (iptal edilirse cikar)
GEOM=$(slurp -d) || exit 0
[ -z "$GEOM" ] && exit 0

grim -g "$GEOM" "$TMP"

# Metni tani, bas-son bosluklari ve bos satirlari temizle
TEXT=$(tesseract "$TMP" - -l "$OCR_LANG" 2>/dev/null | sed '/^[[:space:]]*$/d')

if [ -z "$TEXT" ]; then
    notify-send -a "OCR" "OCR ($OCR_LANG)" "Metin bulunamadi."
    exit 0
fi

printf '%s' "$TEXT" | wl-copy

PREVIEW=$(printf '%s' "$TEXT" | head -c 220)
notify-send -a "OCR" "Metin kopyalandi ($OCR_LANG)" "$PREVIEW"
