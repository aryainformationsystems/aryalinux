#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=016-make

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=make-4.4.1.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)
make
make DESTDIR=$LFS install

fi

cleanup $DIRECTORY
log $NAME