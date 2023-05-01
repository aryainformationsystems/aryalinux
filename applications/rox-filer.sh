#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:libglade
#REQ:shared-mime-info


cd $SOURCE_DIR

NAME=rox-filer
VERSION=2.11
URL=https://downloads.sourceforge.net/rox/rox-filer-2.11.tar.bz2
SECTION="Other X-based Programs"
DESCRIPTION="rox-filer is a fast, lightweight, gtk2 file manager."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://downloads.sourceforge.net/rox/rox-filer-2.11.tar.bz2


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


cd ROX-Filer                                                        &&
sed -i 's:g_strdup(getenv("APP_DIR")):"/usr/share/rox":' src/main.c &&
sed -i 's/gboolean/extern &/' src/session.h                     &&

mkdir build                        &&
pushd build                        &&
  ../src/configure LIBS="-lm -ldl" &&
  make                             &&
popd
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mkdir -p /usr/share/rox                              &&
cp -av Help Messages Options.xml ROX images style.css .DirIcon /usr/share/rox &&

cp -av ../rox.1 /usr/share/man/man1                  &&
cp -v  ROX-Filer /usr/bin/rox                        &&
chown -Rv root:root /usr/bin/rox /usr/share/rox      &&

cd /usr/share/rox/ROX/MIME                           &&
ln -sv text-x-{diff,patch}.png                       &&
ln -sv application-x-font-{afm,type1}.png            &&
ln -sv application-xml{,-dtd}.png                    &&
ln -sv application-xml{,-external-parsed-entity}.png &&
ln -sv application-{,rdf+}xml.png                    &&
ln -sv application-x{ml,-xbel}.png                   &&
ln -sv application-{x-shell,java}script.png          &&
ln -sv application-x-{bzip,xz}-compressed-tar.png    &&
ln -sv application-x-{bzip,lzma}-compressed-tar.png  &&
ln -sv application-x-{bzip-compressed-tar,lzo}.png   &&
ln -sv application-x-{bzip,xz}.png                   &&
ln -sv application-x-{gzip,lzma}.png                 &&
ln -sv application-{msword,rtf}.png
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

cat > /path/to/hostname/AppRun << "HERE_DOC"
#!/bin/bash

MOUNT_PATH="${0%/*}"
HOST=${MOUNT_PATH##*/}
export MOUNT_PATH HOST
sshfs -o nonempty ${HOST}:/ ${MOUNT_PATH}
rox -x ${MOUNT_PATH}
HERE_DOC

chmod 755 /path/to/hostname/AppRun
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat > /usr/bin/myumount << "HERE_DOC" &&
#!/bin/bash
sync
if mount | grep "${@}" | grep -q fuse
then fusermount -u "${@}"
else umount "${@}"
fi
HERE_DOC

chmod 755 /usr/bin/myumount
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ln -s ../rox/.DirIcon /usr/share/pixmaps/rox.png &&
mkdir -p /usr/share/applications &&

cat > /usr/share/applications/rox.desktop << "HERE_DOC"
[Desktop Entry]
Encoding=UTF-8
Type=Application
Name=Rox
Comment=The Rox File Manager
Icon=rox
Exec=rox
Categories=GTK;Utility;Application;System;Core;
StartupNotify=true
Terminal=false
HERE_DOC
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd