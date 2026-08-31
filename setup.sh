#!/usr/bin/env bash

#------------------- Refresh mirrors first -----------------
~/archi3//setup/refresh-mirrors.sh


#------------------- Install packages ----------------------
# Native packages
sudo pacman -S --needed xorg-server xorg-xinit xorg-xkill xorg-xset
sudo pacman -S --needed redshift numlockx ddcutil base-devel flatpak brightnessctl
sudo pacman -S --needed dkms libva-nvidia-driver nvidia-open-dkms linux-headers linux-zen-headers nvidia-utils lib32-nvidia-utils nvidia-settings opencl-nvidia vulkan-icd-loader lib32-vulkan-icd-loader
sudo pacman -S --needed i3-wm kitty feh eza yazi mpv mpc mpd dunst udiskie rofi polybar nemo stow starship fastfetch picom lxappearance playerctl
sudo pacman -S --needed lutris steam firefox mousepad

# Flatpak packages
flatpak install -y com.vysp3r.ProtonPlus
flatpak install -y com.google.Chrome
flatpak install -y com.heroicgameslauncher.hgl
flatpak install -y org.videolan.VLC
flatpak install -y org.gimp.GIMP
flatpak install -y org.kde.kdenlive

# Create user directories
xdg-user-dirs-update


# ------------------- Yay ----------------------------------
~/archi3/setup/yay-setup.sh

# ------------------ Gruvbox theme -------------------------
~/archi3/setup/gruvbox-setup.sh


#------------------- Fonts ---------------------------------
sudo pacman -S --needed ttf-jetbrains-mono ttf-jetbrains-mono-nerd
fc-cache -fv

#------------------- Link dotfiles -------------------------

~/archi3/setup/dotfiles-setup.sh

# ------------------- Fixes --------------------------------
# Fix nemo right click open terminal to kitty

gsettings set org.cinnamon.desktop.default-applications.terminal exec 'kitty'
gsettings set org.cinnamon.desktop.default-applications.terminal exec-arg '-e'

# git setup
~/archi3/setup/git-setup.sh


# touchpad tap to click
sudo ~/archi3/setup/touchpad-setup.sh --persistent


