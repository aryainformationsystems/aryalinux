#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:adwaita-icon-theme
#REQ:exempi
#REQ:gnome-desktop
#REQ:itstool
#REQ:libjpeg
#REQ:libpeas
#REQ:shared-mime-info
#REQ:gobject-introspection
#REQ:lcms2
#REQ:libexif
#REQ:librsvg


cd $SOURCE_DIR

NAME=eog
VERSION=41.1
URL=https://download.gnome.org/sources/eog/41/eog-41.1.tar.xz
SECTION="GNOME Applications"
DESCRIPTION="EOG is an application used for viewing and cataloging image files on the GNOME Desktop. It also has basic editing capabilities."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/eog/41/eog-41.1.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/eog/41/eog-41.1.tar.xz


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
sed "/portal-gtk3/s@portal/@portal-gtk3/@" -i src/eog-util.c
mkdir build &&
cd    build &&

meson --prefix=/usr --buildtype=release -Dlibportal=false .. &&
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
update-desktop-database
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd