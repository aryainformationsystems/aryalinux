#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:curl


cd $SOURCE_DIR

NAME=liboauth
VERSION=1.0.3
URL=https://downloads.sourceforge.net/liboauth/liboauth-1.0.3.tar.gz
SECTION="Security"
DESCRIPTION="liboauth is a collection of POSIX-C functions implementing the OAuth Core RFC 5849 standard. Liboauth provides functions to escape and encode parameters according to OAuth specification and offers high-level functionality to sign requests or verify OAuth signatures as well as perform HTTP requests."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://downloads.sourceforge.net/liboauth/liboauth-1.0.3.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/liboauth-1.0.3-openssl-1.1.0-3.patch


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


patch -Np1 -i ../liboauth-1.0.3-openssl-1.1.0-3.patch
./configure --prefix=/usr --disable-static &&
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