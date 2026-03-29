#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$(realpath "$0")")" && pwd)"
CURRENT_FILE="$SCRIPT_DIR/.current"
WALLPAPER_DIR="$SCRIPT_DIR/wallpapers"
WALLPAPER_TMP="/tmp/wallpaper-current.png"

# blend strength: 0=original only, 100=duotone only
BLEND=50

if [ ! -f "$CURRENT_FILE" ]; then
    echo "No current theme set"
    exit 1
fi

SLUG=$(cat "$CURRENT_FILE")

declare -A DUOTONE=(
    [gruvbox-dark]="#282828|#458588"
    [gruvbox-light]="#ebdbb2|#458588"
    [catppuccin-mocha]="#1e1e2e|#cba6f7"
    [catppuccin-macchiato]="#24273a|#c6a0f6"
    [catppuccin-latte]="#eff1f5|#8839ef"
    [tokyo-night]="#1a1b26|#7aa2f7"
    [tokyo-night-storm]="#24283b|#7aa2f7"
    [tokyo-night-day]="#e1e2e7|#2e7de9"
    [nord]="#2e3440|#81a1c1"
    [everforest-dark]="#2d353b|#a7c080"
    [everforest-light]="#fffbef|#8da101"
    [dracula]="#282a36|#bd93f9"
    [solarized-dark]="#002b36|#268bd2"
    [solarized-light]="#fdf6e3|#268bd2"
    [one-dark]="#282c34|#61afef"
    [one-light]="#fafafa|#4078f2"
    [kanagawa]="#1f1f28|#7e9cd8"
    [rose-pine]="#191724|#c4a7e7"
    [rose-pine-moon]="#232136|#c4a7e7"
    [rose-pine-dawn]="#faf4ed|#907aa9"
    [monokai]="#272822|#a6e22e"
    [material-dark]="#212121|#82aaff"
    [material-ocean]="#0f111a|#82aaff"
    [palenight]="#292d3e|#82aaff"
    [ayu-dark]="#0a0e14|#59c2ff"
    [ayu-mirage]="#1f2430|#73d0ff"
    [ayu-light]="#fafafa|#55b4d4"
    [oxocarbon]="#161616|#78a9ff"
    [mellow]="#1e1e1e|#b3b9c5"
    [melange]="#292522|#d47766"
)

apply_wallpaper() {
    local src="$1"
    IFS='|' read -r SHADOW HIGHLIGHT <<< "${DUOTONE[$SLUG]}"

    local clut_tmp="/tmp/duotone-clut.png"
    local duotone_tmp="/tmp/duotone-layer.png"

    # generate clut and apply duotone layer
    magick -size 1x256 gradient:"${SHADOW}-${HIGHLIGHT}" "$clut_tmp"
    magick "$src" -colorspace Gray \( "$clut_tmp" \) -clut "$duotone_tmp" 2>/dev/null

    # blend original colors with duotone layer
    magick "$src" "$duotone_tmp" \
        -compose Blend \
        -define compose:args=$BLEND \
        -composite "$WALLPAPER_TMP" 2>/dev/null

    if [ $? -eq 0 ]; then
        feh --bg-scale "$WALLPAPER_TMP"
    else
        echo "Warning: blend failed, using original"
        feh --bg-scale "$src"
    fi
}

mapfile -t WALLS < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \))
if [ ${#WALLS[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

RANDOM_WALL="${WALLS[RANDOM % ${#WALLS[@]}]}"
apply_wallpaper "$RANDOM_WALL"
