#!/bin/bash

line_number=55

echo "Name of the Disk, where you want to install Linux:"
read disk
echo "What would you like to name your Device:"
read device
echo "Username:"
read user
echo "Timezone: (e.g. Europe/Berlin; for more information, refer to 3.3 Time on archlinux.org/title/installation_guide)"
read timezone
echo "Preferred Keyboard Layout: (e.g. de-latin1 for German; for more information, refer to 1.5 Set the console keyboard layout and font on archlinux.org/title/installation_guide)"
read layout

echo -e "g\nn\n\n\n+1G\n\nt\n\n44\n\nn\n\n\n+1M\n\nn\n\n\n+16G\n\nt\n\n19\n\nn\n\n\n\n\n\nw" | fdisk /dev/${disk}

mkfs.fat -F32 /dev/${disk}1
cryptsetup luksFormat /dev/${disk}4
# enter password
cryptsetup open --type luks /dev/${disk}4 lvm
# enter password
pvcreate /dev/mapper/lvm
vgcreate ${device} /dev/mapper/lvm
lvcreate -L 214.5GB ${device} -n lv_root
lvcreate -L 700GB ${device} -n lv_home
modprobe dm_mod
vgscan
vgchange -ay

mkfs.ext4 /dev/${device}/lv_root
mkfs.ext4 /dev/${device}/lv_home
mkswap /dev/${disk}3
mount /dev/${device}/lv_root /mnt
mkdir /mnt/boot
mount /dev/${disk}1 /mnt/boot
mkdir /mnt/home
mount /dev/${device}/lv_home /mnt/home
swapon /dev/${disk}3
pacstrap -i /mnt base
genfstab -U -p /mnt >> /mnt/etc/fstab
arch-chroot /mnt

ln -sf /usr/share/zoneinfo/${timezone} /etc/localtime
hwclock --systohc
passwd
useradd -m -g users -G wheel ${user}
passwd ${user}

pacman -S base-devel git dosfstools grub efibootmgr lvm2 mtools neovim libpulse networkmanager sudo ly
pacman -S linux linux-headers linux-lts linux-lts-headers
pacman -S linux-firmware
pacman -S mesa libva-mesa-driver intel-media-driver

sed -i '/en_US.UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=${layout}" > /etc/vconsole.conf
echo "${device}" > /etc/hostname

sed -i "${line_number}d" /etc/mkinitcpio.conf
sed -i "${line_number}i\HOOKS=(base udev block keyboard autodetect microcode modconf kms keymap consolefont encrypt lvm2 filesystems fsck)" /etc/mkinitcpio.conf

mkinitcpio -p linux
mkinitcpio -p linux-lts

sed -i "6d" /etc/default/grub
sed -i "6i\GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 cryptdevice=/dev/${disk}4:${device} quiet\"" /etc/default/grub

grub-install --target=x86_64-efi --bootloader-id=${device} --efi-directory=/boot --recheck
grub-install --target=i386-pc /dev/${disk}
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
grub-mkconfig -o /boot/grub/grub.cfg
systemctl enable NetworkManager
systemctl enable ly.service

sed -i '/%wheel ALL=(ALL:ALL) ALL/s/^#//g' /etc/sudoers
sed -i '/Color/s/^#//g' /etc/pacman.conf
sed -i '/ParallelDownloads = 5/s/^#//g' /etc/pacman.conf
sed -i "38i\ILoveCandy" /etc/pacman.conf

su ${user}
cd
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si
cd
sudo rm -rf yay/
pacman -S pipewire wireplumber pipewire-audio pipewire-alsa hyprland btop inkscape krita libreoffice obsidian rofi-wayland zsh wezterm
systemctl --user enable pipewire
chsh -s /usr/bin/zsh
yay -S hyprpaper zen-browser-bin superfile zip unzip ttf-jetbrains-mono-nerd omm jetbrains-toolbox
exit
exit
umount -a
swapoff -a
reboot
