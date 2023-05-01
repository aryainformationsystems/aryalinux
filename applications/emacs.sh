#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:harfbuzz
#REQ:giflib
#REQ:gnutls
#REQ:jansson
#REQ:libtiff


cd $SOURCE_DIR

NAME=emacs
VERSION=27.2
URL=https://ftp.gnu.org/gnu/emacs/emacs-27.2.tar.xz
SECTION="Editors"
DESCRIPTION="The Emacs package contains an extensible, customizable, self-documenting real-time display editor."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://ftp.gnu.org/gnu/emacs/emacs-27.2.tar.xz
wget -nc ftp://ftp.gnu.org/gnu/emacs/emacs-27.2.tar.xz


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


sed -e '/SIGSTKSZ/ s|^.*$|static max_align_t sigsegv_stack[\
   (64 * 1024 + sizeof (max_align_t) - 1) / sizeof (max_align_t)];|' \
    -i src/sysdep.c
./configure --prefix=/usr &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install &&
chown -v -R root:root /usr/share/emacs/27.2
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

gtk-update-icon-cache -qtf /usr/share/icons/hicolor


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd