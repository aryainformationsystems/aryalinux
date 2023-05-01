#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gnutls
#REQ:gtk3
#REQ:libgcrypt
#REQ:gobject-introspection
#REQ:vala


cd $SOURCE_DIR

NAME=gtk-vnc
VERSION=1.3.1
URL=https://download.gnome.org/sources/gtk-vnc/1.3/gtk-vnc-1.3.1.tar.xz
SECTION="Graphical Environment Libraries"
DESCRIPTION="The Gtk VNC package contains a VNC viewer widget for GTK+. It is built using coroutines allowing it to be completely asynchronous while remaining single threaded."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gtk-vnc/1.3/gtk-vnc-1.3.1.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gtk-vnc/1.3/gtk-vnc-1.3.1.tar.xz


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