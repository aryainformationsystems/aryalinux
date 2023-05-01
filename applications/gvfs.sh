#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:dbus
#REQ:glib2
#REQ:libusb
#REQ:libsecret
#REQ:gcr
#REQ:gtk3
#REQ:libcdio
#REQ:libgdata
#REQ:libgudev
#REQ:libsoup3
#REQ:elogind
#REQ:udisks2


cd $SOURCE_DIR

NAME=gvfs
VERSION=1.50.3
URL=https://download.gnome.org/sources/gvfs/1.50/gvfs-1.50.3.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The Gvfs package is a userspace virtual filesystem designed to work with the I/O abstractions of GLib's GIO library."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gvfs/1.50/gvfs-1.50.3.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gvfs/1.50/gvfs-1.50.3.tar.xz


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

meson setup               \
      --prefix=/usr       \
      --buildtype=release \
      -Dfuse=false        \
      -Dgphoto2=false     \
      -Dafc=false         \
      -Dbluray=false      \
      -Dnfs=false         \
      -Dmtp=false         \
      -Dsmb=false         \
      -Dtmpfilesdir=no    \
      -Ddnssd=false       \
      -Dgoa=false         \
      -Dgoogle=false      \
      -Dsystemduserunitdir=no .. &&
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
glib-compile-schemas /usr/share/glib-2.0/schemas
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd