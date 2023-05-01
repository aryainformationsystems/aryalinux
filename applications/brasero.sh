#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gst10-plugins-base
#REQ:itstool
#REQ:libcanberra
#REQ:libnotify
#REQ:gobject-introspection
#REQ:libburn
#REQ:libisoburn
#REQ:libisofs
#REQ:nautilus
#REQ:tracker3
#REQ:totem-pl-parser
#REQ:dvd-rw-tools
#REQ:gvfs


cd $SOURCE_DIR

NAME=brasero
VERSION=3.12.3
URL=https://download.gnome.org/sources/brasero/3.12/brasero-3.12.3.tar.xz
SECTION="GNOME Applications"
DESCRIPTION="Brasero is an application used to burn CD/DVD on the GNOME Desktop. It is designed to be as simple as possible and has some unique features that enable users to create their discs easily and quickly."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/brasero/3.12/brasero-3.12.3.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/brasero/3.12/brasero-3.12.3.tar.xz


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


./configure --prefix=/usr                \
            --enable-compile-warnings=no \
            --enable-cxx-warnings=no     &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd