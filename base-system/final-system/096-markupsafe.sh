#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=096-markupsafe

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=MarkupSafe-2.0.1.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


python3 setup.py build
python3 setup.py install --optimize=1

fi

cleanup $DIRECTORY
log $NAME