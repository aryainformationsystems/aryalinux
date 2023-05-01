#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:curl


cd $SOURCE_DIR

NAME=git
VERSION=2.35.1
URL=https://www.kernel.org/pub/software/scm/git/git-2.35.1.tar.xz
SECTION="Programming"
DESCRIPTION="Git is a free and open source, distributed version control system designed to handle everything from small to very large projects with speed and efficiency. Every Git clone is a full-fledged repository with complete history and full revision tracking capabilities, not dependent on network access or a central server. Branching and merging are fast and easy to do. Git is used for version control of files, much like tools such as Mercurial-6.0.2, Bazaar, Subversion-1.14.1, CVS, Perforce, and Team Foundation Server."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://www.kernel.org/pub/software/scm/git/git-2.35.1.tar.xz
wget -nc https://www.kernel.org/pub/software/scm/git/git-manpages-2.35.1.tar.xz
wget -nc https://www.kernel.org/pub/software/scm/git/git-htmldocs-2.35.1.tar.xz


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


./configure --prefix=/usr \
            --with-gitconfig=/etc/gitconfig \
            --with-python=python3 &&
make
sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
make perllibdir=/usr/lib/perl5/5.34/site_perl install
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh

sudo rm -rf /tmp/rootscript.sh
cat > /tmp/rootscript.sh <<"ENDOFROOTSCRIPT"
mkdir -vp   /usr/share/doc/git-2.35.1 &&
tar   -xf   ../git-htmldocs-2.35.1.tar.xz \
      -C    /usr/share/doc/git-2.35.1 --no-same-owner --no-overwrite-dir &&

find        /usr/share/doc/git-2.35.1 -type d -exec chmod 755 {} \; &&
find        /usr/share/doc/git-2.35.1 -type f -exec chmod 644 {} \;
ENDOFROOTSCRIPT

chmod a+x /tmp/rootscript.sh
sudo /tmp/rootscript.sh
sudo rm -rf /tmp/rootscript.sh



if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd