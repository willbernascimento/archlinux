# Arch Linux Configuration Files

Scripts, files and commands for **my** Arch Linux configuration.


# Purpose

To group several configuration files for my setup and an Arch Linux personal installation automation script. I used internet sources mainly [Arch Wiki](https://wiki.archlinux.org/) and [StackOverflow](https://stackoverflow.com/). Whenever I can remember I indicate the source of consultation.

# Devices Configuration Files

## Disable laptop touchscreen

- 80-touchscreen.rules and 99-no-touchscreen.conf

The first work on Wayland session and the last on X.Org session.

## Enable multiple touchpad buttons

- 50-synaptics.conf

Configures severals touchpad buttons using Synaptics driver. 

**Note:** The [Synaptics](https://wiki.archlinux.org/index.php/Touchpad_Synaptics) is not often updated, you should use [libinput](https://wiki.archlinux.org/index.php/Libinput) instead.

## Keyboard Configuration

- 00-keyboard.conf

Set the keyboard layout to Brazilian ABNT2 pattern on X.Org session.

**Note:** You should to try this command first:

```
# localectl set-x11-keymap br abnt2 
```

## Multimedia fn Keys on i3wm

- i3wm

Most used fn multimedia keys on i3 Window Manager.


## Arch Linux install script

- arch-install.sh (** IN DEVELOPMENT **)

# DISCLAIMER

This software is not warranted of any kind. Use at your own risk.
