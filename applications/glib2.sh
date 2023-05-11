#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libxslt
#REQ:pcre2
#REQ:gobject-introspection


cd $SOURCE_DIR

NAME=glib2
VERSION=2.76.2
URL=https://download.gnome.org/sources/glib/2.76/glib-2.76.2.tar.xz
SECTION="General Libraries"
DESCRIPTION="The GLib package contains low-level libraries useful for providing data structure handling for C, portability wrappers and interfaces for such runtime functionality as an event loop, threads, dynamic loading and an object system."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/glib/2.76/glib-2.76.2.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/glib/2.76/glib-2.76.2.tar.xz
wget -nc https://raw.githubusercontent.com/aryainformationsystems/patches/1.0/glib-2.76.2-skip_warnings-1.patch


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


patch -Np1 -i ../glib-2.76.2-skip_warnings-1.patch
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
if [ -e /usr/include/glib-2.0 ]; then
    rm -rf /usr/include/glib-2.0.old &&
    mv -vf /usr/include/glib-2.0{,.old}
fi
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

mkdir build &&
cd    build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -Dman=true          &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install &&

mkdir -p /usr/share/doc/glib-2.76.2 &&
cp -r ../docs/reference/{gio,glib,gobject} /usr/share/doc/glib-2.76.2
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd