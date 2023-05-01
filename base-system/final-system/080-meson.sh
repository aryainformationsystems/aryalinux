#!/bin/bash

set -e
set +h

. /sources/build-properties
. /sources/build-functions

NAME=080-meson

touch /sources/build-log
if ! grep "$NAME" /sources/build-log; then

cd /sources

TARBALL=meson-1.1.0.tar.gz
DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq)

tar xf $TARBALL
cd $DIRECTORY


pip3 wheel -w dist --no-build-isolation --no-deps $PWD
pip3 install --no-index --find-links dist meson
install -vDm644 data/shell-completions/bash/meson /usr/share/bash-completion/completions/meson
install -vDm644 data/shell-completions/zsh/_meson /usr/share/zsh/site-functions/_meson

fi

cleanup $DIRECTORY
log $NAME