#!/bin/bash
dnf install -y cpio util-linux jq rsync
mkdir -p /tmp/RPi4boot/boot/efi/
dnf install -y --downloadonly --forcearch=aarch64 --destdir=/tmp/RPi4boot/  uboot-images-armv8 bcm283x-firmware bcm283x-overlays
for rpm in /tmp/RPi4boot/*rpm; do rpm2cpio $rpm | sudo cpio -idv -D /tmp/RPi4boot/; done
mv /tmp/RPi4boot/usr/share/uboot/rpi_4/u-boot.bin /tmp/RPi4boot/boot/efi/rpi4-u-boot.bin
FCOSEFIPARTITION=$(lsblk $FCOSDISK -J -oLABEL,PATH  | jq -r '.blockdevices[] | select(.label == "EFI-SYSTEM")'.path)
mkdir /tmp/FCOSEFIpart
mount $FCOSEFIPARTITION /tmp/FCOSEFIpart
rsync -avh --ignore-existing /tmp/RPi4boot/boot/efi/ /tmp/FCOSEFIpart/
umount $FCOSEFIPARTITION



