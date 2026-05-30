#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=099-tar

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=tar-1.35.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr
make
make install
make -C doc install-html docdir=/usr/share/doc/tar-1.35

fi

cleanup $DIRECTORY
log $NAME