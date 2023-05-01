#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=036-zstd

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=zstd-1.5.2.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


make
make prefix=/usr install
rm -v /usr/lib/libzstd.a

fi

cleanup $DIRECTORY
log $NAME