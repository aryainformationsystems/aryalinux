#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gobject-introspection
#REQ:gtk3
#REQ:xserver-meta
#REQ:gdk-pixbuf
#REQ:glib2
#REQ:libsoup
#REQ:libpeas
#REQ:libxml2
#REQ:libtdb
#REQ:json-glib
#REQ:libmtp
#REQ:grilo
#REQ:libdmapsharing
#REQ:brasero
#REQ:libnotify
#REQ:libmusicbrainz5
#REQ:python-modules#pygobject2
#REQ:libgpod
#REQ:yelp


cd $SOURCE_DIR

NAME=rhythmbox
VERSION=3.4.4
URL=https://download-fallback.gnome.org/sources/rhythmbox/3.4/rhythmbox-3.4.4.tar.xz
SECTION="Audio Utilities"
DESCRIPTION="Rhythmbox is a free and open-source audio player that plays and organizes digital audio files. Rhythmbox is designed to work well under the GNOME desktop, however it can function on many desktop environments."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download-fallback.gnome.org/sources/rhythmbox/3.4/rhythmbox-3.4.4.tar.xz


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

./configure --prefix=/usr
make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd