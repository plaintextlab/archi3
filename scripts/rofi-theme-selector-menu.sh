#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$(realpath "$0")")" && pwd)"
PRESET_DIR="$HOME/.config/scripts/gtk/themes"
CURRENT_FILE="$SCRIPT_DIR/.current"
POLYBAR_DIR="$HOME/.config/polybar"
ALACRITTY_THEMES="$HOME/.config/alacritty/themes"
ROFI_THEMES="$HOME/.config/rofi/themes"

# theme map: slug -> "papirus_folder_color|papirus_variant|gtk_theme"
declare -A THEMES=(
    [gruvbox-dark]="brown|Papirus-Dark|Orchis-Dark"
    [gruvbox-light]="yellow|Papirus-Light|Orchis-Light"
    [catppuccin-mocha]="mauve|Papirus-Dark|Orchis-Dark"
    [catppuccin-macchiato]="mauve|Papirus-Dark|Orchis-Dark"
    [catppuccin-latte]="lavender|Papirus-Light|Orchis-Light"
    [tokyo-night]="blue|Papirus-Dark|Orchis-Dark"
    [tokyo-night-storm]="blue|Papirus-Dark|Orchis-Dark"
    [tokyo-night-day]="blue|Papirus-Light|Orchis-Light"
    [nord]="nordic|Papirus-Dark|Orchis-Dark"
    [everforest-dark]="green|Papirus-Dark|Orchis-Dark"
    [everforest-light]="green|Papirus-Light|Orchis-Light"
    [dracula]="violet|Papirus-Dark|Orchis-Dark"
    [solarized-dark]="blue|Papirus-Dark|Orchis-Dark"
    [solarized-light]="blue|Papirus-Light|Orchis-Light"
    [one-dark]="blue|Papirus-Dark|Orchis-Dark"
    [one-light]="blue|Papirus-Light|Orchis-Light"
    [kanagawa]="blue|Papirus-Dark|Orchis-Dark"
    [rose-pine]="pink|Papirus-Dark|Orchis-Dark"
    [rose-pine-moon]="pink|Papirus-Dark|Orchis-Dark"
    [rose-pine-dawn]="pink|Papirus-Light|Orchis-Light"
    [monokai]="green|Papirus-Dark|Orchis-Dark"
    [material-dark]="blue|Papirus-Dark|Orchis-Dark"
    [material-ocean]="blue|Papirus-Dark|Orchis-Dark"
    [palenight]="violet|Papirus-Dark|Orchis-Dark"
    [ayu-dark]="yellow|Papirus-Dark|Orchis-Dark"
    [ayu-mirage]="yellow|Papirus-Dark|Orchis-Dark"
    [ayu-light]="yellow|Papirus-Light|Orchis-Light"
    [oxocarbon]="blue|Papirus-Dark|Orchis-Dark"
    [mellow]="grey|Papirus-Dark|Orchis-Dark"
    [melange]="brown|Papirus-Dark|Orchis-Dark"
)

# xob color map: slug -> "normal_fg|normal_bg|normal_border|alt_fg|alt_bg|alt_border|overflow_fg|overflow_bg|overflow_border"
# Columns: normal(filled bar) | alt(empty bar) | overflow(>100%)
declare -A XOB_COLORS=(
    [gruvbox-dark]="#d79921|#282828|#d65d0e|#504945|#282828|#3c3836|#cc241d|#282828|#9d0006"
    [gruvbox-light]="#d79921|#fbf1c7|#d65d0e|#bdae93|#fbf1c7|#d5c4a1|#cc241d|#fbf1c7|#9d0006"
    [catppuccin-mocha]="#cba6f7|#1e1e2e|#89b4fa|#313244|#1e1e2e|#45475a|#f38ba8|#1e1e2e|#eba0ac"
    [catppuccin-macchiato]="#c6a0f6|#24273a|#8aadf4|#363a4f|#24273a|#494d64|#ed8796|#24273a|#ee99a0"
    [catppuccin-latte]="#8839ef|#eff1f5|#1e66f5|#bcc0cc|#eff1f5|#acb0be|#d20f39|#eff1f5|#e64553"
    [tokyo-night]="#7aa2f7|#1a1b26|#7dcfff|#292e42|#1a1b26|#3b4261|#f7768e|#1a1b26|#db4b4b"
    [tokyo-night-storm]="#7aa2f7|#24283b|#7dcfff|#363d59|#24283b|#3b4261|#f7768e|#24283b|#db4b4b"
    [tokyo-night-day]="#2e7de9|#e1e2e7|#007197|#a8aecb|#e1e2e7|#c4c8da|#f52a65|#e1e2e7|#c64343"
    [nord]="#81a1c1|#2e3440|#88c0d0|#434c5e|#2e3440|#3b4252|#bf616a|#2e3440|#b48ead"
    [everforest-dark]="#a7c080|#2d353b|#7fbbb3|#475258|#2d353b|#3d484d|#e67e80|#2d353b|#d699b6"
    [everforest-light]="#8da101|#fffbef|#35a77c|#9da9a0|#fffbef|#e6e2d0|#f85552|#fffbef|#df69ba"
    [dracula]="#bd93f9|#282a36|#8be9fd|#44475a|#282a36|#6272a4|#ff5555|#282a36|#ff79c6"
    [solarized-dark]="#268bd2|#002b36|#2aa198|#073642|#002b36|#586e75|#dc322f|#002b36|#6c71c4"
    [solarized-light]="#268bd2|#fdf6e3|#2aa198|#93a1a1|#fdf6e3|#eee8d5|#dc322f|#fdf6e3|#6c71c4"
    [one-dark]="#61afef|#282c34|#56b6c2|#3e4451|#282c34|#4b5263|#e06c75|#282c34|#c678dd"
    [one-light]="#4078f2|#fafafa|#0184bc|#c8c8c8|#fafafa|#e5e5e5|#e45649|#fafafa|#a626a4"
    [kanagawa]="#7e9cd8|#1f1f28|#7fb4ca|#363646|#1f1f28|#2a2a37|#c34043|#1f1f28|#957fb8"
    [rose-pine]="#c4a7e7|#191724|#31748f|#26233a|#191724|#403d52|#eb6f92|#191724|#e46876"
    [rose-pine-moon]="#c4a7e7|#232136|#3e8fb0|#393552|#232136|#44415a|#eb6f92|#232136|#e46876"
    [rose-pine-dawn]="#907aa9|#faf4ed|#286983|#d7d0c8|#faf4ed|#f2e9de|#b4637a|#faf4ed|#907aa9"
    [monokai]="#a6e22e|#272822|#66d9e8|#3e3d32|#272822|#49483e|#f92672|#272822|#ae81ff"
    [material-dark]="#82aaff|#212121|#89ddff|#2d2d2d|#212121|#424242|#f07178|#212121|#c792ea"
    [material-ocean]="#82aaff|#0f111a|#89ddff|#1a1c25|#0f111a|#292d3e|#f07178|#0f111a|#c792ea"
    [palenight]="#82aaff|#292d3e|#89ddff|#3d3f51|#292d3e|#32374d|#f07178|#292d3e|#c792ea"
    [ayu-dark]="#59c2ff|#0a0e14|#95e6cb|#0d1017|#0a0e14|#1f2430|#ff3333|#0a0e14|#d2a6ff"
    [ayu-mirage]="#73d0ff|#1f2430|#95e6cb|#2d3343|#1f2430|#33415e|#f28779|#1f2430|#dfbfff"
    [ayu-light]="#55b4d4|#fafafa|#399ee6|#b8b8b8|#fafafa|#e7e7e7|#f07171|#fafafa|#a37acc"
    [oxocarbon]="#78a9ff|#161616|#33b1ff|#262626|#161616|#393939|#ff7eb6|#161616|#be95ff"
    [mellow]="#b3b9c5|#1e1e1e|#7ca1b1|#2d2d2d|#1e1e1e|#353535|#df5b61|#1e1e1e|#a988b0"
    [melange]="#d47766|#292522|#a3a9ce|#3d3835|#292522|#524945|#bd8183|#292522|#a3a9ce"
)


# if no argument, show rofi picker with color blocks
if [ -z "$1" ]; then
    declare -A LABELS=(
        [gruvbox-dark]="<span foreground='#282828'>█</span><span foreground='#ebdbb2'>█</span><span foreground='#458588'>█</span><span foreground='#83a598'>█</span><span foreground='#98971a'>█</span><span foreground='#d79921'>█</span><span foreground='#cc241d'>█</span><span foreground='#b16286'>█</span> gruvbox-dark"
        [gruvbox-light]="<span foreground='#fbf1c7'>█</span><span foreground='#3c3836'>█</span><span foreground='#458588'>█</span><span foreground='#83a598'>█</span><span foreground='#98971a'>█</span><span foreground='#d79921'>█</span><span foreground='#cc241d'>█</span><span foreground='#b16286'>█</span> gruvbox-light"
        [catppuccin-mocha]="<span foreground='#1e1e2e'>█</span><span foreground='#cdd6f4'>█</span><span foreground='#cba6f7'>█</span><span foreground='#89b4fa'>█</span><span foreground='#a6e3a1'>█</span><span foreground='#f9e2af'>█</span><span foreground='#f38ba8'>█</span><span foreground='#cba6f7'>█</span> catppuccin-mocha"
        [catppuccin-macchiato]="<span foreground='#24273a'>█</span><span foreground='#cad3f5'>█</span><span foreground='#c6a0f6'>█</span><span foreground='#8aadf4'>█</span><span foreground='#a6da95'>█</span><span foreground='#eed49f'>█</span><span foreground='#ed8796'>█</span><span foreground='#c6a0f6'>█</span> catppuccin-macchiato"
        [catppuccin-latte]="<span foreground='#eff1f5'>█</span><span foreground='#4c4f69'>█</span><span foreground='#8839ef'>█</span><span foreground='#1e66f5'>█</span><span foreground='#40a02b'>█</span><span foreground='#df8e1d'>█</span><span foreground='#d20f39'>█</span><span foreground='#8839ef'>█</span> catppuccin-latte"
        [tokyo-night]="<span foreground='#1a1b26'>█</span><span foreground='#c0caf5'>█</span><span foreground='#7aa2f7'>█</span><span foreground='#7dcfff'>█</span><span foreground='#9ece6a'>█</span><span foreground='#e0af68'>█</span><span foreground='#f7768e'>█</span><span foreground='#bb9af7'>█</span> tokyo-night"
        [tokyo-night-storm]="<span foreground='#24283b'>█</span><span foreground='#c0caf5'>█</span><span foreground='#7aa2f7'>█</span><span foreground='#7dcfff'>█</span><span foreground='#9ece6a'>█</span><span foreground='#e0af68'>█</span><span foreground='#f7768e'>█</span><span foreground='#bb9af7'>█</span> tokyo-night-storm"
        [tokyo-night-day]="<span foreground='#e1e2e7'>█</span><span foreground='#3760bf'>█</span><span foreground='#2e7de9'>█</span><span foreground='#007197'>█</span><span foreground='#587539'>█</span><span foreground='#8c6c3e'>█</span><span foreground='#f52a65'>█</span><span foreground='#9854f1'>█</span> tokyo-night-day"
        [nord]="<span foreground='#2e3440'>█</span><span foreground='#d8dee9'>█</span><span foreground='#81a1c1'>█</span><span foreground='#88c0d0'>█</span><span foreground='#a3be8c'>█</span><span foreground='#ebcb8b'>█</span><span foreground='#bf616a'>█</span><span foreground='#b48ead'>█</span> nord"
        [everforest-dark]="<span foreground='#2d353b'>█</span><span foreground='#d3c6aa'>█</span><span foreground='#a7c080'>█</span><span foreground='#7fbbb3'>█</span><span foreground='#83c092'>█</span><span foreground='#dbbc7f'>█</span><span foreground='#e67e80'>█</span><span foreground='#d699b6'>█</span> everforest-dark"
        [everforest-light]="<span foreground='#fffbef'>█</span><span foreground='#5c6a72'>█</span><span foreground='#8da101'>█</span><span foreground='#35a77c'>█</span><span foreground='#35a77c'>█</span><span foreground='#dfa000'>█</span><span foreground='#f85552'>█</span><span foreground='#df69ba'>█</span> everforest-light"
        [dracula]="<span foreground='#282a36'>█</span><span foreground='#f8f8f2'>█</span><span foreground='#bd93f9'>█</span><span foreground='#8be9fd'>█</span><span foreground='#50fa7b'>█</span><span foreground='#f1fa8c'>█</span><span foreground='#ff5555'>█</span><span foreground='#ff79c6'>█</span> dracula"
        [solarized-dark]="<span foreground='#002b36'>█</span><span foreground='#839496'>█</span><span foreground='#268bd2'>█</span><span foreground='#2aa198'>█</span><span foreground='#859900'>█</span><span foreground='#b58900'>█</span><span foreground='#dc322f'>█</span><span foreground='#6c71c4'>█</span> solarized-dark"
        [solarized-light]="<span foreground='#fdf6e3'>█</span><span foreground='#657b83'>█</span><span foreground='#268bd2'>█</span><span foreground='#2aa198'>█</span><span foreground='#859900'>█</span><span foreground='#b58900'>█</span><span foreground='#dc322f'>█</span><span foreground='#6c71c4'>█</span> solarized-light"
        [one-dark]="<span foreground='#282c34'>█</span><span foreground='#abb2bf'>█</span><span foreground='#61afef'>█</span><span foreground='#56b6c2'>█</span><span foreground='#98c379'>█</span><span foreground='#e5c07b'>█</span><span foreground='#e06c75'>█</span><span foreground='#c678dd'>█</span> one-dark"
        [one-light]="<span foreground='#fafafa'>█</span><span foreground='#383a42'>█</span><span foreground='#4078f2'>█</span><span foreground='#0184bc'>█</span><span foreground='#50a14f'>█</span><span foreground='#c18401'>█</span><span foreground='#e45649'>█</span><span foreground='#a626a4'>█</span> one-light"
        [kanagawa]="<span foreground='#1f1f28'>█</span><span foreground='#dcd7ba'>█</span><span foreground='#7e9cd8'>█</span><span foreground='#7fb4ca'>█</span><span foreground='#76946a'>█</span><span foreground='#c0a36e'>█</span><span foreground='#c34043'>█</span><span foreground='#957fb8'>█</span> kanagawa"
        [rose-pine]="<span foreground='#191724'>█</span><span foreground='#e0def4'>█</span><span foreground='#c4a7e7'>█</span><span foreground='#31748f'>█</span><span foreground='#9ccfd8'>█</span><span foreground='#f6c177'>█</span><span foreground='#eb6f92'>█</span><span foreground='#c4a7e7'>█</span> rose-pine"
        [rose-pine-moon]="<span foreground='#232136'>█</span><span foreground='#e0def4'>█</span><span foreground='#c4a7e7'>█</span><span foreground='#3e8fb0'>█</span><span foreground='#9ccfd8'>█</span><span foreground='#f6c177'>█</span><span foreground='#eb6f92'>█</span><span foreground='#c4a7e7'>█</span> rose-pine-moon"
        [rose-pine-dawn]="<span foreground='#faf4ed'>█</span><span foreground='#575279'>█</span><span foreground='#907aa9'>█</span><span foreground='#286983'>█</span><span foreground='#56949f'>█</span><span foreground='#ea9d34'>█</span><span foreground='#b4637a'>█</span><span foreground='#907aa9'>█</span> rose-pine-dawn"
        [monokai]="<span foreground='#272822'>█</span><span foreground='#f8f8f2'>█</span><span foreground='#66d9e8'>█</span><span foreground='#66d9e8'>█</span><span foreground='#a6e22e'>█</span><span foreground='#e6db74'>█</span><span foreground='#f92672'>█</span><span foreground='#ae81ff'>█</span> monokai"
        [material-dark]="<span foreground='#212121'>█</span><span foreground='#eeffff'>█</span><span foreground='#82aaff'>█</span><span foreground='#89ddff'>█</span><span foreground='#c3e88d'>█</span><span foreground='#ffcb6b'>█</span><span foreground='#f07178'>█</span><span foreground='#c792ea'>█</span> material-dark"
        [material-ocean]="<span foreground='#0f111a'>█</span><span foreground='#8f93a2'>█</span><span foreground='#82aaff'>█</span><span foreground='#89ddff'>█</span><span foreground='#c3e88d'>█</span><span foreground='#ffcb6b'>█</span><span foreground='#f07178'>█</span><span foreground='#c792ea'>█</span> material-ocean"
        [palenight]="<span foreground='#292d3e'>█</span><span foreground='#a6accd'>█</span><span foreground='#82aaff'>█</span><span foreground='#89ddff'>█</span><span foreground='#c3e88d'>█</span><span foreground='#ffcb6b'>█</span><span foreground='#f07178'>█</span><span foreground='#c792ea'>█</span> palenight"
        [ayu-dark]="<span foreground='#0a0e14'>█</span><span foreground='#b3b1ad'>█</span><span foreground='#59c2ff'>█</span><span foreground='#95e6cb'>█</span><span foreground='#c2d94c'>█</span><span foreground='#ffb454'>█</span><span foreground='#ff3333'>█</span><span foreground='#d2a6ff'>█</span> ayu-dark"
        [ayu-mirage]="<span foreground='#1f2430'>█</span><span foreground='#cbccc6'>█</span><span foreground='#73d0ff'>█</span><span foreground='#95e6cb'>█</span><span foreground='#d5ff80'>█</span><span foreground='#ffd173'>█</span><span foreground='#f28779'>█</span><span foreground='#dfbfff'>█</span> ayu-mirage"
        [ayu-light]="<span foreground='#fafafa'>█</span><span foreground='#5c6773'>█</span><span foreground='#55b4d4'>█</span><span foreground='#399ee6'>█</span><span foreground='#86b300'>█</span><span foreground='#f2ae49'>█</span><span foreground='#f07171'>█</span><span foreground='#a37acc'>█</span> ayu-light"
        [oxocarbon]="<span foreground='#161616'>█</span><span foreground='#f2f4f8'>█</span><span foreground='#78a9ff'>█</span><span foreground='#33b1ff'>█</span><span foreground='#42be65'>█</span><span foreground='#08bdba'>█</span><span foreground='#ff7eb6'>█</span><span foreground='#be95ff'>█</span> oxocarbon"
        [mellow]="<span foreground='#1e1e1e'>█</span><span foreground='#c9c7cd'>█</span><span foreground='#b3b9c5'>█</span><span foreground='#7ca1b1'>█</span><span foreground='#78997a'>█</span><span foreground='#e4b781'>█</span><span foreground='#df5b61'>█</span><span foreground='#a988b0'>█</span> mellow"
        [melange]="<span foreground='#292522'>█</span><span foreground='#ece1d7'>█</span><span foreground='#d47766'>█</span><span foreground='#a3a9ce'>█</span><span foreground='#85b695'>█</span><span foreground='#c9b99a'>█</span><span foreground='#bd8183'>█</span><span foreground='#a3a9ce'>█</span> melange"
    )

    SELECTED=$(for slug in $(printf '%s\n' "${!LABELS[@]}" | sort); do
        echo "${LABELS[$slug]}"
    done | rofi -dmenu -p " Theme" -i -markup-rows -theme-str 'listview { lines: 12; }')

    [ -z "$SELECTED" ] && exit 0
    SLUG="${SELECTED##* }"
else
    SLUG="$1"
fi

# validate
if [ -z "${THEMES[$SLUG]+_}" ]; then
    echo "Unknown theme: $SLUG"
    echo "Available themes:"
    printf '  %s\n' "${!THEMES[@]}" | sort
    exit 1
fi

IFS='|' read -r FOLDER_COLOR PAPIRUS GTK_THEME <<< "${THEMES[$SLUG]}"

echo "Applying theme: $SLUG"

# Write GTK3/4 settings directly — no daemon needed
mkdir -p "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
cat > "$HOME/.config/gtk-3.0/settings.ini" << CONF
[Settings]
gtk-icon-theme-name=$PAPIRUS
gtk-theme-name=$GTK_THEME
CONF

cat > "$HOME/.config/gtk-4.0/settings.ini" << CONF
[Settings]
gtk-icon-theme-name=$PAPIRUS
gtk-theme-name=$GTK_THEME
CONF

# Also set via gsettings for running apps (best effort)
gsettings set org.gnome.desktop.interface icon-theme "$PAPIRUS" 2>/dev/null || true
gsettings set org.gnome.desktop.interface gtk-theme "$GTK_THEME" 2>/dev/null || true

# GTK via Gradience — must run before gtk.css is touched
gradience-cli apply -p "$PRESET_DIR/$SLUG.json" --gtk both

# GTK right click menu border radius fix — append so Gradience colors are preserved
echo 'window.popup, menu, .menu, .context-menu { border-radius: 0; }' >> "$HOME/.config/gtk-3.0/gtk.css"

# Icons via Papirus
sudo papirus-folders -C "$FOLDER_COLOR" --theme "$PAPIRUS"

# Reload GTK theme for already-running apps without logging out
pkill -HUP xsettingsd 2>/dev/null || true

# Polybar
if [ -f "$POLYBAR_DIR/themes/$SLUG.ini" ]; then
    cp "$POLYBAR_DIR/themes/$SLUG.ini" "$POLYBAR_DIR/colors.ini"
    polybar-msg cmd restart 2>/dev/null || true
else
    echo "Warning: no polybar theme found at $POLYBAR_DIR/themes/$SLUG.ini"
fi

# i3 reload
i3-msg reload 2>/dev/null || true

# Rofi
if [ -f "$ROFI_THEMES/$SLUG.rasi" ]; then
    cp "$ROFI_THEMES/$SLUG.rasi" "$HOME/.config/rofi/themes/current.rasi"
else
    echo "Warning: no rofi theme at $ROFI_THEMES/$SLUG.rasi"
fi

# Alacritty
if [ -f "$ALACRITTY_THEMES/$SLUG.toml" ]; then
    cp "$ALACRITTY_THEMES/$SLUG.toml" "$HOME/.config/alacritty/themes/current.toml"
else
    echo "Warning: no alacritty theme at $ALACRITTY_THEMES/$SLUG.toml"
fi

# xob
XOB_CONFIG_DIR="$HOME/.config/xob"
mkdir -p "$XOB_CONFIG_DIR"
if [ -n "${XOB_COLORS[$SLUG]+_}" ]; then
    IFS='|' read -r N_FG N_BG N_BORDER A_FG A_BG A_BORDER O_FG O_BG O_BORDER <<< "${XOB_COLORS[$SLUG]}"
    cat > "$XOB_CONFIG_DIR/styles.cfg" << XOBCONF
default = {
    padding   = 0;
    border    = 1;
    outline   = 0;
    thickness = 24;
    color = {
        normal = {
            fg = "$N_FG";
            bg = "$N_BG";
            border = "$N_BORDER";
        };
        alt = {
            fg = "$A_FG";
            bg = "$A_BG";
            border = "$A_BORDER";
        };
        overflow = {
            fg = "$O_FG";
            bg = "$O_BG";
            border = "$O_BORDER";
        };
        altoverflow = {
            fg = "$O_FG";
            bg = "$O_BG";
            border = "$A_BORDER";
        };
    };
};
XOBCONF
    echo "xob config written for: $SLUG"
else
    echo "Warning: no xob colors defined for $SLUG, styles.cfg unchanged"
fi

# persist
echo "$SLUG" > "$CURRENT_FILE"

# Wallpaper
bash "$SCRIPT_DIR/wallpaper-random.sh"

echo "Done: $SLUG"
