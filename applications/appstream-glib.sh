#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:valgrind


cd $SOURCE_DIR

NAME=appstream-glib
VERSION=0.7.16
URL=https://github.com/hughsie/appstream-glib/archive/appstream_glib_0_7_16.tar.gz
DESCRIPTION="This library provides GObjects and helper methods to make it easy to read and write AppStream metadata. It also provides a simple DOM implementation that makes it easy to edit nodes and convert to and from the standardized XML representation."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/hughsie/appstream-glib/archive/appstream_glib_0_7_16.tar.gz


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

mkdir build
cd build/
meson --prefix=/usr --libdir=/usr/lib --sysconfdir=/etc --mandir=/usr/man -Dgtk-doc=false -Dstemmer=false -Drpm=false ..
ninja
sudo ninja install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd