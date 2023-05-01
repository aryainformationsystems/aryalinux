#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib2
#REQ:gobject-introspection
#REQ:libgcrypt
#REQ:vala
#REQ:gnome-keyring


cd $SOURCE_DIR

NAME=libsecret
VERSION=0.20.5
URL=https://download.gnome.org/sources/libsecret/0.20/libsecret-0.20.5.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The libsecret package contains a GObject based library for accessing the Secret Service API."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/libsecret/0.20/libsecret-0.20.5.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/libsecret/0.20/libsecret-0.20.5.tar.xz


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


mkdir bld &&
cd bld &&

meson setup --prefix=/usr       \
            --buildtype=release \
            -Dgtk_doc=false     \
            ..                  &&
ninja
sed "s/api_version_major/'0.20.5'/"            \
    -i ../docs/reference/libsecret/meson.build &&
meson configure -Dgtk_doc=true                 &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

mv -v /usr/share/doc/libsecret-{1,0.20.5}


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd