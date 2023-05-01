#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:cairo
#REQ:fontconfig
#REQ:freetype2
#REQ:gc
#REQ:graphite2
#REQ:harfbuzz
#REQ:icu
#REQ:libpaper
#REQ:libpng
#REQ:tex-path
#REQ:python2
#REQ:ruby
#REQ:tk
#REQ:gs


cd $SOURCE_DIR

NAME=texlive
VERSION=2023031
URL=https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2023/texlive-20230313-source.tar.xz
SECTION="Typesetting"
DESCRIPTION="According to https://www.tug.org/historic/ the master site in France only supports ftp and rsync. Now that ftp is generally deprecated, that page has links to mirrors, some of which support https, e.g. in Utah and Chemnitz as well as in China. If you prefer to use a different mirror from the example links here, you will need to navigate to systems/historic/texlive/2023 or systems/texlive/2023 as the case may be."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2023/texlive-20230313-source.tar.xz
wget -nc ftp://tug.org/texlive/historic/2023/texlive-20230313-source.tar.xz
wget -nc https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2023/texlive-20230313-texmf.tar.xz
wget -nc ftp://tug.org/texlive/historic/2023/texlive-20230313-texmf.tar.xz
wget -nc https://ftp.tu-chemnitz.de/pub/tug/historic/systems/texlive/2023/texlive-20230311-tlpdb-full.tar.gz
wget -nc ftp://tug.org/texlive/historic/2023/texlive-20230311-tlpdb-full.tar.gz


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


export TEXARCH=$(uname -m | sed -e 's/i.86/i386/' -e 's/$/-linux/') &&

mkdir texlive-build &&
cd    texlive-build &&

../configure -C                                   \
    --prefix=$TEXLIVE_PREFIX                      \
    --bindir=$TEXLIVE_PREFIX/bin/$TEXARCH         \
    --datarootdir=$TEXLIVE_PREFIX                 \
    --includedir=$TEXLIVE_PREFIX/include          \
    --infodir=$TEXLIVE_PREFIX/texmf-dist/doc/info \
    --libdir=$TEXLIVE_PREFIX/lib                  \
    --mandir=$TEXLIVE_PREFIX/texmf-dist/doc/man   \
    --disable-native-texlive-build                \
    --disable-static --enable-shared              \
    --disable-dvisvgm                             \
    --with-system-cairo                           \
    --with-system-fontconfig                      \
    --with-system-freetype2                       \
    --with-system-gmp                             \
    --with-system-graphite2                       \
    --with-system-harfbuzz                        \
    --with-system-icu                             \
    --with-system-libgs                           \
    --with-system-libpaper                        \
    --with-system-libpng                          \
    --with-system-mpfr                            \
    --with-system-pixman                          \
    --with-system-zlib                            \
    --with-banner-add=" - BLFS" &&

make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install-strip &&
/sbin/ldconfig     &&
make texlinks      &&
mkdir -pv                                $TEXLIVE_PREFIX/tlpkg/TeXLive/ &&
install -v -m644 ../texk/tests/TeXLive/* $TEXLIVE_PREFIX/tlpkg/TeXLive/ &&
tar -xf ../../texlive-20230311-tlpdb-full.tar.gz -C $TEXLIVE_PREFIX/tlpkg
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
tar -xf ../../texlive-20230313-texmf.tar.xz -C $TEXLIVE_PREFIX --strip-components=1
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
for F in $TEXLIVE_PREFIX/texmf-dist/scripts/latex-make/*.py ; do
  sed -i 's%/usr/bin/env python%/usr/bin/python3%' $F
done
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mktexlsr &&
fmtutil-sys --all
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
ln -svf $TEXLIVE_PREFIX/lib/libkpathsea.so /usr/lib
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mkdir -pv $TEXLIVE_PREFIX/texmf-var/luatex-cache/context/ &&

ln -sfv /$TEXLIVE_PREFIX/texmf-dist/scripts/context/lua/mtxrun.lua \
        /$TEXLIVE_PREFIX/bin/$TEXARCH/mtxrun &&

cat > $TEXLIVE_PREFIX/bin/$TEXARCH/context << EOF
#!/bin/sh
export TEXMF=$TEXLIVE_PREFIX/texmf-dist;
export TEXMFCNF=$TEXLIVE_PREFIX/texmf-dist/web2c;
export TEXMFCACHE=$TEXLIVE_PREFIX/texmf-var/luatex-cache/context/;
$TEXLIVE_PREFIX/bin/$TEXARCH/mtxrun --script context "\$@"
EOF
chmod -v 0755 $TEXLIVE_PREFIX/bin/$TEXARCH/context
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd