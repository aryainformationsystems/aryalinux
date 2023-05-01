#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:desktop-file-utils
#REQ:gsettings-desktop-schemas
#REQ:gtk3
#REQ:itstool
#REQ:pcre2
#REQ:unzip
#REQ:gobject-introspection
#REQ:vala


cd $SOURCE_DIR

NAME=gucharmap
VERSION=14.0.2
URL=https://gitlab.gnome.org/GNOME/gucharmap/-/archive/14.0.2/gucharmap-14.0.2.tar.bz2
SECTION="GNOME Applications"
DESCRIPTION="Gucharmap is a Unicode character map and font viewer. It allows you to browse through all the available Unicode characters and categories for the installed fonts, and to examine their detailed properties. It is an easy way to find the character you might only know by its Unicode name or code point."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://gitlab.gnome.org/GNOME/gucharmap/-/archive/14.0.2/gucharmap-14.0.2.tar.bz2
wget -nc https://www.unicode.org/Public/zipped/14.0.0/UCD.zip
wget -nc https://www.unicode.org/Public/zipped/14.0.0/Unihan.zip


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


mkdir build                   &&
cd    build                   &&
mkdir ucd                     &&
pushd ucd                     &&
  unzip ../../../UCD.zip      &&
  cp -v ../../../Unihan.zip . &&
popd                          &&

meson --prefix=/usr         \
      --strip               \
      --buildtype=release   \
      -Ducd_path=./ucd      \
      -Ddocs=false ..       &&
ninja
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
rm  -fv /usr/share/glib-2.0/schemas/org.gnome.Charmap.enums.xml &&
ninja install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd