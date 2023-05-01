#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=040-bc

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=bc-5.2.2.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


CC=gcc ./configure --prefix=/usr -G -O3
make
make install

fi

cleanup $DIRECTORY
log $NAME