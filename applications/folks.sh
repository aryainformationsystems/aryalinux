#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:evolution-data-server
#REQ:gobject-introspection
#REQ:libgee
#REQ:python-modules#python-dbusmock
#REQ:telepathy-glib
#REQ:bluez
#REQ:vala


cd $SOURCE_DIR

NAME=folks
VERSION=0.15.4
URL=https://download.gnome.org/sources/folks/0.15/folks-0.15.4.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="Folks is a library that aggregates people from multiple sources (e.g, Telepathy connection managers and Evolution Data Server, Facebook, etc.) to create metacontacts."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/folks/0.15/folks-0.15.4.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/folks/0.15/folks-0.15.4.tar.xz


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

meson --prefix=/usr --buildtype=release .. &&
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