#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=046-mpfr

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=mpfr-4.2.0.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -e 's/+01,234,567/+1,234,567 /' \
    -e 's/13.10Pd/13Pd/'            \
    -i tests/tsprintf.c
./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.2.0
make
make html
make install
make install-html

fi

cleanup $DIRECTORY
log $NAME