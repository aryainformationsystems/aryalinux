#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:alsa-lib
#REQ:colord
#REQ:fontconfig
#REQ:gcr4
#REQ:geoclue2
#REQ:geocode-glib
#REQ:gnome-desktop
#REQ:lcms2
#REQ:libcanberra
#REQ:libgweather
#REQ:libnotify
#REQ:libwacom
#REQ:pulseaudio
#REQ:upower
#REQ:alsa
#REQ:cups
#REQ:networkmanager
#REQ:nss
#REQ:wayland
#REQ:blocaled


cd $SOURCE_DIR

NAME=gnome-settings-daemon
VERSION=43.0
URL=https://download.gnome.org/sources/gnome-settings-daemon/43/gnome-settings-daemon-43.0.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The GNOME Settings Daemon is responsible for setting various parameters of a GNOME Session and the applications that run under it."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gnome-settings-daemon/43/gnome-settings-daemon-43.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gnome-settings-daemon/43/gnome-settings-daemon-43.0.tar.xz


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


sed -e 's/libsystemd/libelogind/' \
    -i plugins/power/test.py
sed -e 's/(backlight->logind_proxy)/(0)/' \
    -i plugins/power/gsd-backlight.c
mkdir build &&
cd    build &&

meson setup --prefix=/usr       \
            --buildtype=release \
            -Dsystemd=false     \
            ..                  &&
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