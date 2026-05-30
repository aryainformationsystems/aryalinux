#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=102-markupsafe

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=markupsafe-3.0.3.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


pip3 wheel -w dist --no-build-isolation --no-deps $PWD
pip3 install --no-index --no-user --find-links dist Markupsafe

fi

cleanup $DIRECTORY
log $NAME