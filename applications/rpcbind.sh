#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libtirpc


cd $SOURCE_DIR

NAME=rpcbind
VERSION=1.2.6
URL=https://downloads.sourceforge.net/rpcbind/rpcbind-1.2.6.tar.bz2
SECTION="Networking Programs"
DESCRIPTION="The rpcbind program is a replacement for portmap. It is required for import or export of Network File System (NFS) shared directories."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://downloads.sourceforge.net/rpcbind/rpcbind-1.2.6.tar.bz2
wget -nc https://raw.githubusercontent.com/aryainformationsystems/patches/1.0/rpcbind-1.2.6-vulnerability_fixes-1.patch


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


sed -i "/servname/s:rpcbind:sunrpc:" src/rpcbind.c
patch -Np1 -i ../rpcbind-1.2.6-vulnerability_fixes-1.patch &&

./configure --prefix=/usr                                  \
            --bindir=/usr/sbin                             \
            --with-rpcuser=root                            \
            --enable-warmstarts                            \
            --without-systemdsystemunitdir                 &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc https://ftp.osuosl.org/pub/blfs/conglomeration/blfs-bootscripts/blfs-bootscripts-20230101.tar.xz
tar xf blfs-bootscripts-20230101.tar.xz
cd blfs-bootscripts-20230101
sudo make install-rpcbind
popd
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd