#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk4
#REQ:gsound
#REQ:itstool
#REQ:libnotify
#REQ:upower
#REQ:gobject-introspection
#REQ:libadwaita


cd $SOURCE_DIR

NAME=gnome-bluetooth
VERSION=42.5
URL=https://download.gnome.org/sources/gnome-bluetooth/42/gnome-bluetooth-42.5.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The GNOME Bluetooth package contains tools for managing and manipulating Bluetooth devices using the GNOME Desktop."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gnome-bluetooth/42/gnome-bluetooth-42.5.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gnome-bluetooth/42/gnome-bluetooth-42.5.tar.xz


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

meson setup --prefix=/usr --buildtype=release .. &&
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