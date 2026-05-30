#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=001-binutils-pass1

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=binutils-2.46.0.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


mkdir -v build
cd       build
../configure --prefix=$LFS/tools \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --enable-gprofng=no \
             --disable-werror    \
             --enable-new-dtags  \
             --enable-default-hash-style=gnu
make
make install

fi

cleanup $DIRECTORY
log $NAME