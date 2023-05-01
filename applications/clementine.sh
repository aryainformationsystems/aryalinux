#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:multimedia-plugins
#REQ:protobuf
#REQ:libchromaprint
#REQ:libgpod
#REQ:libimobiledevice
#REQ:libmygpo-qt1
#REQ:libcrypto++
#REQ:libechonest
#REQ:glew
#REQ:libsparsehash
#REQ:libmtp
#REQ:sqlite
#REQ:liblastfm


cd $SOURCE_DIR

NAME=clementine
VERSION=1.4.0rc1-603-g75de59703
URL=https://github.com/clementine-player/Clementine/releases/download/1.4.0rc1-603-g75de59703/clementine-1.4.0rc1-603-g75de59703.tar.xz
DESCRIPTION="Clementine is a multiplatform music player focusing on a fast and easy-to-use interface for searching and playing your music."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/clementine-player/Clementine/releases/download/1.4.0rc1-603-g75de59703/clementine-1.4.0rc1-603-g75de59703.tar.xz


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

mkdir build &&
cd build &&
cmake -DCMAKE_INSTALL_PREFIX=/usr .. &&
make "-j`nproc`"
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd