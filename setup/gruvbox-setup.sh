#!/usr/bin/env bash

sudo pacman -S --needed flatpak

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    echo "yay not found, running yay-setup.sh..."
    ./yay-setup.sh
fi



# Gruvbox icons
yay -S gruvbox-plus-icon-theme-git

# Gruvbox gtk theme
yay -S gtk-theme-murrine
git clone https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme.git
./Gruvbox-GTK-Theme/themes/install.sh

# Fix flatpak apps to pick gtk themes
sudo flatpak override --filesystem=$HOME/.themes
sudo flatpak override --filesystem=$HOME/.icons
flatpak override --user --filesystem=xdg-config/gtk-4.0
sudo flatpak override --filesystem=xdg-config/gtk-4.0
