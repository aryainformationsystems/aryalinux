#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=103-jinja2

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=jinja2-3.1.6.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


pip3 wheel -w dist --no-build-isolation --no-deps $PWD
pip3 install --no-index --no-user --find-links dist Jinja2

fi

cleanup $DIRECTORY
log $NAME