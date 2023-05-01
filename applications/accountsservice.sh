#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:polkit
#REQ:gobject-introspection
#REQ:elogind
#REQ:vala
#REQ:vala


cd $SOURCE_DIR

NAME=accountsservice
VERSION=23.13.9
URL=https://www.freedesktop.org/software/accountsservice/accountsservice-23.13.9.tar.xz
SECTION="System Utilities"
DESCRIPTION="The AccountsService package provides a set of D-Bus interfaces for querying and manipulating user account information and an implementation of those interfaces based on the usermod(8), useradd(8) and userdel(8) commands."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.freedesktop.org/software/accountsservice/accountsservice-23.13.9.tar.xz


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


mv tests/dbusmock{,-tests}
sed -e '/accounts_service\.py/s/dbusmock/dbusmock-tests/' \
   -i tests/test-libaccountsservice.py
sed -i '/^SIMULATED_SYSTEM_LOCALE/s/en_IE.UTF-8/en_HK.iso88591/' tests/test-daemon.py
mkdir build &&
cd build &&

meson setup ..            \
      --prefix=/usr       \
      --buildtype=release \
      -Dadmin_group=adm   \
      -Delogind=true      \
      -Dsystemdsystemunitdir=no &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/polkit-1/rules.d/40-adm.rules << "EOF"
polkit.addAdminRule(function(action, subject) {
   return ["unix-group:adm"];
   });
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd