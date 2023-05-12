#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:x7lib
#REQ:libdrm
#REQ:python-modules#mako
#REQ:libva
#REQ:libvdpau
#REQ:llvm
#REQ:wayland-protocols
#REQ:glslang

cd $SOURCE_DIR

NAME=mesa
VERSION=23.0.3
URL=https://mesa.freedesktop.org/archive/mesa-23.0.3.tar.xz
SECTION="Graphical Environments"
DESCRIPTION="Mesa is an OpenGL compatible 3D graphics library."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://mesa.freedesktop.org/archive/mesa-23.0.3.tar.xz
wget -nc ftp://ftp.freedesktop.org/pub/mesa/mesa-23.0.3.tar.xz
wget -nc https://raw.githubusercontent.com/aryainformationsystems/patches/1.0/mesa-add_xdemos-2.patch
wget -nc https://archive.mesa3d.org/demos/


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

export XORG_PREFIX="/usr"

patch -Np1 -i ../mesa-add_xdemos-2.patch

export XORG_PREFIX=/usr

mkdir build &&
cd    build &&

meson setup                   \
      --prefix=$XORG_PREFIX   \
      --buildtype=release     \
      -Dplatforms=x11,wayland \
      -Dgallium-drivers=auto  \
      -Dvulkan-drivers=auto   \
      -Dvalgrind=disabled     \
      -Dlibunwind=disabled    \
      ..                      &&
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
install -v -dm755 /usr/share/doc/mesa-23.0.3 &&
cp -rfv ../docs/* /usr/share/doc/mesa-23.0.3
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd