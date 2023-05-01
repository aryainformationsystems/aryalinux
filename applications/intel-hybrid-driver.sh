#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libcmrt


cd $SOURCE_DIR

NAME=intel-hybrid-driver
VERSION=1.0.2
URL=https://github.com/01org/intel-hybrid-driver/archive/1.0.2/intel-hybrid-driver-1.0.2.tar.gz
DESCRIPTION="VA driver for Intel G45 & HD Graphics family."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/01org/intel-hybrid-driver/archive/1.0.2/intel-hybrid-driver-1.0.2.tar.gz
wget -nc https://github.com/intel/intel-hybrid-driver/commit/821f871296629ffab451faea5134abf6f2d1166f.patch


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

patch -Np1 -i ../821f871296629ffab451faea5134abf6f2d1166f.patch &&
./autogen.sh --prefix=/usr --sysconfdir=/etc &&
make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd