#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=038-m4

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=m4-1.4.19.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr
make
make install

fi

cleanup $DIRECTORY
log $NAME