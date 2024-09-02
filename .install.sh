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

# echo -e "g\nn\n\n\n+1G\n\nt\n\n44\n\nn\n\n\n+1M\n\nn\n\n\n+16G\n\nt\n\n19\n\nn\n\n\n\n\n\nw" | fdisk /dev/${disk}

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
arch-chroot /mnt

# execute .install-II.sh here

#umount -a
#swapoff -a
#reboot
