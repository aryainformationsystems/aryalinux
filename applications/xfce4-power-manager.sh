#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libnotify
#REQ:upower
#REQ:xfce4-panel


cd $SOURCE_DIR

NAME=xfce4-power-manager
VERSION=4.18.1
URL=https://archive.xfce.org/src/xfce/xfce4-power-manager/4.18/xfce4-power-manager-4.18.1.tar.bz2
SECTION="Xfce Desktop"
DESCRIPTION="The Xfce4 Power Manager is a power manager for the Xfce desktop, Xfce power manager manages the power sources on the computer and the devices that can be controlled to reduce their power consumption (such as LCD brightness level or monitor sleep). In addition, Xfce4 Power Manager provides a set of freedesktop-compliant DBus interfaces to inform other applications about current power level so that they can adjust their power consumption."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://archive.xfce.org/src/xfce/xfce4-power-manager/4.18/xfce4-power-manager-4.18.1.tar.bz2


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


./configure --prefix=/usr --sysconfdir=/etc &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd