#!/bin/bash

set -e
set +h

. /sources/build-properties

if ! grep "initramfs" /sources/build-log &> /dev/null
then

cd /sources

tar xf cpio-2.13.tar.bz2
cd cpio-2.13

patch -Np1 -i ../0001-src-global.c-drop-duplicate-definition-of-program_na.patch
./configure --prefix=/usr \
            --bindir=/bin \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt &&
make &&
make install

cd /sources
rm -rf cpio-2.13

tar xf dash-0.5.11.3.tar.gz
cd dash-0.5.11.3
./configure --prefix=/usr --enable-static
make
make install

cd /sources
rm -rf dash-0.5.11.3

tar xf dracut-053.tar.xz
cd dracut-053
sed -i "s/enable_documentation=yes/enable_documentation=no/g" configure
./configure
make
make install

cd /sources
rm -rf dracut-053

echo "initramfs" | tee -a /sources/build-log

fi

