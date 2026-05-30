#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=095-kbd

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=kbd-2.9.0.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


patch -Np1 -i ../kbd-2.9.0-backspace-1.patch
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
./configure --prefix=/usr --disable-vlock
make
make install
mkdir -pv           /usr/share/doc/kbd-2.9.0
cp -R -v docs/doc/* /usr/share/doc/kbd-2.9.0

fi

cleanup $DIRECTORY
log $NAME
