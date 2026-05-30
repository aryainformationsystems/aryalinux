#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=029-man-pages

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

TARBALL=man-pages-6.17.tar.xz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY

# Libxcrypt (055-shadow) installs better crypt(3) man pages later.
rm -fv man3/crypt*

# GNUmakefile requires -R (disables make built-in variables).
make -R GIT=false prefix=/usr install

fi

cleanup $DIRECTORY
log $NAME