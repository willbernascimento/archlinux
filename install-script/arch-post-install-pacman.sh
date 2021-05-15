#!/bin/bash

DESKTOP="gnome gnome-tweaks gnome-software-packagekit-plugin gnome-passwordsafe geary fragments git neofetch rsync lollypop ttf-dejavu  ttf-fira-sans ttf-fira-mono libreoffice-fresh-pt-br vlc obs-studio"

TERM_CONF="bash-completion zsh zsh-autosuggestions zsh-completions zsh-syntax-highlighting zsh-history-substring-search zsh-theme-powerlevel10k"

PROGRAMMING="r gnome-builder gnome-latex texlive-core texlive-latexextra texlive-publishers texlive-bibtexextra biber texlive-fontsextra"

INTERNET="firefox firefox-i18n-pt-br telegram-desktop youtube-dl"

SYSTEM="v4l2loopback-dkms mesa-demos libva-intel-driver libva-utils ffmpegthumbs blueman bluez bluez-utils android-file-transfer android-tools android-udev acpi_call acpi_call-dkms smartmontools gdal gcc-fortran"


# Install desktop and enable services

pacman -Syu $DESKTOP

SYSTEMD_SERVICES="gdm bluetooth smartd"

for i in $SYSTEMD_SERVICES; do
    systemctl enable "${i}"
done

# Install other pacman packages

pacman -Syu $INTERNET $PROGRAMMING $TERM_CONF $SYSTEM
