#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=061-libtool

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=libtool-2.4.7.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr
make
make install
rm -fv /usr/lib/libltdl.a

fi

cleanup $DIRECTORY
log $NAME