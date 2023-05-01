#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=060-bash

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=bash-5.2.15.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr             \
            --without-bash-malloc     \
            --with-installed-readline \
            --docdir=/usr/share/doc/bash-5.2.15
make
make install

fi

cleanup $DIRECTORY
log $NAME