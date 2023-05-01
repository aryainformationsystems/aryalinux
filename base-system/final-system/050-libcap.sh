#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=050-libcap

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=libcap-2.68.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i '/install -m.*STA/d' libcap/Makefile
make prefix=/usr lib=lib
make prefix=/usr lib=lib install

fi

cleanup $DIRECTORY
log $NAME