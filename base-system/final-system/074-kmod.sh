#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=074-kmod

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=kmod-29.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr          \
            --sysconfdir=/etc      \
            --with-openssl         \
            --with-xz              \
            --with-zstd            \
            --with-zlib
make
make install

for target in depmod insmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod /usr/sbin/$target
done

ln -sfv kmod /usr/bin/lsmod

fi

cleanup $DIRECTORY
log $NAME