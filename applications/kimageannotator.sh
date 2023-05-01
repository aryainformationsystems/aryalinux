#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:kcolorpicker


cd $SOURCE_DIR

NAME=kimageannotator
VERSION=0.6.1
URL=https://github.com/ksnip/kImageAnnotator/archive/refs/tags/v0.6.1/kImageAnnotator-0.6.1.tar.gz
SECTION="Graphical Environment Libraries"
DESCRIPTION="kImageAnnotator is a tool for annotating images."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/ksnip/kImageAnnotator/archive/refs/tags/v0.6.1/kImageAnnotator-0.6.1.tar.gz


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


mkdir build &&
cd    build &&

cmake -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      .. &&
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