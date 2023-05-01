#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libassuan
#REQ:libgpg-error


cd $SOURCE_DIR

NAME=pinentry
VERSION=1.2.1
URL=https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.2.1.tar.bz2
SECTION="General Utilities"
DESCRIPTION="The PIN-Entry package contains a collection of simple PIN or pass-phrase entry dialogs which utilize the Assuan protocol as described by the Ägypten project. PIN-Entry programs are usually invoked by the gpg-agent daemon, but can be run from the command line as well. There are programs for various text-based and GUI environments, including interfaces designed for Ncurses (text-based), and for the common GTK and Qt toolkits."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.2.1.tar.bz2
wget -nc ftp://ftp.gnupg.org/gcrypt/pinentry/pinentry-1.2.1.tar.bz2


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


./configure --prefix=/usr --enable-pinentry-tty &&
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