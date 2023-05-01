#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libsoup
#REQ:gnome-online-accounts
#REQ:gtk3
#REQ:json-glib
#REQ:vala
#REQ:gcr
#REQ:gobject-introspection


cd $SOURCE_DIR

NAME=libgdata
VERSION=0.18.1
URL=https://download.gnome.org/sources/libgdata/0.18/libgdata-0.18.1.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The libgdata package is a GLib-based library for accessing online service APIs using the GData protocol, most notably, Google's services. It provides APIs to access the common Google services and has full asynchronous support."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/libgdata/0.18/libgdata-0.18.1.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/libgdata/0.18/libgdata-0.18.1.tar.xz


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

meson setup --prefix=/usr              \
            --buildtype=release        \
            -Dgtk_doc=false            \
            -Dalways_build_tests=false \
            ..                         &&
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