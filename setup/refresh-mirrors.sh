#!/usr/bin/env bash

sudo pacman -Sy
sudo pacman -S --needed reflector
sudo reflector --latest 20 --sort rate --protocol https --save /etc/pacman.d/mirrorlist
