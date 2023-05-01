#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:yasm
#REQ:ffmpeg
#REQ:gtk2
#REQ:libvdpau-va-gl


cd $SOURCE_DIR

NAME=mplayer
VERSION=202
URL=https://anduin.linuxfromscratch.org/BLFS/mplayer/mplayer-export-2021-07-29.tar.bz2
SECTION="Video Utilities"
DESCRIPTION="MPlayer is a powerful audio/video player controlled via the command line or a graphical interface that is able to play almost every popular audio and video file format. With supported video hardware and additional drivers, MPlayer can play video files without an X Window System installed."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://anduin.linuxfromscratch.org/BLFS/mplayer/mplayer-export-2021-07-29.tar.bz2
wget -nc http://www.mplayerhq.hu/MPlayer/skins/Clearlooks-2.0.tar.bz2
wget -nc ftp://ftp.mplayerhq.hu/MPlayer/skins/Clearlooks-2.0.tar.bz2
wget -nc https://www.mplayerhq.hu/MPlayer/skins/


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


./configure --prefix=/usr                 \
            --confdir=/etc/mplayer        \
            --enable-dynamic-plugins      \
            --disable-libmpeg2-internal   \
            --disable-ffmpeg_a            \
            --enable-menu                 \
            --enable-runtime-cpudetection \
            --enable-gui                  &&
make
make doc
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install  &&
ln -svf ../icons/hicolor/48x48/apps/mplayer.png \
        /usr/share/pixmaps/mplayer.png
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m755 -d /usr/share/doc/mplayer-export-2021-07-29 &&
install -v -m644    DOCS/HTML/en/* \
                    /usr/share/doc/mplayer-export-2021-07-29
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m644 etc/codecs.conf /etc/mplayer
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -m644 etc/*.conf /etc/mplayer
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
tar -xvf  ../Clearlooks-2.0.tar.bz2 \
    -C    /usr/share/mplayer/skins &&
ln  -sfvn Clearlooks /usr/share/mplayer/skins/default
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

gtk-update-icon-cache -qtf /usr/share/icons/hicolor &&
update-desktop-database -q


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd