#!/bin/bash

DESKTOP="gnome gnome-tweaks gnome-software-packagekit-plugin gnome-passwordsafe git neofetch rsync lollypop ttf-fira-sans ttf-fira-mono libreoffice-fresh-pt-br"

TERM_CONF="zsh zsh-autosuggestions zsh-completions vim zsh-syntax-highlighting zsh-history-substring-search zsh-theme-powerlevel10k"

PROGRAMMING="r gnome-builder gnome-latex texlive-core texlive-latexextra"

INTERNET="firefox firefox-i18n-pt-br telegram-desktop"


# Install desktop and enable services

pacman -Syu $DESKTOP

SYSTEMD_SERVICES="gdm"

for i in $SYSTEMD_SERVICES; do
    systemctl enable "${i}"
done

# Install other pacman packages

pacman -Syu $INTERNET $PROGRAMMING $TERM_CONF



