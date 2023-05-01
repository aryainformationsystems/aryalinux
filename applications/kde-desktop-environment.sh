#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gtk2
#REQ:gtk3
#REQ:gconf
#REQ:pulseaudio
#REQ:qt5
#REQ:extra-cmake-modules
#REQ:phonon
#REQ:phonon-backend-gstreamer
#REQ:polkit-qt
#REQ:libdbusmenu-qt
#REQ:frameworks5
#REQ:fftw
#REQ:plasma-all
#REQ:ark5
#REQ:kdenlive
#REQ:kmix5
#REQ:khelpcenter
#REQ:konsole5
#REQ:lightdm
#REQ:libnotify
#REQ:udisks2
#REQ:dolphin
#REQ:dolphin-plugins
#REQ:kcalc
#REQ:gwenview5
#REQ:aryalinux-gtk-themes
#REQ:aryalinux-google-fonts
#REQ:aryalinux-wallpapers
#REQ:aryalinux-icons


cd $SOURCE_DIR

NAME=kde-desktop-environment
VERSION=5.53

SECTION="KDE Plasma 5"
DESCRIPTION="Plasma is KDE's desktop environment. Simple by default, powerful when needed."


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

sudo ln -svf /usr/lib /usr/lib64


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd