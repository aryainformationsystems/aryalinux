#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=usb-modeswitch
VERSION=2.2.5
URL=http://www.draisberghof.de/usb_modeswitch/usb-modeswitch-2.2.5.tar.bz2
DESCRIPTION="mode switching tool for controlling 'flip flop' USB devices"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc http://www.draisberghof.de/usb_modeswitch/usb-modeswitch-2.2.5.tar.bz2
wget -nc http://www.draisberghof.de/usb_modeswitch/usb-modeswitch-data-20150627.tar.bz2


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

sudo make install-static

cd $SOURCE_DIR
rm -rf usb-modeswitch-2.2.5


tar -xf usb-modeswitch-data-20150627.tar.bz2
cd usb-modeswitch-data-20150627

sudo make install



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd