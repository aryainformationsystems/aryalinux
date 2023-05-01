#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=038-readline

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=readline-8.1.2.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.1.2
make SHLIB_LIBS="-lncursesw"
make SHLIB_LIBS="-lncursesw" install
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.1.2

fi

cleanup $DIRECTORY
log $NAME