#!/bin/bash
# Kisayol yardim ekrani (SUPER+H): hyprland.lua'daki bind aciklamalarindan otomatik uretilir.
# Aciklama formati: "Kategori: Ne yapar" veya "Kategori: [Tus gosterimi] Ne yapar".
# Yeni bind eklerken sadece hyprland.lua'da description yaz; bu dosyaya dokunmaya gerek yok.
# Bind olmayan eylemler (waybar tiklamalari vb.) asagidaki EXTRA listesinde.

pkill -x rofi && exit 0

source ~/.config/hypr/accent.env 2>/dev/null
ACCENT=${ACCENT:-#a6e3a1}
OUT="${XDG_RUNTIME_DIR:-/tmp}/hypr-help.txt"

hyprctl binds -j | ACCENT="$ACCENT" python3 -I -c '
import json, os, sys, html

ACCENT = os.environ["ACCENT"]
ORDER = ["Genel", "Pencere", "Workspace", "Sistem", "Ekran", "Medya", "Fare", "Waybar", "Klavye"]

EXTRA = [
    ("Waybar", "Saat (üzerine gel)", "Takvim"),
    ("Waybar", "Saat (tık)", "Tarih biçimini değiştir"),
    ("Waybar", "Medya (tık / sağ tık)", "Oynat-duraklat / sonraki"),
    ("Waybar", "Ses (tık / sağ tık)", "Ses ayarları / sustur, tekerlek: ses"),
    ("Waybar", "Güncellemeler (tık)", "Sistemi güncelle (yay -Syu)"),
    ("Waybar", "Kontrol merkezi (tık / sağ tık)", "Paneli aç / rahatsız etme"),
    ("Klavye", "ALT + SHIFT", "Türkçe / İngilizce düzen değiştir"),
]

MODS = [(64, "SUPER"), (4, "CTRL"), (8, "ALT"), (1, "SHIFT")]
KEYNAMES = {"left": "←", "right": "→", "up": "↑", "down": "↓", "TAB": "Tab", "Print": "PrtSc"}

def keystr(b):
    parts = [n for m, n in MODS if b["modmask"] & m]
    k = b["key"]
    parts.append(KEYNAMES.get(k, k.upper() if len(k) == 1 else k))
    return " + ".join(parts)

rows = {}
for b in json.load(sys.stdin):
    if not b.get("has_description"):
        continue
    d = b["description"]
    cat, _, text = d.partition(": ")
    if not text:
        cat, text = "Diğer", d
    keys = keystr(b)
    if text.startswith("[") and "] " in text:
        keys, text = text[1:].split("] ", 1)
    rows.setdefault(cat, []).append((keys, text))

for cat, keys, text in EXTRA:
    rows.setdefault(cat, []).append((keys, text))

cats = sorted(rows, key=lambda c: ORDER.index(c) if c in ORDER else len(ORDER))
width = max(len(k) for r in rows.values() for k, _ in r) + 3
lines, headers = [], []
for c in cats:
    headers.append(len(lines))
    lines.append(f"<span foreground=\"{ACCENT}\" weight=\"bold\">── {html.escape(c, quote=False)} ──</span>")
    for k, t in rows[c]:
        lines.append(f"<b>{html.escape(k.ljust(width), quote=False)}</b>{html.escape(t, quote=False)}")

print(",".join(map(str, headers)))
print("\n".join(lines))
' > "$OUT"

tail -n +2 "$OUT" | rofi -dmenu -i -markup-rows -no-custom \
    -p "Kısayollar" -a "$(head -1 "$OUT")" \
    -mesg "Aramak için yaz · Esc: kapat" \
    -theme ~/.config/rofi/keybinds.rasi >/dev/null
