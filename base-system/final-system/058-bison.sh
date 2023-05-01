#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=058-bison

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=bison-3.8.2.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.8.2
make
make install

fi

cleanup $DIRECTORY
log $NAME