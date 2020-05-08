#!/bin/bash

DESKTOP="gnome gnome-tweaks git"

TERM_CONF="zsh zsh-autosuggestions zsh-completions vim zsh-syntax-highlighting zsh-history-substring-search zsh-theme-powerlevel10k"

PROGRAMMING="r gnome-builder gnome-latex texlive-core texlive-latexextra"

INTERNET="firefox firefox-i18n-pt-br telegram-desktop"


# Install desktop and enable services

pacman -Syu $DESKTOP

$SYSTEMD_SERVICES="gdm"

for i in $SYSTEMD_SERVICES; do
    systemctl enable "${i}.service"
done

# Install other pacman packages

pacman -Syu $PROGRAMING $INTERNET $PROGRAMMING

# Enable AUR with YAY
#git clone https://aur.archlinux.org/yay.git
#cd yay/
#makepkg -s --noconfirm --install





