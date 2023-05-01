#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=hardinfo
VERSION=0.5.1

DESCRIPTION="HardInfo is a small application that displays information about your hardware and operating system. Currently it knows about PCI, ISA PnP, USB, IDE, SCSI, Serial and parallel port devices."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")



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

sudo rm -rf hardinfo

git clone https://github.com/lpereira/hardinfo.git
cd hardinfo
mkdir -pv build
cd build
cmake -DCMAKE_INSTALL_PREFIX=/usr ..
make
sudo make install

cd ..
sudo rm -rf hardinfo


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd