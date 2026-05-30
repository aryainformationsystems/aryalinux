#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=040-m4

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=m4-1.4.21.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr
make
make install

fi

cleanup $DIRECTORY
log $NAME