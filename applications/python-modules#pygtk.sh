#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:python-modules#pygobject2
#REQ:python2
#REQ:at-spi2-core
#REQ:pango
#REQ:python-modules#pycairo2
#REQ:pango
#REQ:python-modules#pycairo2
#REQ:gtk2
#REQ:python-modules#pycairo2
#REQ:libglade


cd $SOURCE_DIR

NAME=python-modules#pygtk
VERSION=2.24.0
URL=https://download.gnome.org/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/pygtk/2.24/pygtk-2.24.0.tar.bz2


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

sed -i '1394,1402 d' pango.defs
./configure --prefix=/usr &&
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