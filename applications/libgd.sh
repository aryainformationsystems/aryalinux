#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libgtop


cd $SOURCE_DIR

NAME=libgd
VERSION=2.2.5
URL=https://github.com/libgd/libgd/releases/download/gd-2.2.5/libgd-2.2.5.tar.xz
DESCRIPTION="Perl module to create barcode images"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/libgd/libgd/releases/download/gd-2.2.5/libgd-2.2.5.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/2f08f4d7e5746ea6d66db0c22fa58ff9c18ca385/libgd-2.2.5-find-freetype2.patch


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

patch -Np1 -i ../libgd-2.2.5-find-freetype2.patch &&
mkdir -pv build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_FONTCONFIG=1 -DENABLE_FREETYPE=1 -DENABLE_ICONV=1 -DENABLE_JPEG=1 -DENABLE_LIQ=0 -DENABLE_PNG=1 -DENABLE_TIFF=1 -DENABLE_WEBP=1 -DENABLE_XPM=1 .. &&
make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd