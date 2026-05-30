#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=087-coreutils

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=coreutils-9.10.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


patch -Np1 -i ../coreutils-9.10-i18n-1.patch
autoreconf -fv
automake -af
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr
make
make install
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8

fi

cleanup $DIRECTORY
log $NAME
