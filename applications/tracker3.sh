#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:json-glib
#REQ:libseccomp
#REQ:vala
#REQ:gobject-introspection
#REQ:icu
#REQ:libsoup3
#REQ:python-modules#pygobject3
#REQ:sqlite
#REQ:tracker3-miners


cd $SOURCE_DIR

NAME=tracker3
VERSION=3.4.2
URL=https://download.gnome.org/sources/tracker/3.4/tracker-3.4.2.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="Tracker is the file indexing and search provider used in the GNOME desktop environment."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/tracker/3.4/tracker-3.4.2.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/tracker/3.4/tracker-3.4.2.tar.xz


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

meson setup --prefix=/usr                 \
            --buildtype=release           \
            -Ddocs=false                  \
            -Dman=false                   \
            -Dsystemd_user_services=false \
            ..                            &&
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