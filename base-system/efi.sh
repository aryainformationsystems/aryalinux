#!/bin/bash

set -e

. ./build-properties

export SOURCE_DIR="/sources"

EFIPART="$DEV_NAME`partx -s /dev/sda | tr -s ' ' | grep "EFI" | sed "s@^ *@@g" | cut "-d " -f1`"
mkdir -pv /boot/efi

{
set +e
mount -vt vfat $EFIPART /boot/efi
set -e
}

cat >> /etc/fstab <<EOF
$EFIPART       /boot/efi    vfat     defaults            0     1
efivarfs       /sys/firmware/efi/efivars  efivarfs  defaults  0      1
EOF

grub-install --target=x86_64-efi --efi-directory=/boot/efi  \
   --bootloader-id="$OS_NAME $OS_VERSION $OS_CODENAME" --recheck --debug

grub-mkconfig -o /boot/grub/grub.cfg
