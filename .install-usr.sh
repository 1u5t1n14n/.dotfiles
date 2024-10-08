#!/bin/bash

cd
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si
cd
sudo rm -rf yay/
sudo pacman -S pipewire wireplumber pipewire-audio pipewire-alsa hyprland btop inkscape krita libreoffice obsidian rofi-wayland zsh wezterm
systemctl --user enable pipewire
chsh -s /usr/bin/zsh
yay -S hyprpaper zen-browser-bin superfile zip unzip ttf-jetbrains-mono-nerd omm display-link jetbrains-toolbox
sudo system TL enable display-link.service
sudo rm -rf ~/*
sudo rm -rf ~/.* 2> /dev/null
git clone https://github.com/1u5t1n14n/.dotfiles ~/
echo "do the following:"
echo "exit"
echo "umount -a"
echo "swapoff -a"
echo "reboot"
exit
