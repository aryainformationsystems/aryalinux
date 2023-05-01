#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=030-iana-etc

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=iana-etc-20230405.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


cp services protocols /etc

fi

cleanup $DIRECTORY
log $NAME