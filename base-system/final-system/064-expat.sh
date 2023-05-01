#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=064-expat

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=expat-2.5.0.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.5.0
make
make install
install -v -m644 doc/*.{html,css} /usr/share/doc/expat-2.5.0

fi

cleanup $DIRECTORY
log $NAME