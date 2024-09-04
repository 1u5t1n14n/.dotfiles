# .dotfiles
This Repository only exists, so I can backup my `.dotfiles`. So don't expect too much.
But feel free to copy things to your Configs.
## .install.sh
I may or may not use this. It is only experimental, has not been tested yet and I only "wrote" this, so I can install Arch faster. If you find errors, it would be nice knowing them.

BEFORE you run the script, make sure you have created these partitions with fdisk or any other tool):
- 1GB EFI-System (should be the first partition)
- 1MB BIOS boot (should be 2nd partition)
- Linux Swap (should be 3rd; can have any size)
- finally with the rest of your disk LVM partition (LVM is 44 in fdisk)

To use the Script, write it to a file:
```
echo "$(curl https://raw.githubusercontent.com/1u5t1n14n/.dotfiles/main/.install.sh)" > .install.sh
```
Make it executable:
```
chmod +x .install.sh
```
Edit it to your preferences (mandatory if your disk is smaller than 1TB)
And run it:
```
./.install.sh
```
