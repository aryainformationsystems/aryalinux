#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=078-sqlite

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=sqlite-autoconf-3510200.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


tar -xf ../sqlite-doc-3510200.tar.xz
./configure --prefix=/usr     \
            --disable-static  \
            --enable-fts{4,5} \
            CPPFLAGS="-D SQLITE_ENABLE_COLUMN_METADATA=1 \
                      -D SQLITE_ENABLE_UNLOCK_NOTIFY=1   \
                      -D SQLITE_ENABLE_DBSTAT_VTAB=1     \
                      -D SQLITE_SECURE_DELETE=1"
make LDFLAGS.rpath=""
make install
install -v -m755 -d /usr/share/doc/sqlite-3.51.2
cp -v -R sqlite-doc-3510200/* /usr/share/doc/sqlite-3.51.2

fi

cleanup $DIRECTORY
log $NAME
