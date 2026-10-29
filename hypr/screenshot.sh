#!/bin/bash
# Ekran goruntusu + bildirim (Duzenle: satty, Kaydet: ~/Screenshots)
# Kullanim: screenshot.sh region   -> alan sec, panoya kopyala
#           screenshot.sh full     -> tum ekranlar, ~/Screenshots'a kaydet

DIR="$HOME/Screenshots"
STAMP=$(date +%Y%m%d_%H%M%S)
mkdir -p "$DIR"

case "$1" in
    region)
        GEOM=$(slurp -d) || exit 0
        FILE="${XDG_RUNTIME_DIR:-/tmp}/screenshot-$STAMP.png"
        grim -g "$GEOM" "$FILE" || exit 1
        BODY="Panoya kopyalandı"
        ;;
    full)
        FILE="$DIR/$STAMP.png"
        grim "$FILE" || exit 1
        BODY="Kaydedildi: ~/Screenshots/$STAMP.png"
        ;;
    *) echo "Kullanim: $0 region|full" >&2; exit 1 ;;
esac

wl-copy < "$FILE"

ACTIONS=()
command -v satty >/dev/null && ACTIONS+=(-A "edit=Düzenle")
[ "$1" = region ] && ACTIONS+=(-A "save=Kaydet")

ACTION=$(notify-send -a "Ekran Görüntüsü" -i "$FILE" -t 6000 "${ACTIONS[@]}" "Ekran görüntüsü" "$BODY")

case "$ACTION" in
    edit)
        satty --filename "$FILE" --output-filename "$DIR/satty-$STAMP.png" --copy-command wl-copy --early-exit
        ;;
    save)
        cp "$FILE" "$DIR/$STAMP.png"
        notify-send -a "Ekran Görüntüsü" -i "$DIR/$STAMP.png" -t 3000 "Kaydedildi" "~/Screenshots/$STAMP.png"
        ;;
esac
