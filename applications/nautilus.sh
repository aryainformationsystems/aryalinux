#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:bubblewrap
#REQ:gexiv2
#REQ:gnome-autoar
#REQ:gnome-desktop
#REQ:libhandy1
#REQ:libnotify
#REQ:libseccomp
#REQ:tracker3-miners
#REQ:desktop-file-utils
#REQ:exempi
#REQ:gobject-introspection
#REQ:gst10-plugins-base
#REQ:libexif
#REQ:libportal
#REQ:adwaita-icon-theme
#REQ:gvfs


cd $SOURCE_DIR

NAME=nautilus
VERSION=41.2
URL=https://download.gnome.org/sources/nautilus/41/nautilus-41.2.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The Nautilus package contains the GNOME file manager."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/nautilus/41/nautilus-41.2.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/nautilus/41/nautilus-41.2.tar.xz


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


sed "/dependency/s@'libportal'@'libportal-gtk3'@" -i meson.build
sed "/portal-gtk3/s@portal/@portal-gtk3/@" -i src/nautilus-files-view.c
mkdir build &&
cd    build &&

meson --prefix=/usr       \
      --buildtype=release \
      -Dselinux=false     \
      -Dpackagekit=false  \
      .. &&

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