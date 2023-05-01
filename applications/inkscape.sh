#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:boost
#REQ:double-conversion
#REQ:gc
#REQ:gsl
#REQ:gtkmm3
#REQ:libsoup
#REQ:libxslt
#REQ:poppler
#REQ:popt
#REQ:wget
#REQ:imagemagick
#REQ:lcms2
#REQ:lcms
#REQ:libcanberra
#REQ:potrace
#REQ:python-modules#cachecontrol
#REQ:python-modules#cssselect
#REQ:python-modules#lxml
#REQ:python-modules#numpy
#REQ:python-modules#pyserial
#REQ:python-modules#scour


cd $SOURCE_DIR

NAME=inkscape
VERSION=1.2.2
URL=https://inkscape.org/gallery/item/37360/inkscape-1.2.2.tar.xz
SECTION="Other X-based Programs"
DESCRIPTION="Inkscape is a what you see is what you get Scalable Vector Graphics editor. It is useful for creating, viewing and changing SVG images."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://inkscape.org/gallery/item/37360/inkscape-1.2.2.tar.xz


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


mkdir build                       &&
cd    build                       &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      ..                          &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

gtk-update-icon-cache -qtf /usr/share/icons/hicolor &&
update-desktop-database -q


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd