## ------------------------------------------------------------------------- ##
## This script download, build and install yay on Arch Linux.
## 


# Enable AUR with YAY

mkdir -p build-pkgs && cd build-pkgs

git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -s --noconfirm --install



