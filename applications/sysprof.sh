#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:desktop-file-utils
#REQ:gtk4
#REQ:itstool
#REQ:json-glib
#REQ:libadwaita
#REQ:libdazzle
#REQ:libunwind
#REQ:polkit
#REQ:elogind
#REQ:json-glib


cd $SOURCE_DIR

NAME=sysprof
VERSION=3.48.0
URL=https://download.gnome.org/sources/sysprof/3.48/sysprof-3.48.0.tar.xz
SECTION="Programming"
DESCRIPTION="The sysprof package contains a statistical and system-wide profiler for Linux."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/sysprof/3.48/sysprof-3.48.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/sysprof/3.48/sysprof-3.48.0.tar.xz


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

meson setup --prefix=/usr         \
            --buildtype=release   \
            -Dsystemdunitdir=/tmp \
            ..                    &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&
rm -v /tmp/*.service
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd