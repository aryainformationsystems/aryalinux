#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=089-iproute2

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=iproute2-6.2.0.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8
make NETNS_RUN_DIR=/run/netns
make SBINDIR=/usr/sbin install
mkdir -pv             /usr/share/doc/iproute2-6.2.0
cp -v COPYING README* /usr/share/doc/iproute2-6.2.0

fi

cleanup $DIRECTORY
log $NAME