#!/bin/bash

echo "Preferred Disk:"
read disk
echo "Preferred Hostname:"
read device
echo "Username:"
read user

# fdisk

mkfs.fat -F32 /dev/"${disk}"1
cryptsetup luksFormat /dev/"${disk}"4
# enter password
cryptsetup open --type luks /dev/"${disk}"4 lvm
# enter password
pvcreate /dev/mapper/lvm
vgcreate "${device}" /dev/mapper/lvm
lvcreate -L 214.5GB "${device}" -n lv_root
lvcreate -L 700GB "${device}" -n lv_home
modprobe dm_mod
vgscan
vgchange -ay

mkfs.ext4 /dev/"${device}"/lv_root
mkfs.ext4 /dev/"${device}"/lv_home
mkswap /dev/"${disk}"3
mount /dev/"${device}"/lv_root /mnt
mkdir /mnt/boot
mount /dev/"${disk}"1 /mnt/boot
mkdir /mnt/home
mount /dev/"${device}"/lv_home /mnt/home
swapon /dev/"${disk}"3
pacstrap -i /mnt base
genfstab -U -p /mnt >> /mnt/etc/fstab

echo "do the following:"
echo "echo '$(curl https://raw.githubusercontent.com/1u5t1n14n/.dotfiles/main/.install-II.sh)' > .install-II.sh"
echo "chmod +x .install-II.sh"
echo "./.install-II.sh"
arch-chroot /mnt
