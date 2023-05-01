#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:elogind
#REQ:gnome-desktop
#REQ:json-glib
#REQ:mesa
#REQ:upower


cd $SOURCE_DIR

NAME=gnome-session
VERSION=43.0
URL=https://download.gnome.org/sources/gnome-session/43/gnome-session-43.0.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The GNOME Session package contains the GNOME session manager."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gnome-session/43/gnome-session-43.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gnome-session/43/gnome-session-43.0.tar.xz


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


sed 's@/bin/sh@/bin/sh -l@' -i gnome-session/gnome-session.in
sed -i "/  systemd_dep/,+3d;/if enable_systemd/a \    systemd_userunitdir = '/tmp\'" meson.build
mkdir build &&
cd    build &&

meson setup --prefix=/usr           \
            --buildtype=release     \
            -Dsystemd_journal=false \
            ..                      &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mv -v /usr/share/doc/gnome-session{,-43.0}
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
rm -v /usr/share/xsessions/gnome.desktop &&
rm -v /usr/share/wayland-sessions/gnome.desktop
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
rm -rv /tmp/{*.d,*.target,*.service}
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
sed -e 's@^Exec=@&/usr/bin/dbus-run-session @' \
    -i /usr/share/wayland-sessions/gnome-wayland.desktop
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cat > ~/.xinitrc << "EOF"
dbus-run-session gnome-session
EOF

startx
XDG_SESSION_TYPE=wayland dbus-run-session gnome-session


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd