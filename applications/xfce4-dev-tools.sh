#!/bin/bash
set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions

NAME="xfce4-dev-tools"
VERSION="4.14.0"
DESCRIPTION="xfce4-dev-tools provide an easy way to handle the setup and maintenance of a projects build framework. It's required to build Xfce applications from git."

cd $SOURCE_DIR

mkdir -pv $NAME
pushd $NAME

URL=https://git.xfce.org/xfce/xfce4-dev-tools/snapshot/xfce4-dev-tools-xfce-4.14.0.tar.gz
wget -nc $URL
TARBALL=`echo $URL | rev | cut -d/ -f1 | rev`
DIRECTORY=`tar -tf $TARBALL | sed -e 's@/.*@@' | uniq `

tar -xf $TARBALL

cd $DIRECTORY

./autogen.sh --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
./configure --prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static &&
make
sudo make install

cd $SOURCE_DIR
cleanup "$NAME" "$DIRECTORY"

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd