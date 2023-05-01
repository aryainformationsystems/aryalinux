#!/bin/bash

set -e
set +h

. /sources/build-properties

STEPNAME="kernel"
LOGFILE="/sources/build-log"

turnOn() {
	PROPERTY="$1"
	if grep "# $PROPERTY is not set" .config &> /dev/null
	then
		sed -i "s@# $PROPERTY is not set@$PROPERTY=y@g" .config
	else
		if ! grep "$PROPERTY=y" .config &> /dev/null
		then
			echo "$PROPERTY=y" >> .config
		fi
	fi
}

turnOff() {
	PROPERTY="$1"
	if grep "$PROPERTY=y" .config &> /dev/null
	then
		sed -i "s@$PROPERTY=y@# $PROPERTY is not set@g" .config
	else
		if ! grep "# $PROPERTY is not set" .config &> /dev/null
		then
			echo "# $PROPERTY is not set" >> .config
		fi
	fi
}

if ! grep "$STEPNAME" $LOGFILE &> /dev/null
then

cd /sources

LINUX_TARBALL=$(grep "kernel.org/pub/linux/kernel" wget-list | rev | cut -d/ -f1 | rev)
LINUX_SRC_DIR=`tar -tf $LINUX_TARBALL | cut "-d/" -f1 | uniq`
tar xf $LINUX_TARBALL
cd $LINUX_SRC_DIR

make mrproper

if [ `uname -m` != "x86_64" ]
then
	cp ../config-32 ./.config
else
	cp ../config-64 ./.config
fi

if [ `uname -m` != "x86_64" ]
then
	turnOff CONFIG_64BIT
fi

turnOn CONFIG_EFI_PARTITION
turnOn CONFIG_EFI
turnOn CONFIG_EFI_MIXED
turnOn CONFIG_EFI_STUB
turnOn CONFIG_FB_EFI
turnOn CONFIG_FRAMEBUFFER_CONSOLE
turnOff CONFIG_EFI_VARS
turnOn CONFIG_EFIVAR_FS
turnOff CONFIG_UEFI_CPER
turnOff CONFIG_EARLY_PRINTK_EFI

turnOff CONFIG_DEBUG_KERNEL
turnOff CONFIG_DEBUG_FS
turnOff CONFIG_X86_VERBOSE_BOOTUP
turnOff CONFIG_FTRACE
turnOff CONFIG_STACKTRACE
turnOn CONFIG_NTFS_FS
turnOff CONFIG_NTFS_DEBUG
turnOn CONFIG_NTFS_RW

turnOn CONFIG_SND_HDA_INTEL
turnOn CONFIG_SND_HDA_CODEC_REALTEK
turnOn CONFIG_SND_HDA_GENERIC
turnOn CONFIG_SND_HDA_CODEC_ANALOG
turnOn CONFIG_SND_HDA_CODEC_SIGMATEL
turnOn CONFIG_SND_HDA_CODEC_VIA
turnOn CONFIG_SND_HDA_CODEC_HDMI
turnOn CONFIG_SND_HDA_CODEC_CIRRUS
turnOn CONFIG_SND_HDA_CODEC_CONEXANT
turnOn CONFIG_SND_HDA_CODEC_CA0110
turnOn CONFIG_SND_HDA_CODEC_CA0132
turnOn CONFIG_SND_HDA_CODEC_CMEDIA
turnOn CONFIG_SND_HDA_CODEC_SI3054
turnOn CONFIG_SND_HDA_CODEC_CA0132_DSP
turnOn CONFIG_SND_HDA_PATCH_LOADER
turnOn CONFIG_SND_HDA_RECONFIG

turnOn CONFIG_SQUASHFS
turnOn CONFIG_SQUASHFS_FILE_CACHE
turnOn CONFIG_SQUASHFS_DECOMP_SINGLE
turnOn CONFIG_SQUASHFS_ZLIB
turnOn CONFIG_SQUASHFS_XZ
turnOn CONFIG_SQUASHFS_FILE_DIRECT
turnOn CONFIG_SQUASHFS_DECOMP_MULTI
turnOn CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU
turnOn CONFIG_SQUASHFS_XATTR
turnOn CONFIG_SQUASHFS_LZ4
turnOn CONFIG_SQUASHFS_LZO
turnOn CONFIG_SQUASHFS_4K_DEVBLK_SIZE
turnOn CONFIG_SQUASHFS_EMBEDDED

turnOn CONFIG_ISO9660_FS
turnOn CONFIG_AUFS_BR_HFSPLUS
turnOff CONFIG_RANDOMIZE_BASE
turnOff CONFIG_AUFS_BR_FUSE
turnOff CONFIG_KMEMCHECK

turnOn CONFIG_BLK_DEV_LOOP
turnOn CONFIG_BLK_DEV_CRYPTOLOOP

turnOn CONFIG_USB_OTG_FSM
turnOn CONFIG_USB_XHCI_HCD
turnOn CONFIG_USB_XHCI_PLATFORM
turnOn CONFIG_USB_EHCI_HCD
turnOn CONFIG_USB_EHCI_HCD_PLATFORM
turnOn CONFIG_USB_OHCI_HCD
turnOn CONFIG_USB_OHCI_HCD_PCI
turnOn CONFIG_USB_OHCI_HCD_PLATFORM
turnOn CONFIG_USB_UHCI_HCD

turnOn CONFIG_USB_STORAGE
turnOff CONFIG_CHARGER_ISP1704

echo "CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3" >> .config
sed "s@CONFIG_MESSAGE_LOGLEVEL_DEFAULT=4@CONFIG_MESSAGE_LOGLEVEL_DEFAULT=7@g" .config


sed -i "s@# CONFIG_INOTIFY_USER is not set@CONFIG_INOTIFY_USER=y@g" .config
sed -i "s@CONFIG_SYSFS_DEPRECATED=y@# CONFIG_SYSFS_DEPRECATED is not set@g" .config
sed -i "s@# CONFIG_CGROUPS is not set@CONFIG_CGROUPS=y@g" .config
sed -i "s@# CONFIG_DMIID is not set@CONFIG_DMIID=y@g" .config
sed -i "s@# CONFIG_TMPFS_XATTR is not set@CONFIG_TMPFS_XATTR=y@g" .config
sed -i "s@CONFIG_FW_LOADER_USER_HELPER=y@# CONFIG_FW_LOADER_USER_HELPER is not set@g" .config
sed -i "s@CONFIG_AUDIT=y@# CONFIG_AUDIT is not set@g" .config
sed -i "s@# CONFIG_SECCOMP is not set@CONFIG_SECCOMP=y@g" .config
sed -i "s@# CONFIG_EFI_STUB is not set@CONFIG_EFI_STUB=y@g" .config
sed -i "s@# CONFIG_DEVTMPFS is not set@CONFIG_DEVTMPFS=y@g" .config
sed -i "s@CONFIG_SYSFS_DEPRECATED_V2=y@# CONFIG_SYSFS_DEPRECATED_V2 is not set@g" .config
sed -i "s@# CONFIG_FHANDLE is not set@CONFIG_FHANDLE=y@g" .config
sed -i "s@CONFIG_UEVENT_HELPER=y@# CONFIG_UEVENT_HELPER is not set@g" .config
sed -i "s@# CONFIG_TMPFS_POSIX_ACL is not set@CONFIG_TMPFS_POSIX_ACL=y@g" .config


make "-j`nproc`"
make modules_install

LINUX_VERSION=$(ls /lib/modules/)
cp -v arch/x86/boot/bzImage "/boot/vmlinuz-$LINUX_VERSION"
cp -v System.map "/boot/System.map-$LINUX_VERSION"
cp -v .config "/boot/config-$LINUX_VERSION"
install -d "/usr/share/doc/linux-$LINUX_VERSION"
cp -r Documentation/* "/usr/share/doc/linux-$LINUX_VERSION"

install -v -m755 -d /etc/modprobe.d
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF

cd /sources
mv $LINUX_SRC_DIR /usr/src/
ln -svf /usr/src/$LINUX_SRC_DIR /lib/modules/$(ls /lib/modules)/build
ln -svf /usr/src/$LINUX_SRC_DIR /lib/modules/$(ls /lib/modules)/source

FIRMWARE_TAR=`ls linux-firmware*`
FIRMWARE_DIR=`tar tf $FIRMWARE_TAR | cut -d/ -f1 | uniq`

tar xf $FIRMWARE_TAR
cd $FIRMWARE_DIR
make install
cd /sources
rm -rf $FIRMWARE_DIR

dracut -f /boot/initrd.img-$LINUX_VERSION `ls /lib/modules`

echo "$STEPNAME" | tee -a $LOGFILE

fi
