#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=101-procps-ng

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=procps-ng-3.3.17.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr                            \
            --docdir=/usr/share/doc/procps-ng-3.3.17 \
            --disable-static                         \
            --disable-kill                           \
            --with-systemd
make
make install

fi

cleanup $DIRECTORY
log $NAME