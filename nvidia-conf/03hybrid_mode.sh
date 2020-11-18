#!/bin/bash

# restaura o prime offload

mv /etc/X11/xorg.conf.d/10-prime-render-offload.conf.bac /etc/X11/xorg.conf.d/10-prime-render-offload.conf

mv /etc/modprobe.d/nvidia-drm.conf.bac /etc/modprobe.d/nvidia-drm.conf

# remove o nvidia-only

mv  /etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf /etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf.bac

# Configura o GDM 

rm /etc/gdm/custom.conf
mv /etc/gdm/custom.conf.bac /etc/gdm/custom.conf

rm /usr/share/gdm/greeter/autostart/optimus.desktop
rm /etc/xdg/autostart/optimus.desktop

# xinit

rm $HOME/.xinitrc

mkinitcpio -p linux
