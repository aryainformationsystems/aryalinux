#!/bin/bash

set -e

SOURCE_DIR=/sources

cd $SOURCE_DIR

LABEL="$1"

rm -vf grub-embedded.cfg
rm -vf efiboot.img

cat > grub-embedded.cfg <<"EOF"
search --file --set=root /aryalinux/root.sfs
set prefix=($root)/EFI/BOOT/
EOF

rm -vf bootx64.efi
grub-mkimage --format=x86_64-efi --output=bootx64.efi --config=grub-embedded.cfg --compression=xz --prefix=/EFI/BOOT part_gpt part_msdos fat ext2 hfs hfsplus iso9660 udf ufs1 ufs2 zfs chain linux boot configfile normal regexp minicmd reboot halt search search_fs_file search_fs_uuid search_label gfxterm gfxmenu efi_gop efi_uga all_video loadbios gzio echo true probe loadenv bitmap_scale font cat help ls png jpeg tga test at_keyboard usb_keyboard

dd if=/dev/zero of=efiboot.img bs=1K count=1440
mkdosfs -F 12 efiboot.img
MOUNTPOINT=$(mktemp -d)
mount -o loop efiboot.img $MOUNTPOINT
mkdir -p $MOUNTPOINT/EFI/BOOT
cp -v bootx64.efi $MOUNTPOINT/EFI/BOOT
cat > $MOUNTPOINT/EFI/BOOT/grub.cfg << EOF
set default="0"
set timeout="30"
set hidden_timeout_quiet=false

menuentry "$LABEL"{
  echo "Loading AryaLinux.  Please wait..."
  linux /isolinux/vmlinuz quiet splash
  initrd /isolinux/initram.fs
}

menuentry "$LABEL Debug Mode"{
  echo "Loading AryaLinux in debug mode.  Please wait..."
  linux /isolinux/vmlinuz
  initrd /isolinux/initram.fs
}
EOF
cp $MOUNTPOINT/EFI/BOOT/grub.cfg .

umount $MOUNTPOINT
rmdir $MOUNTPOINT

