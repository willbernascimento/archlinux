#!/bin/bash

GNOME_EXTENSIONS="gnome-pomodoro-git firefox-extension-gsconnect gnome-shell-extension-gsconnect" 
THEMES_SHELL="pop-gtk-theme-git pop-icon-theme-git ttf-roboto-slab"
INTERNET="skypeforlinux-stable-bin zoom phantomjs google-chrome-beta chrome-gnome-shell"
PROGRAMMING="rstudio-desktop-bin visual-studio-code-bin"
SYSTEM="aic94xx-firmware wd719x-firmware upd72020x-fw udunits touchegg tesseract tesseract-data-por soci hunspell-pt-br"

yay -S --nocleanmenu --nodiffmenu $SYSTEM $INTERNET $PROGRAMMING
