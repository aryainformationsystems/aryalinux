#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=107-procps-ng

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=procps-ng-4.0.6.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr                           \
            --docdir=/usr/share/doc/procps-ng-4.0.6 \
            --disable-static                        \
            --disable-kill                          \
            --with-systemd
make
make install

fi

cleanup $DIRECTORY
log $NAME