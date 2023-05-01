#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libevdev
#REQ:xorg-evdev-driver
#REQ:libinput
#REQ:xorg-libinput-driver
#REQ:xorg-synaptics-driver
#REQ:xorg-vmmouse-driver
#REQ:xorg-wacom-driver
#REQ:xorg-amdgpu-driver
#REQ:xorg-ati-driver
#REQ:xorg-fbdev-driver
#REQ:xorg-intel-driver
#REQ:intel-hybrid-driver
#REQ:xorg-nouveau-driver
#REQ:xorg-vmware-driver
#REQ:libva
#REQ:libvdpau
#REQ:libvdpau-va-gl


cd $SOURCE_DIR

NAME=x7driver
VERSION=1.0

DESCRIPTION="The Xorg Drivers page contains the instructions for building Xorg drivers that are necessary in order for Xorg Server to take advantage of the hardware that it is running on. At least one input and one video driver are required for Xorg Server to start."


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