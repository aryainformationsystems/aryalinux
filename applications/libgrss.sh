#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libsoup
#REQ:gtk-doc


cd $SOURCE_DIR

NAME=libgrss
VERSION=0.7.0
URL=https://download.gnome.org/sources/libgrss/0.7/libgrss-0.7.0.tar.xz
SECTION="General Libraries"
DESCRIPTION="The libgrss package contains a library designed to manipulate RSS and Atom feeds."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/libgrss/0.7/libgrss-0.7.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/libgrss/0.7/libgrss-0.7.0.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/libgrss-0.7.0-bugfixes-2.patch


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


patch -Np1 -i ../libgrss-0.7.0-bugfixes-2.patch &&
autoreconf -fv &&
./configure --prefix=/usr --disable-static &&
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