#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=069-less

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=less-692.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr --sysconfdir=/etc
make
make install

fi

cleanup $DIRECTORY
log $NAME