#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gcr
#REQ:json-glib
#REQ:rest
#REQ:vala
#REQ:webkitgtk
#REQ:gobject-introspection


cd $SOURCE_DIR

NAME=gnome-online-accounts
VERSION=3.46.0
URL=https://download.gnome.org/sources/gnome-online-accounts/3.46/gnome-online-accounts-3.46.0.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="The GNOME Online Accounts package contains a framework used to access the user's online accounts."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/gnome-online-accounts/3.46/gnome-online-accounts-3.46.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/gnome-online-accounts/3.46/gnome-online-accounts-3.46.0.tar.xz


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

meson setup                                           \
      --prefix=/usr                                   \
      --buildtype=release                             \
      -Dkerberos=false                                \
      -Dgoogle_client_secret=5ntt6GbbkjnTVXx-MSxbmx5e \
      -Dgoogle_client_id=595013732528-llk8trb03f0ldpqq6nprjp1s79596646.apps.googleusercontent.com \
      .. &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd