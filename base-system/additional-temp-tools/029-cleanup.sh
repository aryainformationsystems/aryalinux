#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=029-cleanup

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources


rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools
exit
umount $LFS/dev/pts
umount $LFS/{sys,proc,run,dev}
cd $LFS
tar -cJpf $HOME/lfs-temp-tools-11.1-systemd.tar.xz .

fi

cleanup $DIRECTORY
log $NAME