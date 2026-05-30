#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=068-inetutils

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=inetutils-2.7.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --prefix=/usr        \
            --bindir=/usr/bin    \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers
make
make install
mv -v /usr/{,s}bin/ifconfig

fi

cleanup $DIRECTORY
log $NAME