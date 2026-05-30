#!/bin/bash

set -e
set +h

. /sources/build-properties

if ! grep "initramfs" /sources/build-log &> /dev/null
then

cd /sources

tar xf cpio-2.15.tar.bz2
cd cpio-2.15

sed -e "/^extern int (\*xstat)/s/()/(const char * restrict,  struct stat * restrict)/" \
    -i src/extern.h
sed -e "/^int (\*xstat)/s/()/(const char * restrict,  struct stat * restrict)/" \
    -i src/global.c

./configure --prefix=/usr \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt &&
make &&
make install

cd /sources
rm -rf cpio-2.15

tar xf dash-0.5.13.1.tar.gz
cd dash-0.5.13.1
./configure --prefix=/usr --bindir=/bin --enable-static
make
make install

cd /sources
rm -rf dash-0.5.13.1

tar xf dracut-056.tar.xz
cd dracut-056
sed -i "s/enable_documentation=yes/enable_documentation=no/g" configure
./configure
make
make install

cd /sources
rm -rf dracut-056

echo "initramfs" | tee -a /sources/build-log

fi
