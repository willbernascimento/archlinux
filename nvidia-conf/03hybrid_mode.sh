#!/bin/bash

# configura o prime offload

pacman -S nvidia nvidia-prime nvidia-settings nvidia-utils

cp 10-prime-render-offload.conf /etc/X11/xorg.conf.d/10-prime-render-offload.conf


#mv /etc/X11/xorg.conf.d/10-prime-render-offload.conf.bac /etc/X11/xorg.conf.d/10-prime-#render-offload.conf

#mv /etc/modprobe.d/nvidia-drm.conf.bac /etc/modprobe.d/nvidia-drm.conf

# remove o nvidia-only

#mv  /etc/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf /etc/X11/xorg.conf.d/10-nvidia-drm-#outputclass.conf.bac

# Configura o GDM: remove o arquivo padrao e desabilita o wayland

cp /etc/gdm/custom.conf /etc/gdm/custom.conf.before.prime
rm /etc/gdm/custom.conf
mv custom.conf /etc/gdm/custom.conf

#rm /usr/share/gdm/greeter/autostart/optimus.desktop
#rm /etc/xdg/autostart/optimus.desktop

# xinit

cp $HOME/.xinitrc $HOME/.xinitrc.before.prime
rm $HOME/.xinitrc

mkinitcpio -p linux
mkinitcpio -p linux-ck
