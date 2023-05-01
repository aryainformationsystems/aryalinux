#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=020-xz

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=xz-5.4.2.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.4.2
make
make DESTDIR=$LFS install
rm -v $LFS/usr/lib/liblzma.la

fi

cleanup $DIRECTORY
log $NAME