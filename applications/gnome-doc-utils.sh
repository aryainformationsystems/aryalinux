#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gnome-desktop-environment


cd $SOURCE_DIR

NAME=gnome-doc-utils
VERSION=0.20.10
URL=https://ftp.gnome.org/pub/GNOME/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.10.tar.xz
SECTION="Others"
DESCRIPTION="The GNOME Doc Utils package is a collection of documentation utilities for the GNOME project. Notably, it contains utilities for building documentation and all auxiliary files in your source tree, and it contains the DocBook XSLT stylesheets that were once distributed with Yelp. Starting with GNOME 2.8, Yelp requires GNOME Doc Utils for the XSLT. Starting with GNOME 2.12, many of the core GNOME packages require GNOME Doc Utils."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://ftp.gnome.org/pub/GNOME/sources/gnome-doc-utils/0.20/gnome-doc-utils-0.20.10.tar.xz


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

./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd