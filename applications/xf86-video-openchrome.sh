#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=xf86-video-openchrome
VERSION=0.6.0
URL=https://www.x.org/archive/individual/driver/xf86-video-openchrome-0.6.0.tar.gz
DESCRIPTION="Userspace openchrome video graphics driver"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.x.org/archive/individual/driver/xf86-video-openchrome-0.6.0.tar.gz
wget -nc https://gitweb.gentoo.org/repo/gentoo.git/plain/x11-drivers/xf86-video-openchrome/files/xf86-video-openchrome-0.6.0-fno-common.patch


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

patch -Np1 -i ../xf86-video-openchrome-0.6.0-fno-common.patch
./configure $XORG_CONFIG &&
make -j$(nproc)
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd