#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk3
#REQ:libnma
#REQ:libnotify
#REQ:libsecret
#REQ:gobject-introspection
#REQ:modemmanager
#REQ:polkit
#REQ:polkit-gnome
#REQ:libnma


cd $SOURCE_DIR

NAME=network-manager-applet
VERSION=1.24.0
URL=https://download.gnome.org/sources/network-manager-applet/1.24/network-manager-applet-1.24.0.tar.xz
SECTION="Networking Utilities"
DESCRIPTION="The NetworkManager Applet provides a tool and a panel applet used to configure wired and wireless network connections through GUI. It's designed for use with any desktop environment that uses GTK+, such as Xfce and LXDE."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/network-manager-applet/1.24/network-manager-applet-1.24.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/network-manager-applet/1.24/network-manager-applet-1.24.0.tar.xz


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


sed -i '/merge_file/{n;d}' meson.build
mkdir build &&
cd    build &&

meson --prefix=/usr       \
      --buildtype=release \
      -Dappindicator=no   \
      -Dselinux=false     &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd