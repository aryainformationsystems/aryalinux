#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=051-attr

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=attr-2.5.2.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.5.2
make
make install

fi

cleanup $DIRECTORY
log $NAME