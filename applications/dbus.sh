#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:x7lib


cd $SOURCE_DIR

NAME=dbus
VERSION=1.14.6
URL=https://dbus.freedesktop.org/releases/dbus/dbus-1.14.6.tar.xz
SECTION="System Utilities"
DESCRIPTION="D-Bus is a message bus system, a simple way for applications to talk to one another. D-Bus supplies both a system daemon (for events such as “new hardware device added” or “printer queue changed”) and a per-user-login-session daemon (for general IPC needs among user applications). Also, the message bus is built on top of a general one-to-one message passing framework, which can be used by any two applications to communicate directly (without going through the message bus daemon)."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://dbus.freedesktop.org/releases/dbus/dbus-1.14.6.tar.xz


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


./configure --prefix=/usr                        \
            --sysconfdir=/etc                    \
            --localstatedir=/var                 \
            --runstatedir=/run                   \
            --disable-doxygen-docs               \
            --disable-xml-docs                   \
            --disable-static                     \
            --with-systemduserunitdir=no         \
            --with-systemdsystemunitdir=no       \
            --docdir=/usr/share/doc/dbus-1.14.6  \
            --with-system-socket=/run/dbus/system_bus_socket &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
dbus-uuidgen --ensure
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/dbus-1/session-local.conf << "EOF"
<!DOCTYPE busconfig PUBLIC
 "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
<busconfig>

  <!-- Search for .service files in /usr/local -->
  <servicedir>/usr/local/share/dbus-1/services</servicedir>

</busconfig>
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf

pushd $SOURCE_DIR
wget -nc http://www.linuxfromscratch.org/blfs/downloads/9.0-systemd/blfs-systemd-units-20180105.tar.bz2
tar xf blfs-systemd-units-20180105.tar.bz2
cd blfs-systemd-units-20180105
sudo make install-dbus
popd
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd