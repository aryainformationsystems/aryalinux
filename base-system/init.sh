#!/bin/busybox sh
#
# This file is a modified version of:
#
# Initramfs boot script 1.3.1 (2012-02-09)
# Copyright (c) 2010-2012   Marcel van den Boer
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to
# deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
# sell copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS

set -e

ARCH="<ARCH>"

copyBindMount() {
    mount -t tmpfs tmpfs ${ROOT}
    cd /mnt/system
    for dir in $(ls -1); do
        case ${dir} in
            lost+found)
                ;;
            bin | boot | lib | opt | sbin | usr)
                mkdir ${ROOT}/${dir}
                mount --bind ${dir} ${ROOT}/${dir}
                ;;
            *)
                cp -R ${dir} ${ROOT}
                ;;
        esac
    done
    cd /
};

unionMount() {
    mkdir -p /mnt/writable
    mount -t tmpfs -o rw tmpfs /mnt/writable
    mkdir -p /mnt/writable/workdir
    mkdir -p /mnt/writable/upperdir
    mount -t overlay overlay -o lowerdir=/mnt/system,upperdir=/mnt/writable/upperdir,workdir=/mnt/writable/workdir ${ROOT} 2> /dev/null
}

# Make required applets easier to access
for applet in cat chmod cp cut grep ls mkdir mknod mount umount switch_root \
    rm mv vi cpio tar mke2fs sync fdisk dd sleep; do
    /bin/busybox ln /bin/busybox /bin/${applet}
done

busybox clear
echo "Loading AryaLinux. Please wait..."
sleep 3

mknod /dev/scd0 b 11  0
mknod /dev/scd1 b 11  1
mknod /dev/scd2 b 11  2
mknod /dev/scd3 b 11  3

mknod /dev/hdc  b 22  0
                       
mknod /dev/sda  b  8  0
mknod /dev/sda1 b  8  1
mknod /dev/sda2 b  8  2
mknod /dev/sda3 b  8  3
mknod /dev/sda4 b  8  4
                       
mknod /dev/sdb  b  8 16
mknod /dev/sdb1 b  8 17
mknod /dev/sdb2 b  8 18
mknod /dev/sdb3 b  8 19
mknod /dev/sdb4 b  8 20
                       
mknod /dev/sdc  b  8 32
mknod /dev/sdc1 b  8 33
mknod /dev/sdc2 b  8 34
mknod /dev/sdc3 b  8 35
mknod /dev/sdc4 b  8 36
                       
mknod /dev/sdd  b  8 48
mknod /dev/sdd1 b  8 49
mknod /dev/sdd2 b  8 50
mknod /dev/sdd3 b  8 51
mknod /dev/sdd4 b  8 52

# Create mount points for filesystems
mkdir -p /mnt/medium
mkdir -p /mnt/system
mkdir -p /mnt/rootfs

# Mount the /proc filesystem (enables filesystem detection for 'mount')
mkdir /proc
mount -t proc proc /proc

# Invoke busybox if requested via the kernel command line.
if [ `grep -c "busybox" /proc/cmdline` -ne "0" ]; then 
    echo "Busybox requested"; 
    busybox sh
fi

# Search for, and mount the boot medium
LABEL="$(cat /boot/id_label)"
for device in $(ls /dev); do
    [ "${device}" == "console" ] && continue
    [ "${device}" == "null"    ] && continue

    mount -o ro /dev/${device} /mnt/medium 2> /dev/null && \
    if [ "$(cat /mnt/medium/isolinux/id_label)" != "${LABEL}" ]; then
        umount /mnt/medium
    else
        DEVICE="${device}"
        break
    fi
	busybox clear
	echo "Loading AryaLinux. Please wait..."
done

if [ "${DEVICE}" == "" ]; then
    echo "FATAL: Boot medium not found."
    /bin/busybox sh
fi

# Mount the system image
mount -t squashfs -o ro,loop /mnt/medium/aryalinux/root.sfs /mnt/system || {
    echo "FATAL: Boot medium found, but system image is missing."
    /bin/busybox sh
}

busybox clear
echo "Loading AryaLinux. Please wait..."

# Define where the new root filesystem will be
ROOT="/mnt/rootfs"

# Run in bootable cd mode if requested via the kernel command line.
if [ `grep -c "bootcd" /proc/cmdline` -ne "0" ]; then 
    echo "Bootcd mode (bind mount) requested"; 
    copyBindMount
else
    # Select LiveCD mode
    unionMount
fi

# Tell LFS to skip fsck during startup:
> $ROOT/fastboot

# Move current mounts to directories accessible in the new root
cd /mnt
for dir in $(ls -1); do
    if [ "${dir}" != "rootfs" ]; then
        mkdir -p ${ROOT}/mnt/.boot/${dir}
        mount --move /mnt/${dir} ${ROOT}/mnt/.boot/${dir}
    fi
done
cd /

# Run secondary initialization (if the system provides it)
if [ -x ${ROOT}/usr/share/live/sec_init.sh ]; then
    . ${ROOT}/usr/share/live/sec_init.sh
fi

# Clean up
umount /proc
busybox clear
echo "Loading AryaLinux. Please wait..."
# Switch to the new root and launch INIT!
exec switch_root -c /dev/console ${ROOT} /sbin/init