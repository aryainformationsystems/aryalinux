#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib-networking
#REQ:libpsl
#REQ:libxml2
#REQ:nghttp2
#REQ:sqlite
#REQ:gobject-introspection
#REQ:vala


cd $SOURCE_DIR

NAME=libsoup3
VERSION=3.4.1
URL=https://download.gnome.org/sources/libsoup/3.4/libsoup-3.4.1.tar.xz
SECTION="Networking Libraries"
DESCRIPTION="The libsoup3 is a HTTP client/server library for GNOME. It uses GObject and the GLib main loop to integrate with GNOME applications and it also has an asynchronous API for use in threaded applications."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/libsoup/3.4/libsoup-3.4.1.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/libsoup/3.4/libsoup-3.4.1.tar.xz


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


sed 's/apiversion/soup_version/' -i docs/reference/meson.build
mkdir build &&
cd    build &&

meson setup --prefix=/usr          \
            --buildtype=release    \
            -Dvapi=enabled         \
            -Dgssapi=disabled      \
            -Dsysprof=disabled     \
            --wrap-mode=nofallback \
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