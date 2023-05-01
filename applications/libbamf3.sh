#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libwnck
#REQ:libgtop
#REQ:libxslt
#REQ:python-modules#libxml2py2


cd $SOURCE_DIR

NAME=libbamf3
VERSION=0.5.4
URL=https://launchpad.net/bamf/0.5/0.5.4/+download/bamf-0.5.4.tar.gz
SECTION="Others"
DESCRIPTION="Bamf matches application windows to desktop files. It removes the headache of applications matching into a simple DBus daemon and C wrapper library. It currently features application matching at amazing levels of accuracy (covering nearly every corner case)."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://launchpad.net/bamf/0.5/0.5.4/+download/bamf-0.5.4.tar.gz


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

./configure --prefix=/usr &&
make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd