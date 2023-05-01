#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=nodejs
VERSION=1.9.14

SECTION="Programming"
DESCRIPTION="Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine."


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

version="12.14.1"
wget https://nodejs.org/dist/v$version/node-v$version-linux-x64.tar.xz
dir=$(tar tf node-v$version-linux-x64.tar.xz | cut -d/ -f1 | uniq)
sudo tar xf node-v$version-linux-x64.tar.xz -C /opt/
sudo tee /etc/profile.d/nodejs.sh<<"EOF"
export PATH=$PATH:/opt/node-dir/bin
EOF

sudo sed -i "s@node-dir@$dir@g" /etc/profile.d/nodejs.sh


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd