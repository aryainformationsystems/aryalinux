#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=091-groff

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=groff-1.23.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


PAGE=$PAPER_SIZE ./configure --prefix=/usr
make
make install

fi

cleanup $DIRECTORY
log $NAME