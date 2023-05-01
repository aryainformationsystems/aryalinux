#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:qt5
#REQ:frameworks5
#REQ:extra-cmake-modules
#REQ:udisks2
#REQ:upower
#REQ:polkit
#REQ:libexif
#REQ:pulseaudio
#REQ:xdg-user-dirs
#REQ:libstatgrab
#REQ:lm_sensors
#REQ:json-glib
#REQ:openbox
#REQ:media-player-info
#REQ:libdbusmenu-qt
#REQ:polkit-qt
#REQ:libfm
#REQ:menu-cache
#REQ:gtk2
#REQ:gtk3
#REQ:python-modules#pygobject2
#REQ:python-modules#pygobject3
#REQ:aryalinux-gtk-themes
#REQ:aryalinux-icons
#REQ:aryalinux-google-fonts
#REQ:aryalinux-wallpapers
#REQ:noto-fonts
#REQ:muparser
#REQ:libkscreen
#REQ:libconfig
#REQ:lightdm


cd $SOURCE_DIR

NAME=lxqt-desktop-environment
VERSION=0.11.0

SECTION="LXQT Desktop"
DESCRIPTION="LXQt is a lightweight Qt desktop environment. Historically, LXQt is the product of the merge between LXDE-Qt, an initial Qt flavour of LXDE, and Razor-qt, a project aiming to develop a Qt based desktop environment with similar objectives as the current LXQt."


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

git clone https://github.com/lxqt/lxqt.git
cd lxqt
git submodule init
git submodule update --remote --rebase
LXQT_PREFIX=/usr ./build_all.sh
cd ..
rm -rf lxqt


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd