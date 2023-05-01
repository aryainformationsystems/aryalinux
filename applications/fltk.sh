#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:x7lib
#REQ:hicolor-icon-theme
#REQ:libjpeg
#REQ:libpng


cd $SOURCE_DIR

NAME=fltk
VERSION=1.3.
URL=https://fltk.org/pub/fltk/1.3.8/fltk-1.3.8-source.tar.gz
SECTION="Graphical Environment Libraries"
DESCRIPTION="FLTK (pronounced \"fulltick\") is a cross-platform C++ GUI toolkit. FLTK provides modern GUI functionality and supports 3D graphics via OpenGL and its built-in GLUT emulation libraries used for creating graphical user interfaces for applications."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://fltk.org/pub/fltk/1.3.8/fltk-1.3.8-source.tar.gz


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


sed -i -e '/cat./d' documentation/Makefile       &&

./configure --prefix=/usr    \
            --enable-shared  &&
make
make -C documentation html
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make docdir=/usr/share/doc/fltk-1.3.8 install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make -C test          docdir=/usr/share/doc/fltk-1.3.8 install-linux &&
make -C documentation docdir=/usr/share/doc/fltk-1.3.8 install-linux
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd