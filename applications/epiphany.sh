#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gcr
#REQ:gnome-desktop
#REQ:iso-codes
#REQ:json-glib
#REQ:libnotify
#REQ:libportal
#REQ:nettle
#REQ:webkitgtk
#REQ:libdazzle
#REQ:libhandy1


cd $SOURCE_DIR

NAME=epiphany
VERSION=41.3
URL=https://download.gnome.org/sources/epiphany/41/epiphany-41.3.tar.xz
SECTION="Graphical Web Browsers"
DESCRIPTION="Epiphany is a simple yet powerful GNOME web browser targeted at non-technical users. Its principles are simplicity and standards compliance."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/epiphany/41/epiphany-41.3.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/epiphany/41/epiphany-41.3.tar.xz


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


sed -i '/merge_file/{n;d}' data/meson.build
sed "/dependency/s@'libportal'@'libportal-gtk3'@" -i meson.build
sed "/portal-gtk3/s@portal/@portal-gtk3/@" -i lib/ephy-flatpak-utils.c
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

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
glib-compile-schemas /usr/share/glib-2.0/schemas
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd