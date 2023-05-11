#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libjpeg
#REQ:libpng
#REQ:libtiff
#REQ:sdl


cd $SOURCE_DIR

NAME=libwebp
VERSION=1.3.0
URL=http://downloads.webmproject.org/releases/webp/libwebp-1.3.0.tar.gz
SECTION="Graphics and Font Libraries"
DESCRIPTION="The libwebp package contains a library and support programs to encode and decode images in WebP format."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc http://downloads.webmproject.org/releases/webp/libwebp-1.3.0.tar.gz
wget -nc https://raw.githubusercontent.com/aryainformationsystems/patches/1.0/libwebp-1.3.0-upstream_fix-1.patch


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


patch -Np1 -i ../libwebp-1.3.0-upstream_fix-1.patch
./configure --prefix=/usr           \
            --enable-libwebpmux     \
            --enable-libwebpdemux   \
            --enable-libwebpdecoder \
            --enable-libwebpextras  \
            --enable-swap-16bit-csp \
            --disable-static        &&
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