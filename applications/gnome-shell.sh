#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:evolution-data-server
#REQ:gjs
#REQ:gnome-autoar
#REQ:gnome-control-center
#REQ:gtk4
#REQ:mutter
#REQ:sassc
#REQ:startup-notification
#REQ:systemd
#REQ:python-modules#asciidoc
#REQ:desktop-file-utils
#REQ:gnome-bluetooth
#REQ:gst10-plugins-base
#REQ:networkmanager
#REQ:adwaita-icon-theme
#REQ:dconf
#REQ:gdm
#REQ:gnome-backgrounds
#REQ:gnome-menus
#REQ:telepathy-mission-control


cd $SOURCE_DIR

NAME=gnome-shell
VERSION=41.4
URL=https://download.gnome.org/sources/gnome-shell/41/gnome-shell-41.4.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The GNOME Shell is the core user interface of the GNOME Desktop environment."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gnome-shell/41/gnome-shell-41.4.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gnome-shell/41/gnome-shell-41.4.tar.xz


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


sed -i '/i18n.merge_file/s/(.*/(/' $(find -name meson.build)
mkdir build &&
cd    build &&

meson --prefix=/usr --buildtype=release -Dtests=false .. &&
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