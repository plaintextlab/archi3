#!/usr/bin/env bash

#------------------- Refresh mirrors first -----------------

sudo pacman -Sy
sudo pacman -S --needed reflector
sudo reflector --latest 20 --sort rate --protocol https --save /etc/pacman.d/mirrorlist

#------------------- Install packages ----------------------
# Native packages
sudo pacman -S --needed xorg-server xorg-xinit xorg-xkill xorg-xset
sudo pacman -S --needed redshift numlockx ddcutil base-devel flatpak
sudo pacman -S --needed dkms libva-nvidia-driver nvidia-open-dkms linux-headers linux-zen-headers nvidia-utils lib32-nvidia-utils nvidia-settings opencl-nvidia vulkan-icd-loader lib32-vulkan-icd-loader
sudo pacman -S --needed i3-wm alacritty feh eza yazi mpv mpc mpd dunst udiskie rofi polybar nemo stow starship fastfetch

# Flatpak packages


# ------------------- Yay ----------------------------------
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si


# ------------------ Gruvbox theme -------------------------
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

#------------------- Link dotfiles -------------------------

stow  alacritty
stow bashrc
stow dunst
stow i3
stow mpd
stow mpv
stow nemo
stow picom
stow polybar
stow rofi
stow scripts
stow starship
stow wallpapers

# ------------------- Fixes --------------------------------
# Fix nemo right click open terminal to alacritty

gsettings set org.cinnamon.desktop.default-applications.terminal exec 'alacritty'
gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg '-e'

# git setup
git config --global user.name "Bitangsha Ray"
git config --global user.email "plaintextlab@gmail.com"
git config --global credential.helper store


