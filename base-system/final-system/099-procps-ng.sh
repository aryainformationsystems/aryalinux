#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=099-procps-ng

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=procps-ng-4.0.3.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr                           \
            --docdir=/usr/share/doc/procps-ng-4.0.3 \
            --disable-static                        \
            --disable-kill
make
make install

fi

cleanup $DIRECTORY
log $NAME