#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:clisp
#REQ:texlive


cd $SOURCE_DIR

NAME=xindy
VERSION=2.5.1
URL=https://tug.ctan.org/support/xindy/base/xindy-2.5.1.tar.gz
SECTION="Typesetting"
DESCRIPTION="Xindy is an index processor that can be used to generate book-like indexes for arbitrary document-preparation systems. This includes systems such as TeX and LaTeX, the roff-family, and SGML/XML-based systems (e.g., HTML) that process some kind of text and generate indexing information."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://tug.ctan.org/support/xindy/base/xindy-2.5.1.tar.gz
wget -nc https://bitbucket.org/chandrakantsingh/patches/raw/1.0/xindy-2.5.1-upstream_fixes-2.patch


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

sed -i "s/ grep -v '^;'/ awk NF/" make-rules/inputenc/Makefile.in &&

sed -i 's%\(indexentry\)%\1\\%' make-rules/inputenc/make-inp-rules.pl &&

patch -Np1 -i ../xindy-2.5.1-upstream_fixes-2.patch &&

./configure --prefix=$TEXLIVE_PREFIX              \
            --bindir=$TEXLIVE_PREFIX/bin/$TEXARCH \
            --datarootdir=$TEXLIVE_PREFIX         \
            --includedir=/usr/include             \
            --libdir=$TEXLIVE_PREFIX/texmf-dist   \
            --mandir=$TEXLIVE_PREFIX/texmf-dist/doc/man &&

make LC_ALL=POSIX
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