#!/bin/bash

echo "Preferred Disk:"
read disk
echo "Preferred Hostname:"
read device
echo "Username:"
read user
echo "Timezone: (e.g. Europe/Berlin; for more information, refer to 3.3 Time on archlinux.org/title/installation_guide)"
read timezone
echo "Preferred Keyboard Layout: (e.g. de-latin1 for German; for more information, refer to 1.5 Set the console keyboard layout and font on archlinux.org/title/installation_guide)"
read layout

ln -sf /usr/share/zoneinfo/"${timezone}" /etc/localtime
hwclock --systohc
passwd
useradd -m -g users -G wheel "${user}"
passwd "${user}"

pacman -S base-devel git dosfstools grub efibootmgr lvm2 mtools neovim libpulse networkmanager sudo ly
pacman -S linux linux-headers linux-lts linux-lts-headers
pacman -S linux-firmware
pacman -S --needed mesa libva-mesa-driver intel-media-driver

sed -i '/en_US.UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=${layout}" > /etc/vconsole.conf
echo "${device}" > /etc/hostname

sed -i "55d" /etc/mkinitcpio.conf
sed -i "55i\HOOKS=(base udev block keyboard autodetect microcode modconf kms keymap consolefont encrypt lvm2 filesystems fsck)" /etc/mkinitcpio.conf

mkinitcpio -p linux
mkinitcpio -p linux-lts

sed -i "6d" /etc/default/grub
sed -i "6i\GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 cryptdevice=/dev/${disk}4:${device} quiet\"" /etc/default/grub

grub-install --target=x86_64-efi --bootloader-id="${device}" --efi-directory=/boot --recheck
grub-install --target=i386-pc /dev/nvme0n1
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
systemctl enable ly.service

sed -i '/%wheel ALL=(ALL:ALL) ALL/s/^#//g' /etc/sudoers
sed -i '/Color/s/^#//g' /etc/pacman.conf
sed -i '/ParallelDownloads = 5/s/^#//g' /etc/pacman.conf
sed -i "38i\ILoveCandy" /etc/pacman.conf

echo "$(curl https://raw.githubusercontent.com/1u5t1n14n/.dotfiles/main/.install-usr.sh)" > /home/"${user}"/.install.sh
chmod +x /home/"${user}"/.install.sh
sudo -H -u "${user}" bash -c './home/"${user}"/.install.sh'
