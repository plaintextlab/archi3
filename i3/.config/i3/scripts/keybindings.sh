#!/usr/bin/env bash
CONFIG="$HOME/.config/i3/config"

grep -oP '(?<=# keyboard_shortcut_comment: ).*' "$CONFIG" | rofi -dmenu -i -p "keybindings"