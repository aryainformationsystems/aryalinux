#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk3
#REQ:gsettings-desktop-schemas
#REQ:libhandy1
#REQ:python-modules#pygobject3
#REQ:sound-theme-freedesktop


cd $SOURCE_DIR

NAME=gnome-tweaks
VERSION=40.10
URL=https://download.gnome.org/sources/gnome-tweaks/40/gnome-tweaks-40.10.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="GNOME Tweaks is a simple program used to tweak advanced GNOME settings."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gnome-tweaks/40/gnome-tweaks-40.10.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gnome-tweaks/40/gnome-tweaks-40.10.tar.xz


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

meson setup --prefix=/usr --buildtype=release &&
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