#!/bin/bash

# DEVICE=/dev/sda
# PARTITION_ROOT=/dev/sda3
# PARTITION_BOOT=/dev/sda1

# Dowload part 2 script

echo "Download script install files"

curl -o arch-install2.sh https://raw.githubusercontent.com/willbernascimento/archlinux/master/arch-install2.sh


# mirrorlist [download a local mirrorlist]

echo "Editing mirrolist file"

mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

COUNTRY_CODE="BR"
curl -o /etc/pacman.d/mirrorlist https://www.archlinux.org/mirrorlist/?country=${COUNTRY_CODE}&protocol=http&protocol=https&ip_version=4
sed -i-${COUNTRY_CODE}.bak '/Server/s/^#//g' mirrorlist


# optinal [reflector]

#echo "we will use the reflect package to select the fastest mirrors at this point.\
# It is possible that these mirrors will not be the fastest in the future, so we recommend \
# that you check this mirrorlist sometime after installation."

#mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

#pacman -Syu reflector

#reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist



echo " "
echo "=======  pacstrap ========"
echo " "

# pacstrap

PACSTRAP_PKG="base base-devel linux linux-firmware vim"


echo "Além dos pacotes: $PACSTRAP_PKG"
read -p "Você gostaria de adicionar mais pacotes? (1) Sim e (2) Não. " PCSTRAP_TEST

if [ $PCSTRAP_TEST -eq 2 ]
then
	pacstrap /mnt $PACSTRAP_PKG
else 
	read -p "Pacotes: " PACSTRAP_PKG_USR
	pacstrap /mnt $PACSTRAP_PKG $PACSTRAP_PKG_USR
fi

# copy the installer2 for into chroot

cp arch-install2.sh /mnt/arch-install2.sh
chmod +x /mnt/arch-install2.sh

echo " "
echo "=======  genfstab ========"
echo " "

# fstab - creating the table os partitions

genfstab -U /mnt >> /mnt/etc/fstab

# chroot - into to the new enviroment 

echo " "
echo "======= Fazendo CHROOT ======\n"
echo " "


# run installer2 on chroot

arch-chroot /mnt ./arch-install2.sh

echo " "
