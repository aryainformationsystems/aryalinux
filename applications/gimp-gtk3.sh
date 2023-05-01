#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gegl
#REQ:gexiv2
#REQ:glib-networking
#REQ:gtk2
#REQ:harfbuzz
#REQ:libjpeg
#REQ:libmypaint
#REQ:librsvg
#REQ:libtiff
#REQ:libxml2py2
#REQ:lcms2
#REQ:mypaint-brushes
#REQ:poppler
#REQ:dbus-glib
#REQ:gs
#REQ:gvfs
#REQ:iso-codes
#REQ:libgudev
#REQ:pygtk
#REQ:xdg-utils


cd $SOURCE_DIR

NAME=gimp-gtk3
VERSION=2.99.1
URL=https://gitlab.gnome.org/GNOME/gimp/-/archive/gtk3-port/gimp-gtk3-port.tar.bz2
DESCRIPTION="The Gtk3 branch of the GNU Image Manipulation Program"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://gitlab.gnome.org/GNOME/gimp/-/archive/gtk3-port/gimp-gtk3-port.tar.bz2
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.5/gimp-gtk3.patch


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

patch -Np1 -i ../gimp-gtk3.patch
./autogen.sh --prefix=/usr --sysconfdir=/etc &&
make
sudo make install
sudo gtk-update-icon-cache &&
sudo update-desktop-database


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd