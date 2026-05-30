#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=072-intltool

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=intltool-0.51.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i 's:\\\${:\\\$\\{:' intltool-update.in
./configure --prefix=/usr
make
make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO

fi

cleanup $DIRECTORY
log $NAME