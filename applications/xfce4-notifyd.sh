#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libnotify
#REQ:libxfce4ui
#REQ:xfce4-dev-tools
#REQ:xfce4-panel


cd $SOURCE_DIR

NAME=xfce4-notifyd
VERSION=0.8.2
URL=https://archive.xfce.org/src/apps/xfce4-notifyd/0.8/xfce4-notifyd-0.8.2.tar.bz2
SECTION="Xfce Applications"
DESCRIPTION="The Xfce4 Notification Daemon is a small program that implements the \"server-side\" portion of the Freedesktop desktop notifications specification. Applications that wish to pop up a notification bubble in a standard way can use Xfce4-Notifyd to do so by sending standard messages over D-Bus using the org.freedesktop.Notifications interface."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://archive.xfce.org/src/apps/xfce4-notifyd/0.8/xfce4-notifyd-0.8.2.tar.bz2


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

notify-send -i info Information "Hi ${USER}, This is a Test"


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd