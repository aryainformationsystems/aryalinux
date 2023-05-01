#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gst10-plugins-base
#REQ:tracker3
#REQ:exempi
#REQ:gexiv2
#REQ:ffmpeg
#REQ:giflib
#REQ:icu
#REQ:libexif
#REQ:libgrss
#REQ:libgxps
#REQ:poppler


cd $SOURCE_DIR

NAME=tracker3-miners
VERSION=3.2.1
URL=https://download.gnome.org/sources/tracker-miners/3.2/tracker-miners-3.2.1.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The Tracker-miners package contains a set of data extractors for Tracker."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/tracker-miners/3.2/tracker-miners-3.2.1.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/tracker-miners/3.2/tracker-miners-3.2.1.tar.xz


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

meson --prefix=/usr --buildtype=release -Dman=false .. &&
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