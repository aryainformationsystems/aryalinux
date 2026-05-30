#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=077-libffi

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=libffi-3.5.2.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr          \
            --disable-static       \
            --with-gcc-arch=x86-64
make
make install

fi

cleanup $DIRECTORY
log $NAME