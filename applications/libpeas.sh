#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gobject-introspection
#REQ:gtk3
#REQ:libxml2
#REQ:python-modules#pygobject3


cd $SOURCE_DIR

NAME=libpeas
VERSION=1.34.0
URL=https://download.gnome.org/sources/libpeas/1.34/libpeas-1.34.0.tar.xz
SECTION="GNOME Libraries and Desktop"
DESCRIPTION="libpeas is a GObject based plugins engine, and is targeted at giving every application the chance to assume its own extensibility."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://download.gnome.org/sources/libpeas/1.34/libpeas-1.34.0.tar.xz
wget -nc ftp://ftp.acc.umu.se/pub/gnome/sources/libpeas/1.34/libpeas-1.34.0.tar.xz


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

meson setup --prefix=/usr          \
            --buildtype=release    \
            --wrap-mode=nofallback \
            ..                     &&
ninja
sed "/docs_dir =/s@\$@/ 'libpeas-1.34.0'@" \
    -i ../docs/reference/meson.build       &&
meson configure -Dgtk_doc=true             &&
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