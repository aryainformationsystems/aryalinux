#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libass
#REQ:fdk-aac
#REQ:freetype2
#REQ:lame
#REQ:libtheora
#REQ:libvorbis
#REQ:libvpx
#REQ:opus
#REQ:x264
#REQ:x265
#REQ:nasm
#REQ:yasm
#REQ:alsa-lib
#REQ:libva
#REQ:libvdpau
#REQ:sdl2


cd $SOURCE_DIR

NAME=ffmpeg
VERSION=4.4.1
URL=https://ffmpeg.org/releases/ffmpeg-4.4.1.tar.xz
SECTION="Video Utilities"
DESCRIPTION="FFmpeg is a solution to record, convert and stream audio and video. It is a very fast video and audio converter and it can also acquire from a live audio/video source. Designed to be intuitive, the command-line interface (ffmpeg) tries to figure out all the parameters, when possible. FFmpeg can also convert from any sample rate to any other, and resize video on the fly with a high quality polyphase filter. FFmpeg can use a Video4Linux compatible video source and any Open Sound System audio source."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://ffmpeg.org/releases/ffmpeg-4.4.1.tar.xz


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


sed -i 's/-lflite"/-lflite -lasound"/' configure &&

./configure --prefix=/usr        \
            --enable-gpl         \
            --enable-version3    \
            --enable-nonfree     \
            --disable-static     \
            --enable-shared      \
            --disable-debug      \
            --enable-avresample  \
            --enable-libass      \
            --enable-libfdk-aac  \
            --enable-libfreetype \
            --enable-libmp3lame  \
            --enable-libopus     \
            --enable-libtheora   \
            --enable-libvorbis   \
            --enable-libvpx      \
            --enable-libx264     \
            --enable-libx265     \
            --enable-openssl     \
            --docdir=/usr/share/doc/ffmpeg-4.4.1 &&

make &&

gcc tools/qt-faststart.c -o tools/qt-faststart
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&

install -v -m755    tools/qt-faststart /usr/bin &&
install -v -m755 -d           /usr/share/doc/ffmpeg-4.4.1 &&
install -v -m644    doc/*.txt /usr/share/doc/ffmpeg-4.4.1
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd