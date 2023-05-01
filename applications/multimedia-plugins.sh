#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:alsa
#REQ:alsa-lib
#REQ:alsa-plugins
#REQ:alsa-utils
#REQ:alsa-tools
#REQ:alsa-firmware
#REQ:alsa-oss
#REQ:audiofile
#REQ:faac
#REQ:faad2
#REQ:fdk-aac
#REQ:flac
#REQ:frei0r
#REQ:gavl
#REQ:gstreamer10
#REQ:gst10-plugins-base
#REQ:gst10-plugins-good
#REQ:gst10-plugins-bad
#REQ:gst10-plugins-ugly
#REQ:gst10-libav
#REQ:gstreamer10-vaapi
#REQ:id3lib
#REQ:liba52
#REQ:libass
#REQ:libcanberra
#REQ:libcddb
#REQ:libcdio
#REQ:libdiscid
#REQ:libdvdcss
#REQ:libdvdread
#REQ:libdvdnav
#REQ:libdv
#REQ:libmad
#REQ:libmpeg2
#REQ:libmusicbrainz
#REQ:libmusicbrainz5
#REQ:libogg
#REQ:libquicktime
#REQ:libsamplerate
#REQ:libsndfile
#REQ:libtheora
#REQ:libvorbis
#REQ:libvpx
#REQ:mlt
#REQ:opus
#REQ:pulseaudio
#REQ:sbc
#REQ:sdl
#REQ:sdl2
#REQ:sound-theme-freedesktop
#REQ:soundtouch
#REQ:speex
#REQ:taglib
#REQ:v4l-utils
#REQ:x264
#REQ:x265
#REQ:xine-lib
#REQ:xvid


cd $SOURCE_DIR

NAME=multimedia-plugins
VERSION=1.4

DESCRIPTION="A meta package which is a collection of audio and video codecs and plugins."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")



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




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd