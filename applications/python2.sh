#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:sqlite


cd $SOURCE_DIR

NAME=python2
VERSION=2.7.18
URL=https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz
SECTION="Programming"
DESCRIPTION="The Python 2 package contains the Python development environment. It is useful for object-oriented programming, writing scripts, prototyping large programs or developing entire applications. This version is for backward compatibility with other dependent packages."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/Python-2.7.18-security_fixes-1.patch
wget -nc https://docs.python.org/ftp/python/doc/2.7.18/python-2.7.18-docs-html.tar.bz2


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


sed -i '/2to3/d' ./setup.py
patch -Np1 -i ../Python-2.7.18-security_fixes-1.patch &&
./configure --prefix=/usr                              \
            --enable-shared                            \
            --with-system-expat                        \
            --with-system-ffi                          \
            --enable-unicode=ucs4                     &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make altinstall                                &&
ln -s python2.7        /usr/bin/python2        &&
ln -s python2.7-config /usr/bin/python2-config &&
chmod -v 755 /usr/lib/libpython2.7.so.1.0
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -v -dm755 /usr/share/doc/python-2.7.18 &&

tar --strip-components=1                     \
    --no-same-owner                          \
    --directory /usr/share/doc/python-2.7.18 \
    -xvf ../python-2.7.18-docs-html.tar.bz2 &&

find /usr/share/doc/python-2.7.18 -type d -exec chmod 0755 {} \; &&
find /usr/share/doc/python-2.7.18 -type f -exec chmod 0644 {} \;
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
export PYTHONDOCS=/usr/share/doc/python-2.7.18
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd