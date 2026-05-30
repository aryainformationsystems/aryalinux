#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=062-grep

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=grep-3.12.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i "s/echo/#echo/" src/egrep.sh
./configure --prefix=/usr
make
make install

fi

cleanup $DIRECTORY
log $NAME