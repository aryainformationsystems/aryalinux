#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=xfce4-whiskermenu-plugin
VERSION=2.3.4
URL=https://archive.xfce.org/src/panel-plugins/xfce4-whiskermenu-plugin/2.3/xfce4-whiskermenu-plugin-2.3.4.tar.bz2
DESCRIPTION="Whisker Menu is an alternate application launcher for Xfce. When you open it you are shown a list of applications you have marked as favorites. You can browse through all of your installed applications by clicking on the category buttons on the side. Top level categories make browsing fast, and simple to switch between. Additionally, Whisker Menu keeps a list of the last ten applications that you've launched from it."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://archive.xfce.org/src/panel-plugins/xfce4-whiskermenu-plugin/2.3/xfce4-whiskermenu-plugin-2.3.4.tar.bz2


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

mkdir -pv build
cd build

cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd