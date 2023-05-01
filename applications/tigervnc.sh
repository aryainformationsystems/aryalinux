#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cmake
#REQ:fltk
#REQ:gnutls
#REQ:libgcrypt
#REQ:libjpeg
#REQ:linux-pam
#REQ:pixman
#REQ:x7app
#REQ:xinit
#REQ:x7legacy
#REQ:imagemagick


cd $SOURCE_DIR

NAME=tigervnc
VERSION=1.13.1
URL=https://github.com/TigerVNC/tigervnc/archive/v1.13.1/tigervnc-1.13.1.tar.gz
SECTION="Other X-based Programs"
DESCRIPTION="Tigervnc is an advanced VNC (Virtual Network Computing) implementation. It allows creation of an Xorg server not tied to a physical console and also provides a client for viewing of the remote graphical desktop."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://github.com/TigerVNC/tigervnc/archive/v1.13.1/tigervnc-1.13.1.tar.gz
wget -nc https://www.x.org/pub/individual/xserver/xorg-server-21.1.6.tar.xz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.0/tigervnc-1.13.1-configuration_fixes-1.patch
wget -nc https://anduin.linuxfromscratch.org/BLFS/tigervnc/vncserver
wget -nc https://anduin.linuxfromscratch.org/BLFS/tigervnc/vncserver.1


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
export XORG_CONFIG="--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static"

patch -Np1 -i ../tigervnc-1.13.1-configuration_fixes-1.patch
# Put code in place
mkdir -p unix/xserver &&
tar -xf ../xorg-server-21.1.6.tar.xz \
    --strip-components=1              \
    -C unix/xserver                   &&
( cd unix/xserver &&
  patch -Np1 -i ../xserver21.1.1.patch ) &&

# Build viewer
cmake -G "Unix Makefiles"         \
      -DCMAKE_INSTALL_PREFIX=/usr \
      -DCMAKE_BUILD_TYPE=Release  \
      -DINSTALL_SYSTEMD_UNITS=OFF \
      -Wno-dev . &&
make &&

# Build server
pushd unix/xserver &&
  autoreconf -fiv  &&

  CPPFLAGS="-I/usr/include/drm"       \
  ./configure $XORG_CONFIG            \
      --disable-xwayland    --disable-dri        --disable-dmx         \
      --disable-xorg        --disable-xnest      --disable-xvfb        \
      --disable-xwin        --disable-xephyr     --disable-kdrive      \
      --disable-devel-docs  --disable-config-hal --disable-config-udev \
      --disable-unit-tests  --disable-selective-werror                 \
      --disable-static      --enable-dri3                              \
      --without-dtrace      --enable-dri2        --enable-glx          \
      --with-pic &&
  make  &&
popd
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
#Install viewer
make install &&

#Install server
( cd unix/xserver/hw/vnc && make install ) &&

[ -e /usr/bin/Xvnc ] || ln -svf $XORG_PREFIX/bin/Xvnc /usr/bin/Xvnc
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
sed -i 's/pam_systemd.so/pam_elogind.so/' /etc/pam.d/tigervnc
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
install -m755 --owner=root ../vncserver /usr/bin &&
cp ../vncserver.1 /usr/share/man/man1
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd