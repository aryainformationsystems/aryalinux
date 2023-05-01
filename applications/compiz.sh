#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:glu
#REQ:python-modules#pygtk


cd $SOURCE_DIR

NAME=compiz
VERSION=0.8.17

DESCRIPTION="Compiz is an OpenGL compositing manager that uses GLX_EXT_texture_from_pixmap for binding redirected top-level windows to texture objects. It has a flexible plug-in system and it is designed to run well on most graphics hardware."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")



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

packages="compiz
compiz-bcop
compiz-plugins-main
compiz-plugins-extra
compiz-plugins-experimental
libcompizconfig
compizconfig-python
ccsm"

base_repo_url="https://github.com/compiz-reloaded/"
for package in $packages; do

git clone "$base_repo_url$package"
pushd $package
if "x$package" != "xccsm"; then

./autogen.sh --prefix=/usr &&
make
sudo make install

else:

python setup.py build --prefix=/usr &&
sudo python setup.py install --prefix=/usr

fi

popd
sudo rm -r $package
done


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd