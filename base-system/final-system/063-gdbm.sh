#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=063-gdbm

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=gdbm-1.23.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat
make
make install

fi

cleanup $DIRECTORY
log $NAME