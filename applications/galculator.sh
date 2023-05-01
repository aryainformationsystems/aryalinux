#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=galculator
VERSION=2.1.4
URL=http://galculator.mnim.org/downloads/galculator-2.1.4.tar.bz2
DESCRIPTION="galculator is a scientific calculator. It supports different number bases (DEC/HEX/OCT/BIN) and angles bases (DEG/RAD/GRAD) and features a wide range of mathematical (basic arithmetic operations, trigonometric functions, etc) and other useful functions (memory, etc) at the moment. galculator can be used in algebraic mode as well as in Reverse Polish Notation (RPN)."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc http://galculator.mnim.org/downloads/galculator-2.1.4.tar.bz2
wget -nc https://github.com/galculator/galculator/commit/501a9e3feeb2e56889c0ff98ab6d0ab20348ccd6.diff


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

patch -Np1 -i ../501a9e3feeb2e56889c0ff98ab6d0ab20348ccd6.diff &&
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make

sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd