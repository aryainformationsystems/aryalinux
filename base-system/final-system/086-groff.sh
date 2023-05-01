#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=086-groff

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=groff-1.22.4.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


PAGE=$PAPER_SIZE ./configure --prefix=/usr
make
make install

fi

cleanup $DIRECTORY
log $NAME