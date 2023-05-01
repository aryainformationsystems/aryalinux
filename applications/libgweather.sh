#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:geocode-glib
#REQ:gtk3
#REQ:libsoup3
#REQ:python-modules#pygobject3
#REQ:gobject-introspection
#REQ:libxml2
#REQ:vala
#REQ:python-modules#pygobject3


cd $SOURCE_DIR

NAME=libgweather
VERSION=4.2.0
URL=https://download.gnome.org/sources/libgweather/4.2/libgweather-4.2.0.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The libgweather package is a library used to access weather information from online services for numerous locations."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/libgweather/4.2/libgweather-4.2.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/libgweather/4.2/libgweather-4.2.0.tar.xz


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

meson setup --prefix=/usr       \
            --buildtype=release \
            -Dgtk_doc=false     \
            ..                  &&
ninja
sed "s/libgweather_full_version/'libgweather-4.2.0'/" \
    -i ../doc/meson.build                             &&
meson configure -Dgtk_doc=true                        &&
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