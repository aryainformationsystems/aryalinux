#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=003-linux-headers

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=linux-6.2.11.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


make mrproper
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr

fi

cleanup $DIRECTORY
log $NAME