#!/bin/bash
# Gece isigi (hyprsunset) ac/kapa. swaync kontrol merkezindeki toggle butonu kullanir.
# Kullanim: nightlight.sh toggle | on | off | status

TEMP=4500

is_on() { pgrep -x hyprsunset >/dev/null; }

on() {
    is_on || setsid -f hyprsunset -t "$TEMP" >/dev/null 2>&1
}

off() {
    pkill -x hyprsunset
}

case "$1" in
    on) on ;;
    off) off ;;
    toggle) if is_on; then off; else on; fi ;;
    status) is_on && echo true || echo false ;;
    *) echo "Kullanim: $0 toggle|on|off|status" >&2; exit 1 ;;
esac
