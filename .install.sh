#!/bin/bash

echo "Preferred Disk:"
read disk
echo "Preferred Hostname:"
read device
echo "Size of root-Partition (in GB):"
read root
echo "Size of home-Partition (in GB):"
read home

sfdisk /dev/sdX <<EOF # dis nicht funktionieren
label: gpt
size=1G, type=uefi
size=1M, type=bios
size=16G, type=linux-swap
size=0, type=lvm
EOF

mkfs.fat -F32 /dev/"${disk}"1
cryptsetup luksFormat /dev/"${disk}"4
# enter password
cryptsetup open --type luks /dev/"${disk}"4 lvm
# enter password
pvcreate /dev/mapper/lvm
vgcreate "${device}" /dev/mapper/lvm
lvcreate -L "${root}"GB "${device}" -n lv_root
lvcreate -L "${home}"GB "${device}" -n lv_home
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
echo "curl https://raw.githubusercontent.com/1u5t1n14n/.dotfiles/main/.install-root.sh to a File"
echo "chmod +x .install.sh"
echo "./.install.sh"
arch-chroot /mnt
