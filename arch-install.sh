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

pacstrap /mnt base linux linux-firmware vim

cp arch-install2.sh /mnt/arch-install2.sh
chmod +x /mnt/arch-install2.sh

echo " "
echo "=======  genfstab ========"
echo " "

# fstab - paticoes

genfstab -U /mnt >> /mnt/etc/fstab

# chroot

echo " "
echo "======= Fazendo CHROOT ======\n"
echo " "

arch-chroot /mnt ./arch-install2.sh

echo " "