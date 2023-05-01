#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=081-check

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=check-0.15.2.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr --disable-static
make
make docdir=/usr/share/doc/check-0.15.2 install

fi

cleanup $DIRECTORY
log $NAME