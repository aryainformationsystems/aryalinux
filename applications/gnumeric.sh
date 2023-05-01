#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:goffice010
#REQ:itstool
#REQ:adwaita-icon-theme
#REQ:oxygen-icons5
#REQ:gnome-icon-theme
#REQ:yelp


cd $SOURCE_DIR

NAME=gnumeric
VERSION=1.12.51
URL=https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.51.tar.xz
SECTION="Office Programs"
DESCRIPTION="The Gnumeric package contains a spreadsheet program which is useful for mathematical analysis."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gnumeric/1.12/gnumeric-1.12.51.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gnumeric/1.12/gnumeric-1.12.51.tar.xz


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


./configure --prefix=/usr  &&
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