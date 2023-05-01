#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:at-spi2-core
#REQ:gdk-pixbuf
#REQ:libepoxy
#REQ:pango
#REQ:adwaita-icon-theme
#REQ:docbook-xsl
#REQ:hicolor-icon-theme
#REQ:iso-codes
#REQ:libxkbcommon
#REQ:libxslt
#REQ:sassc
#REQ:wayland
#REQ:wayland-protocols
#REQ:gobject-introspection


cd $SOURCE_DIR

NAME=gtk3
VERSION=3.24.37
URL=https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.37.tar.xz
SECTION="Graphical Environment Libraries"
DESCRIPTION="The GTK+ 3 package contains libraries used for creating graphical user interfaces for applications."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gtk+/3.24/gtk+-3.24.37.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gtk+/3.24/gtk+-3.24.37.tar.xz


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
meson setup --prefix=/usr           \
            --buildtype=release     \
            -Dman=true              \
            -Dbroadway_backend=true \
            ..                      &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

mkdir -pv ~/.config/gtk-3.0/
cat > ~/.config/gtk-3.0/gtk.css << "EOF"
*  {
   -GtkScrollbar-has-backward-stepper: 1;
   -GtkScrollbar-has-forward-stepper: 1;
}
EOF


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd