#!/bin/bash

# DEVICE=/dev/sda
# PARTITION_ROOT=/dev/sda3
# PARTITION_BOOT=/dev/sda1

# Dowload part 2 script

curl -o arch-install2.sh https://raw.githubusercontent.com/willbernascimento/archlinux/master/arch-install2.sh

# reflector

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
