#!/bin/bash


# Pacotes necessários
# pacman -s xorg-xrandr

# copiando nvidia conf

FILE=/etc/X11/xorg.conf.d/10-prime-render-offload.conf

if [ -f "$FILE" ]; then
	mv /etc/X11/xorg.conf.d/10-prime-render-offload.conf /etc/X11/xorg.conf.d/10-prime-render-offload.conf.bac
fi

cp /etc/modprobe.d/nvidia-drm.conf /etc/modprobe.d/nvidia-drm.conf.bac

cp ./10-nvidia-drm-outputclass.conf /etc/X11/xorg.conf.d/


# Copiando GDM .desktop

mv /etc/gdm/custom.conf /etc/gdm/custom.conf.bac
cp ./custom.conf /etc/gdm/

cp ./optimus.desktop /usr/share/gdm/greeter/autostart/
cp ./optimus.desktop /etc/xdg/autostart/


# copiando xinit


FILE=$HOME/.xinitrc
if [ -f "$FILE" ]; then
    mv $HOME/.xinitrc $HOME/.xinitrc.bac
fi

cp ./xinitrc $HOME/.xinitrc

# gerando novo mkinit

mkinitcpio -p linux


FILE=/etc/X11/xorg.conf.d/10-prime-render-offload.conf
if [ -f "$FILE" ]; then
	echo "$FILE exists."
fi
