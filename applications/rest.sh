#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:json-glib
#REQ:libsoup3
#REQ:make-ca
#REQ:gobject-introspection


cd $SOURCE_DIR

NAME=rest
VERSION=0.9.1
URL=https://download.gnome.org/sources/rest/0.9/rest-0.9.1.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The rest package contains a library that was designed to make it easier to access web services that claim to be \"RESTful\". It includes convenience wrappers for libsoup and libxml to ease remote use of the RESTful API."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/rest/0.9/rest-0.9.1.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/rest/0.9/rest-0.9.1.tar.xz


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
            -Dexamples=false    \
            -Dgtk_doc=false     \
            ..                  &&
ninja
sed "/output/s/librest-1.0/rest-0.9.1/" -i ../docs/meson.build &&
meson configure -Dgtk_doc=true                                 &&
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