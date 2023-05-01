#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="008-bootloader.sh"

if [ "$INSTALL_BOOTLOADER" == "n" ] || [ "$INSTALL_BOOTLOADER" == "N" ]; then
	exit
fi

if [ "$INSTALL_BOOTLOADER" == "y" ] || [ "$INSTALL_BOOTLOADER" == "Y" ]; then
  /sources/bootloader-check.sh &> $LOGFILE
  if [ "$?" != "0" ]; then
    exit
  fi
fi

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd $SOURCE_DIR

if [ -d /sys/firmware/efi ]
then

EFIPART="$DEV_NAME`partx -s $DEV_NAME | tr -s ' ' | grep "EFI" | sed "s@^ *@@g" | cut "-d " -f1`"
EFIPART_UUID=`blkid $EFIPART | cut '-d"' -f2`

if [ "x$EFIPART" == "x$DEV_NAME" ]
then

grub-install $DEV_NAME
grub-mkconfig -o /boot/grub/grub.cfg

else

mkdir -pv /boot/efi

{
set +e
mount -vt vfat $EFIPART /boot/efi
mount -t efivarfs efivars /sys/firmware/efi/efivars
set -e
}

cat >> /etc/fstab <<EOF
UUID=$EFIPART_UUID       /boot/efi    vfat     defaults            0     1
efivarfs       /sys/firmware/efi/efivars  efivarfs  defaults  0      1
EOF

BOOTLOADER_ID="$OS_NAME $OS_VERSION $OS_CODENAME ($ROOT_PART)"
PARTNUMBER=$(echo $EFIPART | sed "s@$DEV_NAME@@g")

grub-install --target=$(uname -m)-efi --efi-directory=/boot/efi --bootloader-id="$BOOTLOADER_ID" --recheck --debug
efibootmgr --create --gpt --disk $DEV_NAME --part $PARTNUMBER --write-signature --label "$BOOTLOADER_ID" --loader "/EFI/grub/grubx64.efi"
grub-mkconfig -o /boot/grub/grub.cfg

fi

else

grub-install $DEV_NAME
grub-mkconfig -o /boot/grub/grub.cfg

fi

echo "$STEPNAME" | tee -a $LOGFILE

fi
