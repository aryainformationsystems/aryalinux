#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=027-python

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=Python-3.10.2.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip
make
make install

fi

cleanup $DIRECTORY
log $NAME