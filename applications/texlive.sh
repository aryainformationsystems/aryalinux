#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gs
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


cd $SOURCE_DIR

NAME=texlive
VERSION=2021032
URL=ftp://tug.org/texlive/historic/2021/texlive-20210325-source.tar.xz
SECTION="Typesetting"
DESCRIPTION="Most of TeX Live can be built from source without a pre-existing installation, but xindy (for indexing) needs working versions of latex and pdflatex when configure is run, and the testsuite and install for asy (for vector graphics) will fail if TeX has not already been installed. Additionally, biber is not provided within the texlive source and the version of dvisvgm in the texlive tree cannot be built if shared system libraries are used."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc ftp://tug.org/texlive/historic/2021/texlive-20210325-source.tar.xz
wget -nc ftp://tug.org/texlive/historic/2021/texlive-20210325-texmf.tar.xz
wget -nc ftp://tug.org/texlive/historic/2021/texlive-20210325-tlpdb-full.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/4.0/texlive-20210325-upstream_fixes-1.patch


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


sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
cat >> /etc/ld.so.conf << EOF
# Begin texlive 2021 addition

/opt/texlive/2021/lib

# End texlive 2021 addition
EOF
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

export TEXARCH=$(uname -m |
 sed -e 's/i.86/i386/' -e 's/$/-linux/')                 &&
patch -Np1 -i ../texlive-20210325-upstream_fixes-1.patch &&

mkdir texlive-build &&
cd texlive-build    &&

../configure                                        \
    --prefix=/opt/texlive/2021                      \
    --bindir=/opt/texlive/2021/bin/$TEXARCH         \
    --datarootdir=/opt/texlive/2021                 \
    --includedir=/opt/texlive/2021/include          \
    --infodir=/opt/texlive/2021/texmf-dist/doc/info \
    --libdir=/opt/texlive/2021/lib                  \
    --mandir=/opt/texlive/2021/texmf-dist/doc/man   \
    --disable-native-texlive-build                  \
    --disable-static --enable-shared                \
    --disable-dvisvgm                               \
    --with-system-cairo                             \
    --with-system-fontconfig                        \
    --with-system-freetype2                         \
    --with-system-gmp                               \
    --with-system-graphite2                         \
    --with-system-harfbuzz                          \
    --with-system-icu                               \
    --with-system-libgs                             \
    --with-system-libpaper                          \
    --with-system-libpng                            \
    --with-system-mpfr                              \
    --with-system-pixman                            \
    --with-system-zlib                              \
    --with-banner-add=" - BLFS" &&

make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install-strip &&
/sbin/ldconfig &&
make texlinks &&
mkdir -pv /opt/texlive/2021/tlpkg/TeXLive/ &&
install -v -m644 ../texk/tests/TeXLive/* /opt/texlive/2021/tlpkg/TeXLive/ &&
tar -xf ../../texlive-20210325-tlpdb-full.tar.gz -C /opt/texlive/2021/tlpkg
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
tar -xf ../../texlive-20210325-texmf.tar.xz -C /opt/texlive/2021 --strip-components=1
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
for F in /opt/texlive/2021/texmf-dist/scripts/latex-make/*.py ; do
  sed -i 's%/usr/bin/env python%/usr/bin/python3%' $F
done
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mktexlsr &&
fmtutil-sys --all &&
mtxrun --generate
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd