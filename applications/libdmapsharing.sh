#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=libdmapsharing
VERSION=3.9.4
URL=https://github.com/GNOME/libdmapsharing/archive/LIBDMAPSHARING_3_9_4.tar.gz
DESCRIPTION="Libdmapsharing is a library which allows programs to access, share and control the playback of media content using DMAP (DAAP, DPAP & DACP). Libdmapsharing also detects audio AirPlay services; coupled with the AirPlay support in PulseAudio or GStreamer, this can allow an application to stream audio to an AirPlay device."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/GNOME/libdmapsharing/archive/LIBDMAPSHARING_3_9_4.tar.gz


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

./autogen.sh --disable-tests --prefix=/usr &&
make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd