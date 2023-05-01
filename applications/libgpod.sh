#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libplist


cd $SOURCE_DIR

NAME=libgpod
VERSION=0.8.3
URL=https://sourceforge.net/projects/gtkpod/files/libgpod/libgpod-0.8/libgpod-0.8.3.tar.bz2
DESCRIPTION="libgpod is a shared library to access the contents of an iPod. This library is based on code used in the gtkpod project."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://sourceforge.net/projects/gtkpod/files/libgpod/libgpod-0.8/libgpod-0.8.3.tar.bz2
wget -nc https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/libgpod/trunk/0001-323-Segmentation-fault-when-opening-ipod.patch
wget -nc https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/libgpod/trunk/libgpod-0.8.2-pkgconfig_overlinking.patch
wget -nc https://raw.githubusercontent.com/archlinux/svntogit-packages/packages/libgpod/trunk/libgpod-fixswig.patch


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

sudo ln -svf /usr/lib/pkgconfig/libplist-2.0.pc /usr/lib/pkgconfig/libplist.pc &&
patch -Np1 -i ../0001-323-Segmentation-fault-when-opening-ipod.patch &&
patch -Np1 -i ../libgpod-0.8.2-pkgconfig_overlinking.patch &&
patch -Np1 -i ../libgpod-fixswig.patch &&
./configure --prefix=/usr &&
make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd