#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=098-man-db

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=man-db-2.11.2.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr                         \
            --docdir=/usr/share/doc/man-db-2.11.2 \
            --sysconfdir=/etc                     \
            --disable-setuid                      \
            --enable-cache-owner=bin              \
            --with-browser=/usr/bin/lynx          \
            --with-vgrind=/usr/bin/vgrind         \
            --with-grap=/usr/bin/grap             \
            --with-systemdtmpfilesdir=            \
            --with-systemdsystemunitdir=
make
make install

fi

cleanup $DIRECTORY
log $NAME