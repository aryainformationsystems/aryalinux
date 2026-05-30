#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=081-packaging

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=packaging-26.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist packaging

fi

cleanup $DIRECTORY
log $NAME
