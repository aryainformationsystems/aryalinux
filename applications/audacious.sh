#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk2
#REQ:libxml2
#REQ:mpg123
#REQ:neon


cd $SOURCE_DIR

NAME=audacious
VERSION=4.1
URL=https://distfiles.audacious-media-player.org/audacious-4.1.tar.bz2
SECTION="Audio Utilities"
DESCRIPTION="Audacious is an audio player."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://distfiles.audacious-media-player.org/audacious-4.1.tar.bz2
wget -nc https://distfiles.audacious-media-player.org/audacious-plugins-4.1.tar.bz2


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


TPUT=/bin/true ./configure --prefix=/usr \
                           --with-buildstamp="BLFS" &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

tar -xf ../audacious-plugins-4.1.tar.bz2                &&
cd audacious-plugins-4.1                                &&
TPUT=/bin/true ./configure --prefix=/usr --disable-wavpack &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cp -v /usr/share/applications/audacious{,-qt}.desktop &&

sed -e '/^Name/ s/$/ Qt/' \
    -e '/Exec=/ s/audacious/& --qt/' \
    -i /usr/share/applications/audacious-qt.desktop
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd