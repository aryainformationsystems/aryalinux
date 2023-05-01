#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:babl
#REQ:json-glib
#REQ:libjpeg
#REQ:libpng
#REQ:gobject-introspection
#REQ:graphviz
#REQ:python-modules#pygments
#REQ:python-modules#pygobject3


cd $SOURCE_DIR

NAME=gegl
VERSION=0.4.34
URL=https://download.gimp.org/pub/gegl/0.4/gegl-0.4.34.tar.xz
SECTION="Graphics and Font Libraries"
DESCRIPTION="This package provides the GEneric Graphics Library, which is a graph based image processing format."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gimp.org/pub/gegl/0.4/gegl-0.4.34.tar.xz


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


rm -f /usr/lib/gegl-0.4/vector-fill.so
mkdir build &&
cd    build &&

meson --prefix=/usr --buildtype=release .. &&
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