#!/bin/bash
# Hava durumu — wttr.in API

CACHE_FILE="/tmp/eww-weather-cache"
CACHE_TTL=1800  # 30 dakika

if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE"))) -lt $CACHE_TTL ]; then
    cat "$CACHE_FILE"
    exit 0
fi

data=$(curl -sf "wttr.in/Kastamonu+Merkez?format=%c|%t|%l" 2>/dev/null)

if [ -n "$data" ]; then
    icon=$(echo "$data" | cut -d'|' -f1 | xargs)
    temp=$(echo "$data" | cut -d'|' -f2 | xargs)
    echo "${icon} ${temp} Kastamonu" > "$CACHE_FILE"
    cat "$CACHE_FILE"
else
    echo "☁ --°C"
fi
