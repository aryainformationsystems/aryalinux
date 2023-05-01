#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf

#REQ:perl-deps#perl-file-listing
#REQ:perl-deps#perl-http-cookies
#REQ:perl-modules#perl-http-daemon
#REQ:perl-deps#perl-http-negotiate
#REQ:perl-modules#perl-html-parser
#REQ:perl-deps#perl-net-http
#REQ:perl-deps#perl-try-tiny
#REQ:perl-deps#perl-www-robotrules
#REQ:perl-deps#perl-test-fatal
#REQ:perl-deps#perl-test-needs
#REQ:perl-deps#perl-test-requiresinternet


cd $SOURCE_DIR

NAME=perl-deps#perl-libwww-perl
VERSION=6.61
URL=https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.61.tar.gz
SECTION="Others"


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://cpan.metacpan.org/authors/id/O/OA/OALDERS/libwww-perl-6.61.tar.gz


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

perl Makefile.PL &&
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