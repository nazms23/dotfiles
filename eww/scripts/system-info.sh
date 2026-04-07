#!/bin/bash
# Sistem bilgisi script'i - EWW için JSON çıktı

get_cpu() {
    awk '/^cpu /{u2=$2+$4; t2=$2+$3+$4+$5+$6+$7+$8; print u2, t2}' /proc/stat
    sleep 0.5
    awk '/^cpu /{u2=$2+$4; t2=$2+$3+$4+$5+$6+$7+$8; print u2, t2}' /proc/stat
}

cpu_usage() {
    read u1 t1 < <(awk '/^cpu /{print $2+$4, $2+$3+$4+$5+$6+$7+$8}' /proc/stat)
    sleep 0.5
    read u2 t2 < <(awk '/^cpu /{print $2+$4, $2+$3+$4+$5+$6+$7+$8}' /proc/stat)
    echo $(( (u2-u1) * 100 / (t2-t1) ))
}

ram_usage() {
    free | awk '/Mem:/{printf "%d", $3/$2 * 100}'
}

disk_usage() {
    df -h / | awk 'NR==2{print $5}' | tr -d '%'
}

battery_percent() {
    cat /sys/class/power_supply/BAT*/capacity 2>/dev/null || echo "0"
}

battery_status() {
    cat /sys/class/power_supply/BAT*/status 2>/dev/null || echo "Unknown"
}

volume_percent() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | awk '{printf "%d", $2 * 100}'
}

volume_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null | grep -q MUTED && echo "true" || echo "false"
}

brightness_percent() {
    brightnessctl -m | awk -F, '{print $4}' | tr -d '%'
}

wifi_ssid() {
    nmcli -t -f active,ssid dev wifi | awk -F: '/^yes/{print $2}'
}

wifi_signal() {
    nmcli -t -f active,signal dev wifi | awk -F: '/^yes/{print $2}'
}

bluetooth_connected() {
    bluetoothctl devices Connected 2>/dev/null | head -1 | cut -d' ' -f3-
}

bluetooth_powered() {
    bluetoothctl show 2>/dev/null | grep -q "Powered: yes" && echo "true" || echo "false"
}

case "$1" in
    cpu) cpu_usage ;;
    ram) ram_usage ;;
    disk) disk_usage ;;
    battery) battery_percent ;;
    battery-status) battery_status ;;
    volume) volume_percent ;;
    volume-muted) volume_muted ;;
    brightness) brightness_percent ;;
    wifi-ssid) wifi_ssid ;;
    wifi-signal) wifi_signal ;;
    bt-device) bluetooth_connected ;;
    bt-powered) bluetooth_powered ;;
    *) echo "Usage: $0 {cpu|ram|disk|battery|battery-status|volume|volume-muted|brightness|wifi-ssid|wifi-signal|bt-device|bt-powered}" ;;
esac
