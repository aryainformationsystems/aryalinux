#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:dbus
#REQ:glib2
#REQ:gsettings-desktop-schemas
#REQ:x7lib


cd $SOURCE_DIR

NAME=at-spi2-core
VERSION=2.48.0
URL=https://download.gnome.org/sources/at-spi2-core/2.48/at-spi2-core-2.48.0.tar.xz
SECTION="Graphical Environment Libraries"
DESCRIPTION="The At-Spi2 Core package contains a comprehensive accessibility framework for the Assistive Technologies available on the GNOME platform. This includes a set of interfaces which are implemented by other toolkits and applications."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/at-spi2-core/2.48/at-spi2-core-2.48.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/at-spi2-core/2.48/at-spi2-core-2.48.0.tar.xz


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

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -Dsystemd_user_dir=/tmp &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&
rm /tmp/at-spi-dbus-bus.service
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd