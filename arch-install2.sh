#!/bin/bash

# Time and zone configuration

echo "======= Ajustando Tempo ========"
echo " "

ln -s /usr/share/zoneinfo/America/Maceio /etc/localtime

# set the hour 

echo " "
echo "====== Ajustando hora no hardware ======"
echo " "

hwclock --systohc

# Set language conf

echo " "
echo "======= Configurando a linguagem do sistema ======"
echo " "

USER_LANGUAGE="pt_BR.UTF-8"

# descomentar linguagens

sed -i "s/#${USER_LANGUAGE}/${USER_LANGUAGE}/" /etc/locale.gen

# gerar linguagem

locale-gen
export LANG=pt_BR.UTF-8

# configurar a variável LANG

echo "LANG=${USER_LANGUAGE}" >> /etc/locale.conf

# configurar KEYMAP do teclado

USER_KEYMAP="br-abnt2"

echo "KEYMAP=${USER_KEYMAP}" >> /etc/vconsole.conf

# Set hostname 

echo " "
echo "====== Configurando Hostname e hosts ======"
echo " "
read -p "Nome do seu computador na rede: " HOST_NAME
echo

echo ${HOST_NAME} >> /etc/hostname

# Matching entries

echo "127.0.0.1	localhost 
::1		localhost
127.0.1.1	${HOST_NAME}.localdomain	${HOST_NAME}" >> /etc/hosts

SYSTEM_PACKAGES="grub dosfstools efibootmgr os-prober sudo intel-ucode networkmanager dhcp dhcpcd"

# grub, firmware, sudo
pacman -S ${SYSTEM_PACKAGES}

# initramfs

mkinitcpio -p linux

# bootloader
# GRUB BIOS

echo "====== Install bootloader ======="

read -p "Escolha o tipo de Boot: 1) UEFI 2) BIOS/MBR: " BOOT_OPTION
read -p "Indique o nome do seu dispositivo ou partição de Boot no caso de UEFI: " BOOT_DEVICE

GRUB_GENERATE="grub-mkconfig -o /boot/grub/grub.cfg"

if [ ${BOOT_OPTION} -eq 1 ]
then
        echo " "
        echo "Estou instalando em UEFI"
        echo " "
        grub-install --target=x86_64-efi --efi-directory=${BOOT_DEVICE} --bootloader-id=GRUB
        GRUB_GENERATE
else
        echo " "
        echo "Estou instalando em BIOS/MBR"
        echo " "
        grub-install ${BOOT_DEVICE}
        ${GRUB_GENERATE}

fi

echo " "
echo "======== Configurações de acesso, usuário e permissões ======="
echo " "

# root password

echo " "
echo "======= Iserir sua senha de root. ====="
echo " "

passwd

echo " "


# user account
echo " "
read -p "Nome de usuário: " USER_NAME
echo " "

useradd -m -G wheel,power,network -s /bin/bash ${USER_NAME}

echo " "
echo "====== Inserir sua senha de usuário ======="
passwd ${USER_NAME}
echo " "

# sudo power
sed -i -e "s/# %wheel ALL=(ALL) ALL$/%wheel ALL=(ALL) ALL/" /etc/sudoers

echo " "
echo "========= Ativando serviços do systemd ========="

# enable systemd services 

echo " "

SYSTEM_SERVICES="NetworkManager dhcpcd"

for i in SYSTEM_SERVICES; do
    systemctl enable "${i}.service"
done

systemctl enable fstrim.timer
