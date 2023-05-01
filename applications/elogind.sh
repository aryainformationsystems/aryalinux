#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:dbus
#REQ:linux-pam
#REQ:polkit
#REQ:docbook
#REQ:docbook-xsl
#REQ:libxslt


cd $SOURCE_DIR

NAME=elogind
VERSION=246.10
URL=https://github.com/elogind/elogind/archive/v246.10/elogind-246.10.tar.gz
SECTION="System Utilities"
DESCRIPTION="elogind is the systemd project's \"logind\", extracted to be a standalone daemon. It integrates with Linux-PAM-1.5.2 to track all the users logged in to a system, and whether they are logged in graphically, on the console, or remotely. Elogind exposes this information via the standard org.freedesktop.login1 D-Bus interface, and also through the file system using systemd's standard /run/systemd layout."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/elogind/elogind/archive/v246.10/elogind-246.10.tar.gz


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


sed -i '/Disable polkit/,+8 d' meson.build &&

sed '/request_name/i\
r = sd_bus_set_exit_on_disconnect(m->bus, true);\
if (r < 0)\
    return log_error_errno(r, "Failed to set exit on disconnect: %m");' \
    -i src/login/logind.c &&

mkdir build &&
cd    build &&

meson setup ..                    \
      --prefix=/usr               \
      --buildtype=release         \
      -Dman=auto                  \
      -Dcgroup-controller=elogind \
      -Ddbuspolicydir=/etc/dbus-1/system.d &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ninja install                                           &&
ln -sfv  libelogind.pc /usr/lib/pkgconfig/libsystemd.pc &&
ln -sfvn elogind /usr/include/systemd
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
sed -e '/\[Login\]/a KillUserProcesses=no' \
    -i /etc/elogind/logind.conf
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat >> /etc/pam.d/system-session << "EOF" &&
# Begin elogind addition

session  required    pam_loginuid.so
session  optional    pam_elogind.so

# End elogind addition
EOF
cat > /etc/pam.d/elogind-user << "EOF"
# Begin /etc/pam.d/elogind-user

account  required    pam_access.so
account  include     system-account

session  required    pam_env.so
session  required    pam_limits.so
session  required    pam_unix.so
session  required    pam_loginuid.so
session  optional    pam_keyinit.so force revoke
session  optional    pam_elogind.so

auth     required    pam_deny.so
password required    pam_deny.so

# End /etc/pam.d/elogind-user
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd