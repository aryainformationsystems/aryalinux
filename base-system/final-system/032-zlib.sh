#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=032-zlib

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=zlib-1.2.13.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr
make
make install
rm -fv /usr/lib/libz.a

fi

cleanup $DIRECTORY
log $NAME