#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=oxygen-fonts
VERSION=current
DESCRIPTION="The Oxygen typeface family is created as part of the KDE Project, a libre desktop for the GNU+Linux operating system. The design is optimised for the FreeType font rendering system and works well in all graphical user interfaces, desktops and devices."

mkdir -pv $NAME
pushd $NAME

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

sudo mkdir -pv /usr/share/fonts/aryalinux-google-fonts/sans/
wget "https://fonts.google.com/download?family=Oxygen" -O Oxygen.zip
wget "https://fonts.google.com/download?family=Oxygen%20Mono" -O Oxygen_Mono.zip
yes | sudo unzip Oxygen.zip -d /usr/share/fonts/aryalinux-google-fonts/sans/
yes | sudo unzip Oxygen_Mono.zip -d /usr/share/fonts/aryalinux-google-fonts/sans/

if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd