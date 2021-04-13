#!/bin/bash

DESKTOP="gnome-pomodoro-git pop-gtk-theme-git pop-icon-theme-git ttf-roboto-slab firefox-extension-gsconnect gnome-shell-extension-gsconnect"
INTERNET="skypeforlinux-stable-bin"
#PROGRAMMING="rstudio-desktop-bin"

yay -S --nocleanmenu --nodiffmenu $DESKTOP $INTERNET
