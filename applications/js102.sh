#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:icu
#REQ:rust
#REQ:which
#REQ:llvm


cd $SOURCE_DIR

NAME=js102
VERSION=102.10.
URL=https://archive.mozilla.org/pub/firefox/releases/102.10.0esr/source/firefox-102.10.0esr.source.tar.xz
SECTION="General Libraries"
DESCRIPTION="JS (also referred as SpiderMonkey) is Mozilla's JavaScript and WebAssembly Engine, written in C++ and Rust. In BLFS, the source code of JS is taken from Firefox."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://archive.mozilla.org/pub/firefox/releases/102.10.0esr/source/firefox-102.10.0esr.source.tar.xz


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


if ! grep -ri "/opt/rustc/lib" /etc/ld.so.conf &> /dev/null; then
	echo "/opt/rustc/lib" | sudo tee -a /etc/ld.so.conf
	sudo ldconfig
fi

sudo ldconfig
export PATH=/opt/rustc/bin:$PATH

mountpoint -q /dev/shm || mount -t tmpfs devshm /dev/shm
mkdir obj &&
cd    obj &&

sh ../js/src/configure.in --prefix=/usr            \
                          --with-intl-api          \
                          --with-system-zlib       \
                          --with-system-icu        \
                          --disable-jemalloc       \
                          --disable-debug-symbols  \
                          --enable-readline        &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
rm -fv /usr/lib/libmozjs-102.so
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
PATH=/opt/rustc/bin:$PATH make install &&
rm -v /usr/lib/libjs_static.ajs &&
sed -i '/@NSPR_CFLAGS@/d' /usr/bin/js102-config
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd