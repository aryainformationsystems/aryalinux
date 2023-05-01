#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:dbus-glib
#REQ:libxslt
#REQ:gobject-introspection
#REQ:vala


cd $SOURCE_DIR

NAME=telepathy-glib
VERSION=0.24.2
URL=https://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.2.tar.gz
SECTION="General Libraries"
DESCRIPTION="The Telepathy GLib contains a library used by GLib based Telepathy components. Telepathy is a D-Bus framework for unifying real time communication, including instant messaging, voice calls and video calls. It abstracts differences between protocols to provide a unified interface for applications."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://telepathy.freedesktop.org/releases/telepathy-glib/telepathy-glib-0.24.2.tar.gz


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


sed -i 's%/usr/bin/python%&3%' tests/all-errors-documented.py
PYTHON=/usr/bin/python3 ./configure --prefix=/usr          \
                                    --enable-vala-bindings \
                                    --disable-static       &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd