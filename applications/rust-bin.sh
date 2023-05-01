#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:curl
#REQ:cmake
#REQ:libssh2
#REQ:llvm


cd $SOURCE_DIR

wget -nc https://sourceforge.net/projects/aryalinux-bin/files/files/2.0/rustc-1.35.0-x86_64.tar.xz


NAME=rust
VERSION=1.35.0


sudo tar -xf rustc-1.35.0-x86_64.tar.xz -C /


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

