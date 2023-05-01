#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:json-glib
#REQ:libusb
#REQ:gobject-introspection
#REQ:umockdev
#REQ:usbutils
#REQ:vala


cd $SOURCE_DIR

NAME=libgusb
VERSION=0.4.5
URL=https://github.com/hughsie/libgusb/releases/download/0.4.5/libgusb-0.4.5.tar.xz
SECTION="General Libraries"
DESCRIPTION="The libgusb package contains the GObject wrappers for libusb-1.0 that makes it easy to do asynchronous control, bulk and interrupt transfers with proper cancellation and integration into a mainloop."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/hughsie/libgusb/releases/download/0.4.5/libgusb-0.4.5.tar.xz


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

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -Ddocs=false        &&
ninja
sed "/output: 'libgusb'/s/'\$/-0.4.5'/" -i ../docs/meson.build &&
meson configure -Ddocs=true                                    &&
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