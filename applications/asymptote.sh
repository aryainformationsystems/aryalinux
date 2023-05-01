#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:gs
#REQ:texlive
#REQ:curl
#REQ:freeglut
#REQ:gc
#REQ:glew
#REQ:glm
#REQ:libtirpc
#REQ:dvisvgm


cd $SOURCE_DIR

NAME=asymptote
VERSION=2.85
URL=https://downloads.sourceforge.net/asymptote/asymptote-2.85.src.tgz
SECTION="Typesetting"
DESCRIPTION="Asymptote is a powerful descriptive vector graphics language that provides a natural coordinate-based framework for technical drawing. Labels and equations can be typeset with LaTeX. As well as EPS, PDF and PNG output it can produce WebGL 3D HTML rendering and (using dvisvgm) SVG output."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://downloads.sourceforge.net/asymptote/asymptote-2.85.src.tgz


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

./configure --prefix=$TEXLIVE_PREFIX                          \
            --bindir=$TEXLIVE_PREFIX/bin/$TEXARCH             \
            --datarootdir=$TEXLIVE_PREFIX/texmf-dist          \
            --infodir=$TEXLIVE_PREFIX/texmf-dist/doc/info     \
            --libdir=$TEXLIVE_PREFIX/texmf-dist               \
            --mandir=$TEXLIVE_PREFIX/texmf-dist/doc/man       \
            --disable-lsp                                     \
            --enable-gc=system                                \
            --with-latex=$TEXLIVE_PREFIX/texmf-dist/tex/latex \
            --with-context=$TEXLIVE_PREFIX/texmf-dist/tex/context/third &&

make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd