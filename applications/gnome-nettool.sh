#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk3
#REQ:itstool
#REQ:libgtop


cd $SOURCE_DIR

NAME=gnome-nettool
VERSION=3.8.1
URL=https://download.gnome.org/sources/gnome-nettool/3.8/gnome-nettool-3.8.1.tar.xz
SECTION="GNOME Applications"
DESCRIPTION="The GNOME Nettool package is a network information tool which provides GUI interface for some of the most common command line network tools."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gnome-nettool/3.8/gnome-nettool-3.8.1.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gnome-nettool/3.8/gnome-nettool-3.8.1.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/gnome-nettool-3.8.1-ping_and_netstat_fixes-1.patch


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


patch -Np1 -i ../gnome-nettool-3.8.1-ping_and_netstat_fixes-1.patch
./configure --prefix=/usr &&
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