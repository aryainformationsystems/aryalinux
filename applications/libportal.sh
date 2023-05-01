#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gobject-introspection
#REQ:gtk3
#REQ:gtk4
#REQ:qt5


cd $SOURCE_DIR

NAME=libportal
VERSION=0.5
URL=https://github.com/flatpak/libportal/releases/download/0.5/libportal-0.5.tar.xz
SECTION="General Libraries"
DESCRIPTION="The libportal package provides a library that contains GIO-style async APIs for most Flatpak portals."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/flatpak/libportal/releases/download/0.5/libportal-0.5.tar.xz


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


if [ -e /usr/include/libportal ]; then
    rm -rf /usr/include/libportal.old &&
    mv -vf /usr/include/libportal{,.old}
fi
mkdir build &&
cd    build &&

meson --prefix=/usr --buildtype=release -Ddocs=false .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd