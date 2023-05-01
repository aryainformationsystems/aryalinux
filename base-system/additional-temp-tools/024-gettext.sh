#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=024-gettext

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=gettext-0.21.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


./configure --disable-shared
make
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin

fi

cleanup $DIRECTORY
log $NAME