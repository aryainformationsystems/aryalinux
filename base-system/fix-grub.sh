#!/bin/bash

set -e
set +h

. /sources/build-properties

export MAKEFLAGS="-j `nproc`"
SOURCE_DIR="/sources"
LOGFILE="/sources/build-log"
STEPNAME="fix-grub.sh"
TARBALL="grub-2.14.tar.xz"

cd $SOURCE_DIR

# Installation of pciutils

tar xf pciutils-3.14.0.tar.gz
cd pciutils-3.14.0

sed -r '/INSTALL/{/PCI_IDS|update-pciids /d; s/update-pciids.8//}' \
    -i Makefile

make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes
make PREFIX=/usr                \
     SHAREDIR=/usr/share/hwdata \
     SHARED=yes                 \
     install install-lib        &&

chmod -v 755 /usr/lib/libpci.so

cd $SOURCE_DIR
rm -rf pciutils-3.14.0

# Installation of freetype2

tar xf freetype-2.14.1.tar.xz
cd freetype-2.14.1
sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&

./configure --prefix=/usr            \
            --disable-static         \
            --enable-freetype-config \
            --with-harfbuzz=no &&
make
make install

cd $SOURCE_DIR
rm -rf freetype-2.14.1

if [ "$TARBALL" != "" ]
then
	DIRECTORY=`tar -tf $TARBALL | cut -d/ -f1 | uniq`
	rm -rf $DIRECTORY
	tar xf $TARBALL
	cd $DIRECTORY
fi

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
zcat ../unifont-17.0.03.pcf.gz > /usr/share/fonts/unifont/unifont.pcf
grub-mkfont -o /usr/share/grub/unicode.pf2 /usr/share/fonts/unifont/unifont.pcf

cd $SOURCE_DIR
if [ "$TARBALL" != "" ]
then
	rm -rf $DIRECTORY
	rm -rf {gcc,glibc,binutils}-build
fi

echo "$STEPNAME" | tee -a $LOGFILE
