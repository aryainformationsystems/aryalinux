#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=libcrypto++
VERSION=8.5.0
URL=https://github.com/weidai11/cryptopp/archive/refs/tags/CRYPTOPP_8_5_0.tar.gz
DESCRIPTION="Crypto++ is library for creating C++ programs which use cryptographic algorithms. The library uses a Pipes & Filters architecture with heavy use of templates and abstract base classes."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/weidai11/cryptopp/archive/refs/tags/CRYPTOPP_8_5_0.tar.gz


if [ ! -z $URL ]
then

TARBALL=$(echo $URL | rev | cut -d/ -f1 | rev)
if [ -z $(echo $TARBALL | grep ".zip$") ]; then
	DIRECTORY=$(tar tf $TARBALL | cut -d/ -f1 | uniq | grep -v "^\.$")
	sudo rm -rf $DIRECTORY
	tar --no-overwrite-dir -xf $TARBALL
else
	DIRECTORY=$(unzip_dirname $TARBALL $NAME)
	unzip_file $TARBALL $NAME
fi

cd $DIRECTORY
fi

sed -i "s@/usr/local@/usr@g" GNUmakefile
make "-j`nproc`"
make libcryptopp.so


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd