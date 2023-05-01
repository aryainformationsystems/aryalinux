#!/bin/bash

set -e
set +h

export XORG_PREFIX="/usr"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc \
    --localstatedir=/var --disable-static"

. /etc/alps/alps.conf
. /var/lib/alps/functions

SOURCE_ONLY=n
NAME="google-chrome"
VERSION="current"
DESCRIPTION="Google Chrome is a cross-platform web browser developed by Google. It was first released in 2008 for Microsoft Windows, and was later ported to Linux, macOS, iOS, and Android."

#REQ:git
#REQ:cups
#REQ:gconf

mkdir -pv $NAME
pushd $NAME

cd $SOURCE_DIR
wget -nc https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

mkdir -pv chrome-work-dir
mv google-chrome-stable_current_amd64.deb chrome-work-dir
pushd chrome-work-dir
ar -xv google-chrome-stable_current_amd64.deb
mkdir -pv chrome
tar xvf data.tar.xz -C chrome
cd chrome
sudo cp -prvf * /
popd

sudo update-desktop-database
sudo update-mime-database /usr/share/mime

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd