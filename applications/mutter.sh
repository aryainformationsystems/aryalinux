#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gnome-settings-daemon
#REQ:graphene
#REQ:libxcvt
#REQ:libxkbcommon
#REQ:pipewire
#REQ:desktop-file-utils
#REQ:gobject-introspection
#REQ:startup-notification
#REQ:sysprof
#REQ:libinput
#REQ:wayland
#REQ:wayland-protocols
#REQ:xwayland
#REQ:gtk3
#REQ:blocaled
#REQ:graphene
#REQ:pipewire


cd $SOURCE_DIR

NAME=mutter
VERSION=43.3
URL=https://download.gnome.org/sources/mutter/43/mutter-43.3.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="Mutter is the window manager for GNOME. It is not invoked directly, but from GNOME Session (on a machine with a hardware accelerated video driver)."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/mutter/43/mutter-43.3.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/mutter/43/mutter-43.3.tar.xz


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


mkdir build &&
cd    build &&

meson setup --prefix=/usr              \
            --buildtype=debugoptimized \
            -Dtests=false              \
            ..                         &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

mutter --wayland -- vte-2.91
MUTTER_DEBUG_DUMMY_MODE_SPECS=1920x1080 mutter --wayland --nested -- vte-2.91


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd