#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib2
#REQ:libxml2
#REQ:gobject-introspection
#REQ:gtk3
#REQ:libsoup3
#REQ:totem-pl-parser
#REQ:vala


cd $SOURCE_DIR

NAME=grilo
VERSION=0.3.15
URL=https://download.gnome.org/sources/grilo/0.3/grilo-0.3.15.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="Grilo is a framework focused on making media discovery and browsing easy for applications and application developers."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/grilo/0.3/grilo-0.3.15.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/grilo/0.3/grilo-0.3.15.tar.xz


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
cd    build    &&

meson setup --prefix=/usr          \
            --buildtype=release    \
            -Denable-gtk-doc=false \
            ..                     &&
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