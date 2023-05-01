#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=049-acl

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=acl-2.3.1.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr         \
            --disable-static      \
            --docdir=/usr/share/doc/acl-2.3.1
make
make install

fi

cleanup $DIRECTORY
log $NAME