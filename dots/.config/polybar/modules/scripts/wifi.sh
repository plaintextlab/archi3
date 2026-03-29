#!/usr/bin/env bash

iface="wlan0"
essid=$(nmcli device | awk '$2=="wifi" && $3=="connected" {print $4}')
signal=$(awk 'NR==3 {print int($3 * 10 / 7)}' /proc/net/wireless 2>/dev/null)

if [[ -z "$essid" ]]; then
    echo "󰤭  disconnected"
else
    if   [[ $signal -ge 80 ]]; then icon="󰤨"
    elif [[ $signal -ge 60 ]]; then icon="󰤥"
    elif [[ $signal -ge 40 ]]; then icon="󰤢"
    elif [[ $signal -ge 20 ]]; then icon="󰤟"
    else icon="󰤯"
    fi
    echo "$icon $essid · $signal%"
fi
