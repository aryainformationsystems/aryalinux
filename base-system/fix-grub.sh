#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="091-grub.sh"
TARBALL="grub-2.06~rc1.tar.xz"

cd $SOURCE_DIR

DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

rm -rf $DIRECTORY
tar xf $TARBALL
cd $DIRECTORY

sed -i "s@GNU GRUB  version %s@$OS_NAME $OS_VERSION $OS_CODENAME \- GNU GRUB@g" grub-core/normal/main.c

if [ `uname -m` == "x86_64" ]
then

./configure --prefix=/usr      \
	--sbindir=/sbin        \
	--localstatedir=/var   \
	--sysconfdir=/etc      \
	--enable-grub-mkfont   \
	--program-prefix=""    \
	--with-bootdir="/boot" \
	--with-grubdir="grub"  \
	--disable-werror       \
	--with-platform=efi --target=x86_64 &&
make "-j`nproc`"
make install
make clean

fi

./configure --prefix=/usr      \
	--sbindir=/sbin        \
	--localstatedir=/var   \
	--sysconfdir=/etc      \
	--enable-grub-mkfont   \
	--program-prefix=""    \
	--with-bootdir="/boot" \
	--with-grubdir="grub"  \
	--disable-werror &&
make
make install

mkdir -pv /usr/share/fonts/unifont
gunzip -c ../unifont-7.0.05.pcf.gz > /usr/share/fonts/unifont/unifont.pcf
grub-mkfont -o /usr/share/grub/unicode.pf2 /usr/share/fonts/unifont/unifont.pcf

cd $SOURCE_DIR
if [ "$TARBALL" != "" ]
then
	rm -rf $DIRECTORY
	rm -rf {gcc,glibc,binutils}-build
fi

rm -rf $DIRECTORY
