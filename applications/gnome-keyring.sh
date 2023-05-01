#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:dbus
#REQ:gcr
#REQ:linux-pam
#REQ:libxslt
#REQ:openssh


cd $SOURCE_DIR

NAME=gnome-keyring
VERSION=42.1
URL=https://download.gnome.org/sources/gnome-keyring/42/gnome-keyring-42.1.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The GNOME Keyring package contains a daemon that keeps passwords and other secrets for users."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gnome-keyring/42/gnome-keyring-42.1.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gnome-keyring/42/gnome-keyring-42.1.tar.xz


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


sed -i 's:"/desktop:"/org:' schema/*.xml &&

./configure --prefix=/usr     \
            --sysconfdir=/etc &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd