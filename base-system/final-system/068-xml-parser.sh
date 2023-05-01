#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=068-xml-parser

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=XML-Parser-2.46.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


perl Makefile.PL
make
make install

fi

cleanup $DIRECTORY
log $NAME