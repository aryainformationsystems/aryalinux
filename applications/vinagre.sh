#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk-vnc
#REQ:itstool
#REQ:libsecret
#REQ:telepathy-glib
#REQ:vala
#REQ:vte


cd $SOURCE_DIR

NAME=vinagre
VERSION=3.22.0
URL=https://download.gnome.org/sources/vinagre/3.22/vinagre-3.22.0.tar.xz
SECTION="GNOME Applications"
DESCRIPTION="Vinagre is a VNC client for the GNOME Desktop."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/vinagre/3.22/vinagre-3.22.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/vinagre/3.22/vinagre-3.22.0.tar.xz


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


sed -e '/_VinagreVnc/i gboolean scaling_command_line;' \
    -i plugins/vnc/vinagre-vnc-connection.c &&
sed -e '/scaling_/s/^/extern /' \
    -i plugins/vnc/vinagre-vnc-connection.h
./configure --prefix=/usr \
            --enable-compile-warnings=minimum &&
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