#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=098-patch

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=patch-2.8.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr
make
make install

fi

cleanup $DIRECTORY
log $NAME