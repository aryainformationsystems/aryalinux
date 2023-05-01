#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=031-iana-etc

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=iana-etc-20220207.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


cp services protocols /etc

fi

cleanup $DIRECTORY
log $NAME