#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:aspell
#REQ:enchant
#REQ:gmime3
#REQ:gpgme
#REQ:gtk3
#REQ:libnotify
#REQ:mail


cd $SOURCE_DIR

NAME=balsa
VERSION=2.6.4
URL=https://pawsa.fedorapeople.org/balsa/balsa-2.6.4.tar.xz
SECTION="Other X-based Programs"
DESCRIPTION="The Balsa package contains a GNOME-2 based mail client."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://pawsa.fedorapeople.org/balsa/balsa-2.6.4.tar.xz
wget -nc https://raw.githubusercontent.com/aryainformationsystems/patches/1.0/balsa-2.6.4-upstream_fixes-2.patch


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


patch -Np1 -i ../balsa-2.6.4-upstream_fixes-2.patch
./configure --prefix=/usr            \
            --sysconfdir=/etc        \
            --localstatedir=/var/lib \
            --without-html-widget    &&
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