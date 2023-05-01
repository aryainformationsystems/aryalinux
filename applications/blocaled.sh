#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:polkit
#REQ:libdaemon


cd $SOURCE_DIR

NAME=blocaled
VERSION=0.4
URL=https://github.com/lfs-book/blocaled/releases/download/v0.4/blocaled-0.4.tar.xz
SECTION="System Utilities"
DESCRIPTION="blocaled is an implementation of the org.freedesktop.locale1 D-Bus protocol, which normally comes with systemd. It is needed by the GNOME desktop."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/lfs-book/blocaled/releases/download/v0.4/blocaled-0.4.tar.xz


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


./configure --prefix=/usr --sysconfdir=/etc &&
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
cat > /etc/profile.d/i18n.sh << "EOF"
# Begin /etc/profile.d/i18n.sh

if [ -r /etc/locale.conf ]; then source /etc/locale.conf; fi

if [ -n "$LANG" ];              then export LANG; fi
if [ -n "$LC_TYPE" ];           then export LC_TYPE; fi
if [ -n "$LC_NUMERIC" ];        then export LC_NUMERIC; fi
if [ -n "$LC_TIME" ];           then export LC_TIME; fi
if [ -n "$LC_COLLATE" ];        then export LC_COLLATE; fi
if [ -n "$LC_MONETARY" ];       then export LC_MONETARY; fi
if [ -n "$LC_MESSAGES" ];       then export LC_MESSAGES; fi
if [ -n "$LC_PAPER" ];          then export LC_PAPER; fi
if [ -n "$LC_NAME" ];           then export LC_NAME; fi
if [ -n "$LC_ADDRESS" ];        then export LC_ADDRESS; fi
if [ -n "$LC_TELEPHONE" ];      then export LC_TELEPHONE; fi
if [ -n "$LC_MEASUREMENT" ];    then export LC_MEASUREMENT; fi
if [ -n "$LC_IDENTIFICATION" ]; then export LC_IDENTIFICATION; fi

# End /etc/profile.d/i18n.sh
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /etc/locale.conf << EOF
# Begin /etc/locale.conf

LANG=$LANG

# End /etc/locale.conf
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
source /etc/sysconfig/console &&
KEYMAP=${KEYMAP:-us}          &&

gdbus call --system                                             \
           --dest org.freedesktop.locale1                       \
           --object-path /org/freedesktop/locale1               \
           --method org.freedesktop.locale1.SetVConsoleKeyboard \
           "$KEYMAP" "$KEYMAP_CORRECTIONS" true true
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd