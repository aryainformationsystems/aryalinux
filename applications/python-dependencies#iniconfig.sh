#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:python-dependencies#hatch-vcs


cd $SOURCE_DIR

NAME=python-dependencies#iniconfig
VERSION=2.0.0
URL=https://files.pythonhosted.org/packages/source/i/iniconfig/iniconfig-2.0.0.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://files.pythonhosted.org/packages/source/i/iniconfig/iniconfig-2.0.0.tar.gz


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

pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-cache-dir --no-user iniconfig
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd