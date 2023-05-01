#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=066-less

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=less-608.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr --sysconfdir=/etc
make
make install

fi

cleanup $DIRECTORY
log $NAME