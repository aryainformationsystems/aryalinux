#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=grub-setup


SECTION="File Systems and Disk Management"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")



if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

echo $USER > /tmp/currentuser


mkfs.vfat /dev/sdx1
fdisk /dev/sdx
mkdir -pv /mnt/rescue &&
mount -v -t vfat /dev/sdx1 /mnt/rescue
grub-install --removable --efi-directory=/mnt/rescue --boot-directory=/mnt/rescue/grub
umount /mnt/rescue
fdisk -l /dev/sda
mkdir -pv /boot/efi &&
mount -v -t vfat /dev/sda1 /boot/efi
cat >> /etc/fstab << EOF
mountpoint /sys/firmware/efi/efivars || mount -v -t efivarfs efivarfs /sys/firmware/efi/efivars
grub-install --bootloader-id=LFS --recheck
cat > /boot/grub/grub.cfg << EOF
cat >> /boot/grub/grub.cfg << EOF


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd