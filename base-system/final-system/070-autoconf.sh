#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=070-autoconf

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=autoconf-2.71.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -e 's/SECONDS|/&SHLVL|/'               \
    -e '/BASH_ARGV=/a\        /^SHLVL=/ d' \
    -i.orig tests/local.at
./configure --prefix=/usr
make
make install

fi

cleanup $DIRECTORY
log $NAME