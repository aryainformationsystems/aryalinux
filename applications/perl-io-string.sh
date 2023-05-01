#!/bin/bash

set -e
set +h

. /etc/alps/alps.conf
. /var/lib/alps/functions
. /etc/alps/directories.conf



cd $SOURCE_DIR

NAME=perl-io-string
VERSION=1.08
URL=https://cpan.metacpan.org/authors/id/G/GA/GAAS/IO-String-1.08.tar.gz
SECTION="Others"
DESCRIPTION="The IO::String module provides the IO::File interface for in-core strings. An IO::String object can be attached to a string, and makes it possible to use the normal file operations for reading or writing data, as well as for seeking to various locations of the string. This is useful when you want to use a library module that only provides an interface to file handles on data that you have in a string variable."


mkdir -pv $(echo $NAME | sed "s@#@_@g")
pushd $(echo $NAME | sed "s@#@_@g")

wget -nc https://cpan.metacpan.org/authors/id/G/GA/GAAS/IO-String-1.08.tar.gz


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

perl Makefile.PL &&
make -j$(nproc)
sudo make install


if [ ! -z $URL ]; then cd $SOURCE_DIR && cleanup "$NAME" "$DIRECTORY"; fi

register_installed "$NAME" "$VERSION" "$INSTALLED_LIST"

popd