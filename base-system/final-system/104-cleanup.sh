#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=104-cleanup

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources


rm -rf /tmp/*
find /usr/lib /usr/libexec -name \*.la -delete
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf

fi

cleanup $DIRECTORY
log $NAME