#!/bin/bash

### ---------------  CONFIGURAçÕES DE SISTEMA ----------------

echo "Neste momento, vamos configurar: time zone, language, keymap, hostname and hosts"
echo " "

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
echo " "

echo ${HOST_NAME} >> /etc/hostname

# Matching entries

echo "127.0.0.1	localhost 
::1		localhost
127.0.1.1	${HOST_NAME}.localdomain	${HOST_NAME}" >> /etc/hosts
echo " "

echo "Neste momento vamos configurar o bootloader"


SYSTEM_PACKAGES="grub dosfstools efibootmgr os-prober sudo intel-ucode libva-intel-driver networkmanager dhcp dhcpcd"

# grub, firmware, sudo
pacman -S ${SYSTEM_PACKAGES}

# initramfs

mkinitcpio -p linux


read -p "Você precisa escolher qual bootloader usar: (1) grub (bios/uefi) ou (2) systemd-boot (uefi). " BOOTLOADER

# bootloader
# GRUB BIOS

GRUB_GENERATE="grub-mkconfig -o /boot/grub/grub.cfg"

if [ $BOOTLOADER == 1 ]

then
	read -p "Escolha o tipo de Boot: 1) UEFI 2) BIOS/MBR: " BOOT_OPTION

	if [ $BOOT_OPTION == 2 ]
	then
		 read -p "Indique o dispositivo (/dev/sdX): " BOOT_DEVICE
		 echo " "
		 echo "Installing in BIOS/MBR mode, on the $BOOT_DEVICE device."
        	 echo " "
        	 grub-install ${BOOT_DEVICE}
        	 ${GRUB_GENERATE}
	else
		 read -p "Indique o ponto de montagem do boot (ESP) (/dev/sdxX): " BOOT_DEVICE
        	 echo " "
        	 echo "Installing in UEFI mode, on the $BOOT_DEVICE partition."
        	 echo " "
        	 grub-install --target=x86_64-efi --efi-directory=${BOOT_DEVICE} --bootloader-id=GRUB
        	 ${GRUB_GENERATE}

	fi

else
	read -p "Indique o ponto de montagem do boot (ESP): " BOOT_DEVICE
	read -p "Indique a partição root (ex: /dev/sdaX): " ROOT_DEVICE

	bootctl --path=$BOOT_DEVICE install


	echo "default  arch.conf \ntimeout  4 \nconsole-mode max \neditor   no " >> ${BOOT_DEVICE}/loader/loader.conf

	echo \
	"title   Arch Linux	
linux   /vmlinuz-linux	
initrd  /intel-ucode.img	
initrd  /initramfs-linux.img	
options root=$ROOT_DEVICE rw" \
	>> ${BOOT_DEVICE}/loader/entries/arch.conf
fi


### ---------------  CONFIGURAçÕES DE USUÁRIOS ----------------

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

echo " Setting sudo power for the $USER_NAME user. "

# sudo power
sed -i -e "s/# %wheel ALL=(ALL) ALL$/%wheel ALL=(ALL) ALL/" /etc/sudoers

echo " "
echo "========= Ativando serviços do systemd ========="


### ---------------  CONFIGURAçÕES DE SERVIÇOS ----------------

echo "Enable network and TRIM (SSD) services"

# enable systemd services 

echo " "

SYSTEM_SERVICES="NetworkManager dhcpcd"

for i in $SYSTEM_SERVICES; do
    systemctl enable "${i}.service"
done

systemctl enable fstrim.timer

echo "basic installation completed. You can reboot now."
echo "downloading post install scripts"

cd /home/${USER_NAME}

curl -o arch-post-install-pacman.sh	
curl -o arch-post-install-yay-conf.sh
curl -o arch-post-install-yay-packages.sh
