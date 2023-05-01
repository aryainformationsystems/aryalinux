#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gcr
#REQ:libical
#REQ:libsecret
#REQ:nss
#REQ:sqlite
#REQ:gnome-online-accounts
#REQ:gobject-introspection
#REQ:gtk3
#REQ:icu
#REQ:libcanberra
#REQ:libgdata
#REQ:libgweather
#REQ:vala


cd $SOURCE_DIR

NAME=evolution-data-server
VERSION=3.42.4
URL=https://download.gnome.org/sources/evolution-data-server/3.42/evolution-data-server-3.42.4.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The Evolution Data Server package provides a unified backend for programs that work with contacts, tasks, and calendar information. It was originally developed for Evolution (hence the name), but is now used by other packages as well."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/evolution-data-server/3.42/evolution-data-server-3.42.4.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/evolution-data-server/3.42/evolution-data-server-3.42.4.tar.xz


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

cmake -DCMAKE_INSTALL_PREFIX=/usr   \
      -DSYSCONF_INSTALL_DIR=/etc    \
      -DENABLE_VALA_BINDINGS=ON     \
      -DENABLE_INSTALLED_TESTS=ON   \
      -DENABLE_GOOGLE=ON            \
      -DWITH_OPENLDAP=OFF           \
      -DWITH_KRB5=OFF               \
      -DENABLE_INTROSPECTION=ON     \
      -DENABLE_GTK_DOC=OFF          \
      -DWITH_LIBDB=OFF              \
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