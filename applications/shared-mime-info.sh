#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glib2
#REQ:itstool
#REQ:libxml2
#REQ:xmlto


cd $SOURCE_DIR

NAME=shared-mime-info
VERSION=2.1
URL=https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.1/shared-mime-info-2.1.tar.gz
SECTION="General Utilities"
DESCRIPTION="The Shared Mime Info package contains a MIME database. This allows central updates of MIME information for all supporting applications."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/2.1/shared-mime-info-2.1.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/shared-mime-info-2.1-meson_0.60_fix-1.patch
wget -nc https://anduin.linuxfromscratch.org/BLFS/xdgmime/xdgmime.tar.xz


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


tar -xf ../xdgmime.tar.xz &&
make -C xdgmime
patch -p1 -i ../shared-mime-info-2.1-meson_0.60_fix-1.patch
mkdir build &&
cd    build &&

meson --prefix=/usr --buildtype=release -Dupdate-mimedb=true .. &&
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