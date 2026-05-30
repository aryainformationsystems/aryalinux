#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=060-gettext

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=gettext-1.0.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-1.0
make
make install
chmod -v 0755 /usr/lib/preloadable_libintl.so

fi

cleanup $DIRECTORY
log $NAME
