#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:adwaita-icon-theme
#REQ:evolution-data-server
#REQ:gnome-autoar
#REQ:itstool
#REQ:libgdata
#REQ:shared-mime-info
#REQ:webkitgtk
#REQ:bogofilter
#REQ:enchant
#REQ:gnome-desktop
#REQ:gspell
#REQ:highlight
#REQ:libcanberra
#REQ:libgweather
#REQ:libnotify
#REQ:openldap
#REQ:seahorse


cd $SOURCE_DIR

NAME=evolution
VERSION=3.42.4
URL=https://download.gnome.org/sources/evolution/3.42/evolution-3.42.4.tar.xz
SECTION="GNOME Applications"
DESCRIPTION="The Evolution package contains an integrated mail, calendar and address book suite designed for the GNOME environment."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/evolution/3.42/evolution-3.42.4.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/evolution/3.42/evolution-3.42.4.tar.xz


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

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DSYSCONF_INSTALL_DIR=/etc  \
      -DENABLE_INSTALLED_TESTS=ON \
      -DENABLE_PST_IMPORT=OFF     \
      -DENABLE_YTNEF=OFF          \
      -DENABLE_CONTACT_MAPS=OFF   \
      -G Ninja .. &&
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