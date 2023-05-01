#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:python-modules#sphinx
#REQ:python-dependencies#sc-jquery


cd $SOURCE_DIR

NAME=python-modules#sphinx_rtd_theme
VERSION=1.2.0
URL=https://files.pythonhosted.org/packages/source/s/sphinx_rtd_theme/sphinx_rtd_theme-1.2.0.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://files.pythonhosted.org/packages/source/s/sphinx_rtd_theme/sphinx_rtd_theme-1.2.0.tar.gz


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

sed -e s/0.19/0.20/ \
    -i setup.cfg
pip3 wheel -w dist --no-build-isolation --no-deps $PWD
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
pip3 install --no-index --find-links dist --no-cache-dir --no-user sphinx_rtd_theme
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

python3 -m venv --system-site-packages testenv &&
source testenv/bin/activate                    &&
pip3 install readthedocs-sphinx-ext            &&
python3 /usr/bin/pytest
deactivate


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd