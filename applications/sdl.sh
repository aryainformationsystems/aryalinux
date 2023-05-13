#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cmake
#REQ:sdl2
#REQ:glu


cd $SOURCE_DIR

NAME=sdl
VERSION=1.2.60
URL=https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-1.2.60/sdl12-compat-release-1.2.60.tar.gz
SECTION="Multimedia Libraries and Drivers"
DESCRIPTION="The Simple DirectMedia Layer (SDL for short) is a cross-platform library designed to make it easy to write multimedia software, such as games and emulators. This code is a compatibility layer; it provides a binary and source compatible API for programs written against SDL 1.2, but it uses SDL 2.0 behind the scenes."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/libsdl-org/sdl12-compat/archive/refs/tags/release-1.2.60/sdl12-compat-release-1.2.60.tar.gz


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

echo $USER > /tmp/currentuser


mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=RELEASE  \
      ..  &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
rm -vf /usr/lib/libSDLmain.a
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd