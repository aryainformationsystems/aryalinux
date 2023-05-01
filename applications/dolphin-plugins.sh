#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=dolphin-plugins
VERSION=21.04.1
URL=https://github.com/KDE/dolphin-plugins/archive/v21.04.1/dolphin-plugins-21.04.1.tar.gz
SECTION="KDE Frameworks 5 Based Applications"
DESCRIPTION="Plugins for the dolphin file manager"


mkdir -pv $NAME
pushd $NAME

wget -nc https://github.com/KDE/dolphin-plugins/archive/v21.04.1/dolphin-plugins-21.04.1.tar.gz

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

mkdir build
cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make -j$(nproc)

sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd