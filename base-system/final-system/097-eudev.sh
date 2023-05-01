#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=097-eudev

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=eudev-3.2.11.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i '/udevdir/a udev_dir=${udevdir}' src/udev/udev.pc.in
./configure --prefix=/usr           \
            --bindir=/usr/sbin      \
            --sysconfdir=/etc       \
            --enable-manpages       \
            --disable-static
make
mkdir -pv /usr/lib/udev/rules.d
mkdir -pv /etc/udev/rules.d
make install
tar -xvf ../udev-lfs-20171102.tar.xz
make -f udev-lfs-20171102/Makefile.lfs install
cat > /etc/udev/rules.d/65-kvm.rules << "EOF"
KERNEL=="kvm", GROUP="kvm", MODE="0660", TAG+="uaccess"
EOF
udevadm hwdb --update

fi

cleanup $DIRECTORY
log $NAME