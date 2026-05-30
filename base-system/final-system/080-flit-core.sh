#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=080-flit-core

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=flit_core-3.12.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist flit_core

fi

cleanup $DIRECTORY
log $NAME
