#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gnome-shell-extensions


cd $SOURCE_DIR

NAME=gnome-shell-coverflow-alt-tab
VERSION=36
URL=http://aryalinux.info/files/CoverflowAltTab-gnome-extension-36.tar.gz
DESCRIPTION="Replacement of Alt-Tab, iterates through windows in a cover-flow manner."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc http://aryalinux.info/files/CoverflowAltTab-gnome-extension-36.tar.gz


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

sudo mkdir -pv /usr/share/gnome-shell/extensions/$(basename $(pwd))
sudo cp -rvf * /usr/share/gnome-shell/extensions/$(basename $(pwd))
sudo chmod -R a+r /usr/share/gnome-shell/extensions/$(basename $(pwd))


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd