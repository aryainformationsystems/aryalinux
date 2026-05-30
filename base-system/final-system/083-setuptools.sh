#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=083-setuptools

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=setuptools-82.0.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


pip3 wheel -w dist --no-cache-dir --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist setuptools

fi

cleanup $DIRECTORY
log $NAME
