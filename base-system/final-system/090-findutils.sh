#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=090-findutils

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=findutils-4.10.0.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr --localstatedir=/var/lib/locate
make
make install

fi

cleanup $DIRECTORY
log $NAME