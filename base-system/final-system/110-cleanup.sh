#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=110-cleanup

touch /sources/build-log
if ! is_logged "$NAME"; then

cd /sources

rm -rf /tmp/*
find /usr/lib /usr/libexec -name \*.la -delete
find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf
userdel -r tester

fi

log $NAME
