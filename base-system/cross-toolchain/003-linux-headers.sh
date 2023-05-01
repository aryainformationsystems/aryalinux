#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=003-linux-headers

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources


make mrproper
make headers
find usr/include -type f ! -name '*.h' -delete
cp -rv usr/include $LFS/usr

fi

cleanup $DIRECTORY
log $NAME