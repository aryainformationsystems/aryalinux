#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:atkmm
#REQ:gtk3
#REQ:pangomm


cd $SOURCE_DIR

NAME=gtkmm3
VERSION=3.24.7
URL=https://download.gnome.org/sources/gtkmm/3.24/gtkmm-3.24.7.tar.xz
SECTION="Graphical Environment Libraries"
DESCRIPTION="The Gtkmm package provides a C++ interface to GTK+ 3."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gtkmm/3.24/gtkmm-3.24.7.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gtkmm/3.24/gtkmm-3.24.7.tar.xz


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


mkdir gtkmm3-build &&
cd    gtkmm3-build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

mv -v /usr/share/doc/gtkmm-3.0 /usr/share/doc/gtkmm-3.24.7


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd