#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=035-lz4

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=lz4-1.10.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


make BUILD_STATIC=no PREFIX=/usr
make BUILD_STATIC=no PREFIX=/usr install

fi

cleanup $DIRECTORY
log $NAME
