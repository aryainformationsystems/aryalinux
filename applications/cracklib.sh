#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=cracklib
VERSION=2.9.11
URL=https://github.com/cracklib/cracklib/releases/download/v2.9.11/cracklib-2.9.11.tar.xz
SECTION="Security"
DESCRIPTION="The CrackLib package contains a library used to enforce strong passwords by comparing user selected passwords to words in chosen word lists."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/cracklib/cracklib/releases/download/v2.9.11/cracklib-2.9.11.tar.xz
wget -nc https://github.com/cracklib/cracklib/releases/download/v2.9.11/cracklib-words-2.9.11.xz
wget -nc https://github.com/cracklib/cracklib/releases/download/v2.9.7/cracklib-words-2.9.7.bz2


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


autoreconf -fiv &&

PYTHON=python3               \
./configure --prefix=/usr    \
            --disable-static \
            --with-default-dict=/usr/lib/cracklib/pw_dict &&
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
install -v -m644 -D    ../cracklib-words-2.9.11.xz \
                         /usr/share/dict/cracklib-words.xz    &&

unxz -v                  /usr/share/dict/cracklib-words.xz    &&
ln -v -sf cracklib-words /usr/share/dict/words                &&
echo $(hostname) >>      /usr/share/dict/cracklib-extra-words &&
install -v -m755 -d      /usr/lib/cracklib                    &&

create-cracklib-dict     /usr/share/dict/cracklib-words \
                         /usr/share/dict/cracklib-extra-words
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh




if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd