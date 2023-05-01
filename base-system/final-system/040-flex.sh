#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=040-flex

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=flex-2.6.4.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr \
            --docdir=/usr/share/doc/flex-2.6.4 \
            --disable-static
make
make install
ln -sv flex /usr/bin/lex

fi

cleanup $DIRECTORY
log $NAME