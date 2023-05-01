#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=018-sed

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=sed-4.9.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr   \
            --host=$LFS_TGT
make
make DESTDIR=$LFS install

fi

cleanup $DIRECTORY
log $NAME