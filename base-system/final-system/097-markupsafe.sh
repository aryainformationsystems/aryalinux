#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=097-markupsafe

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=MarkupSafe-2.1.2.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


pip3 wheel -w dist --no-build-isolation --no-deps $PWD
pip3 install --no-index --no-user --find-links dist Markupsafe

fi

cleanup $DIRECTORY
log $NAME