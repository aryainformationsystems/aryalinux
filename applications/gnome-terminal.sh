#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:dconf
#REQ:gsettings-desktop-schemas
#REQ:itstool
#REQ:pcre2
#REQ:vte
#REQ:gnome-shell
#REQ:nautilus


cd $SOURCE_DIR

NAME=gnome-terminal
VERSION=3.46.8
URL=https://gitlab.gnome.org/GNOME/gnome-terminal/-/archive/3.46.8/gnome-terminal-3.46.8.tar.gz
SECTION="GNOME Applications"
DESCRIPTION="The GNOME Terminal package contains the terminal emulator for GNOME Desktop."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://gitlab.gnome.org/GNOME/gnome-terminal/-/archive/3.46.8/gnome-terminal-3.46.8.tar.gz


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


sed -i -r 's:"(/system):"/org/gnome\1:g' src/external.gschema.xml
mkdir build &&
cd    build &&

meson setup --prefix=/usr --buildtype=release .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&
rm -v /usr/lib/systemd/user/gnome-terminal-server.service
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd