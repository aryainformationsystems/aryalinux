#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:python-dependencies#alabaster
#REQ:python-dependencies#babel
#REQ:python-modules#docutils
#REQ:python-dependencies#imagesize
#REQ:python-modules#jinja2
#REQ:python-modules#packaging
#REQ:python-modules#pygments
#REQ:python-modules#requests
#REQ:python-dependencies#snowballstemmer
#REQ:python-dependencies#sc-applehelp
#REQ:python-dependencies#sc-devhelp
#REQ:python-dependencies#sc-htmlhelp
#REQ:python-dependencies#sc-jsmath
#REQ:python-dependencies#sc-qthelp
#REQ:python-dependencies#sc-serializinghtml


cd $SOURCE_DIR

NAME=python-modules#sphinx
VERSION=6.2.1
URL=https://github.com/sphinx-doc/sphinx/archive/v6.2.1/sphinx-6.2.1.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/sphinx-doc/sphinx/archive/v6.2.1/sphinx-6.2.1.tar.gz


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
pip3 install --no-index --find-links dist --no-cache-dir --no-user sphinx
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

python3 -m venv --system-site-packages testenv &&
source testenv/bin/activate                    &&
pip3 install html5lib filelock                 &&
python3 /usr/bin/pytest
deactivate


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd